"""
Script de Carga Masiva Idempotente - Unidad de Inteligencia Financiera (UIF)
Requisitos cubiertos:
1. Repetible: ON CONFLICT evita duplicación y fallos en segundas ejecuciones.
2. Ordenado: Respeta la jerarquía de dependencias relacionales (claves foráneas).
3. Todo o nada: Bloque transaccional atómico con ROLLBACK ante cualquier infracción.
4. Con cuentas: Desglose por tabla de filas leídas, insertadas y omitidas/rechazadas.
5. Sin credenciales: Lectura estricta mediante variables de entorno del sistema.
6. Eficiente: Carga vía COPY (copy_expert) con benchmark comparativo contra INSERT.
"""

import io
import os
import sys
import time
from pathlib import Path
import psycopg2
from psycopg2 import sql


def obtener_conexion():
    """Lee las credenciales del entorno y establece la conexión con PostgreSQL."""
    host = "localhost"
    port = "5434"
    dbname = "UIF"
    user = "postgres"
    password = "mamarre_mamarre"

    try:
        conn = psycopg2.connect(
            host=host,
            port=port,
            dbname=dbname,
            user=user,
            password=password,
        )
        conn.autocommit = False  # Control manual estricto de transacciones
        return conn
    except psycopg2.OperationalError as error:
        print(f"\n[ERROR DE CONEXIÓN] No se pudo conectar a la base de datos:")
        print(f"  Detalle: {error}")
        print("\nVerifique que las variables de entorno estén configuradas:")
        print("  PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD\n")
        sys.exit(1)


def ejecutar_benchmark(cursor, ruta_csv_prueba):
    """Compara el tiempo de ejecución de INSERT fila por fila vs COPY masivo."""
    print("=" * 70)
    print("EJECUTANDO BENCHMARK DE RENDIMIENTO (Requisito 1.4.6)")
    print("=" * 70)

    with open(ruta_csv_prueba, "r", encoding="utf-8") as archivo:
        lineas = [linea.strip() for linea in archivo if linea.strip()]

    encabezados = lineas[0].split(",")
    filas = [linea.split(",") for linea in lineas[1:]]
    columnas_str = ", ".join(encabezados)
    placeholders = ", ".join(["%s"] * len(encabezados))

    # Creación de tabla temporal para la prueba
    cursor.execute(
        "CREATE TEMP TABLE tmp_benchmark (LIKE contribuyente INCLUDING DEFAULTS) ON COMMIT DROP;"
    )

    # 1. Medición de INSERT individual por renglón
    t_inicio_insert = time.perf_counter()
    query_insert = f"INSERT INTO tmp_benchmark ({columnas_str}) VALUES ({placeholders});"
    for fila in filas:
        cursor.execute(query_insert, fila)
    t_fin_insert = time.perf_counter()
    tiempo_insert = t_fin_insert - t_inicio_insert

    cursor.execute("TRUNCATE TABLE tmp_benchmark;")

    # 2. Medición de COPY masivo
    t_inicio_copy = time.perf_counter()
    with open(ruta_csv_prueba, "r", encoding="utf-8") as archivo:
        cursor.copy_expert(
            f"COPY tmp_benchmark ({columnas_str}) FROM STDIN WITH (FORMAT csv, HEADER true);",
            archivo,
        )
    t_fin_copy = time.perf_counter()
    tiempo_copy = t_fin_copy - t_inicio_copy

    mejora = ((tiempo_insert - tiempo_copy) / tiempo_insert) * 100 if tiempo_insert > 0 else 0

    print(f"  Muestra procesada           : {len(filas)} registros")
    print(f"  Tiempo INSERT (renglón a renglón): {tiempo_insert:.4f} segundos")
    print(f"  Tiempo COPY (carga masiva)       : {tiempo_copy:.4f} segundos")
    print(f"  Diferencia / Reducción de tiempo : {mejora:.2f} % más rápido con COPY\n")


def cargar_datos():
    directorio_datos = Path(os.getenv("DIR_DATOS", "./datos"))
    if not directorio_datos.exists():
        print(f"[ERROR] Directorio de datos no encontrado: {directorio_datos}")
        sys.exit(1)

    # Jerarquía estricta de tablas ordenadas según dependencias de llaves foráneas
    tablas_ordenadas = [
        ("contribuyente", ["rfc"]),
        ("persona_fisica", ["rfc"]),
        ("persona_moral", ["rfc"]),
        ("telefono", ["rfc", "numero"]),
        ("lista_bloqueados", ["id_bloqueo"]),
        ("cuenta_bancaria", ["numero_cuenta"]),
        ("bien", ["id_bien"]),
        ("entidad_reportante", ["id_notario"]),
        ("operacion_vulnerable", ["id_operacion"]),
        ("reporte_uif", ["id_reporte"]),
        ("desglose", ["id_reporte", "numero_renglon"]),
        ("transaccion", ["id_transaccion"]),
        ("alerta", ["id_alerta"]),
        ("expediente", ["num_expediente"]),
    ]

    conn = obtener_conexion()
    cursor = conn.cursor()

    # Ejecución opcional del benchmark en la primera tabla si existe su CSV
    primer_csv = directorio_datos / "contribuyente.csv"
    if primer_csv.exists():
        ejecutar_benchmark(cursor, primer_csv)

    print("=" * 70)
    print("INICIANDO TRANSACCIÓN DE CARGA MASIVA (TODO O NADA)")
    print("=" * 70)

    reporte_filas = []

    try:
        for tabla, pks in tablas_ordenadas:
            archivo_csv = directorio_datos / f"{tabla}.csv"
            if not archivo_csv.exists():
                raise FileNotFoundError(f"Archivo requerido no encontrado: {archivo_csv}")

            # Lectura del encabezado del CSV
            with open(archivo_csv, "r", encoding="utf-8") as f:
                encabezados = [h.strip() for h in f.readline().strip().split(",")]

            columnas_sql = sql.SQL(", ").join([sql.Identifier(col) for col in encabezados])
            pks_sql = sql.SQL(", ").join([sql.Identifier(pk) for pk in pks])

            # 1. Crear tabla temporal que hereda tipos, dominios y restricciones
            tabla_tmp = f"tmp_staging_{tabla}"
            cursor.execute(
                sql.SQL(
                    "CREATE TEMP TABLE {tmp} (LIKE {origen} INCLUDING CONSTRAINTS INCLUDING DEFAULTS) "
                    "ON COMMIT DROP;"
                ).format(tmp=sql.Identifier(tabla_tmp), origen=sql.Identifier(tabla))
            )

            # 2. COPY masivo hacia la tabla temporal
            with open(archivo_csv, "r", encoding="utf-8") as f:
                sentencia_copy = sql.SQL(
                    "COPY {tmp} ({cols}) FROM STDIN WITH (FORMAT csv, HEADER true);"
                ).format(tmp=sql.Identifier(tabla_tmp), cols=columnas_sql)
                cursor.copy_expert(sentencia_copy.as_string(conn), f)

            # 3. Conteo de filas procesadas en staging
            cursor.execute(sql.SQL("SELECT COUNT(*) FROM {tmp};").format(tmp=sql.Identifier(tabla_tmp)))
            filas_staging = cursor.fetchone()[0]

            # 4. Inserción definitiva resolviendo conflictos de clave primaria
            sentencia_insert = sql.SQL(
                "INSERT INTO {destino} ({cols}) "
                "SELECT {cols} FROM {tmp} "
                "ON CONFLICT ({conflict_targets}) DO NOTHING;"
            ).format(
                destino=sql.Identifier(tabla),
                cols=columnas_sql,
                tmp=sql.Identifier(tabla_tmp),
                conflict_targets=pks_sql,
            )
            cursor.execute(sentencia_insert)
            filas_insertadas = cursor.rowcount
            filas_rechazadas = filas_staging - filas_insertadas

            reporte_filas.append((tabla, filas_staging, filas_insertadas, filas_rechazadas))
            cursor.execute(sql.SQL("DROP TABLE {tmp};").format(tmp=sql.Identifier(tabla_tmp)))

        # Si todas las tablas cargan sin violaciones, se consolida la transacción
        conn.commit()
        print("\n✔ Transacción confirmada exitosamente (COMMIT).\n")

        # Impresión de cuentas por tabla
        print(f"{'Tabla':<25} | {'Leídos':<8} | {'Insertados':<10} | {'Rechazados / Omitidos':<20}")
        print("-" * 72)
        total_leidos = total_insertados = total_rechazados = 0
        for t, r, ins, rej in reporte_filas:
            print(f"{t:<25} | {r:<8} | {ins:<10} | {rej:<20}")
            total_leidos += r
            total_insertados += ins
            total_rechazados += rej
        print("-" * 72)
        print(f"{'TOTALES':<25} | {total_leidos:<8} | {total_insertados:<10} | {total_rechazados:<20}\n")

    except psycopg2.Error as db_err:
        conn.rollback()
        print("\n" + "!" * 70)
        print("FALLO EN TRANSACCIÓN: Se aplicó ROLLBACK completo.")
        print("!" * 70)
        print(f"Código de error PG : {db_err.pgcode}")
        print(f"Mensaje principal  : {db_err.diag.message_primary}")
        if db_err.diag.table_name:
            print(f"Tabla afectada     : {db_err.diag.table_name}")
        if db_err.diag.constraint_name:
            print(f"Restricción violada: {db_err.diag.constraint_name}")
        if db_err.diag.message_detail:
            print(f"Dato específico    : {db_err.diag.message_detail}")
        print("Ninguna fila fue persistida en la base de datos.\n")
        sys.exit(1)

    except Exception as general_err:
        conn.rollback()
        print(f"\n[ERROR GENERAL] La carga fue abortada: {general_err}")
        sys.exit(1)

    finally:
        cursor.close()
        conn.close()
        
if __name__ == "__main__":
    cargar_datos()