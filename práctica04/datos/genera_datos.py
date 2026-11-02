"""
Script Generador de Datos Sintéticos - Proyecto UIF
Genera un mínimo de 200 registros por tabla respetando estrictamente
las restricciones de dominio (Regex, catálogos IN, montos > 0, fechas válidas).
"""

import os
import csv
import random
from datetime import datetime, timedelta
from faker import Faker

# Inicializar Faker con localización mexicana
fake = Faker('es_MX')
Faker.seed(42)
random.seed(42)

DIR_DATOS = "./datos"
os.makedirs(DIR_DATOS, exist_ok=True)

# FUNCIONES AUXILIARES DE GENERACIÓN DE DOMINIOS ESTRICTOS

def generar_rfc_fisica():
    """Genera RFC de Persona Física: 4 letras, 6 números, 3 alfanuméricos"""
    letras = "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ", k=4))
    fecha = fake.date_of_birth(minimum_age=18, maximum_age=80).strftime("%y%m%d")
    homoclave = "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=3))
    return f"{letras}{fecha}{homoclave}"

def generar_rfc_moral():
    """Genera RFC de Persona Moral: 3 letras, 6 números, 3 alfanuméricos"""
    letras = "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ", k=3))
    fecha = fake.date_between(start_date='-30y', end_date='today').strftime("%y%m%d")
    homoclave = "".join(random.choices("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", k=3))
    return f"{letras}{fecha}{homoclave}"

def generar_curp(rfc):
    """Genera CURP válida basándose en la fecha del RFC"""
    letras_rfc = rfc[:4]
    fecha = rfc[4:10]
    sexo = random.choice(['H', 'M'])
    estado = random.choice(["AS", "BC", "BS", "CC", "CL", "CM", "CS", "CH", "DF", "DG", "GT", "GR", "HG", "JC", "MC", "MN", "MS", "NT", "NL", "OC", "PL", "QT", "QR", "SP", "SL", "SR", "TC", "TS", "TL", "VZ", "YN", "ZS"])
    consonantes = "".join(random.choices("BCDFGHJKLMNPQRSTVWXYZ", k=3))
    homoclave = "".join(random.choices("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", k=1))
    digito = str(random.randint(0, 9))
    return f"{letras_rfc}{fecha}{sexo}{estado}{consonantes}{homoclave}{digito}"

def generar_telefono():
    """Dominio teléfono: Exactamente 10 dígitos numéricos"""
    return f"{random.randint(1000000000, 9999999999)}"

def generar_cuenta():
    """Dominio número de cuenta: Exactamente 16 dígitos numéricos"""
    return f"{random.randint(1000000000000000, 9999999999999999)}"

def guardar_csv(nombre_archivo, encabezados, filas):
    ruta = os.path.join(DIR_DATOS, f"{nombre_archivo}.csv")
    # newline='' es crítico en Windows para evitar saltos de línea dobles
    with open(ruta, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(encabezados)
        writer.writerows(filas)
    print(f"✔ {nombre_archivo}.csv generado ({len(filas)} filas).")

# GENERACIÓN DE ENTIDADES (Min 200 filas por tabla, respetando FKs)

print("Generando datos sintéticos UIF...")

# 1, 2, 3. Contribuyentes (200 Físicas y 200 Morales = 400 total)
rfcs_fisicas = list(set([generar_rfc_fisica() for _ in range(250)]))[:200]
rfcs_morales = list(set([generar_rfc_moral() for _ in range(250)]))[:200]
rfcs_totales = rfcs_fisicas + rfcs_morales

contribuyentes = []
for rfc in rfcs_totales:
    calle = fake.street_address().replace(',', '')[:50]
    cp = f"{random.randint(10000, 99999)}"
    actividad = fake.job().replace(',', '')[:50]
    e_firma = fake.sha256()[:20]
    contribuyentes.append([rfc, calle, cp, actividad, e_firma])

personas_fisicas = []
for rfc in rfcs_fisicas:
    curp = generar_curp(rfc)
    nombre = fake.name().replace(',', '')
    ingresos = round(random.uniform(10000.0, 500000.0), 2)
    personas_fisicas.append([rfc, curp, nombre, ingresos])

personas_morales = []
for rfc in rfcs_morales:
    rep_legal = fake.name().replace(',', '')
    razon_social = fake.company().replace(',', '')
    # Fecha no futura
    fecha_const = fake.date_between(start_date='-50y', end_date='today')
    personas_morales.append([rfc, rep_legal, razon_social, fecha_const])

guardar_csv("contribuyente", ["rfc", "calle", "codigo_postal", "actividad_economica", "e_firma"], contribuyentes)
guardar_csv("persona_fisica", ["rfc", "curp", "nombre", "ingresos"], personas_fisicas)
guardar_csv("persona_moral", ["rfc", "representante_legal", "razon_social", "fecha_constitucion"], personas_morales)


# 4. Teléfono (200 registros)
telefonos = []
for _ in range(200):
    telefonos.append([random.choice(rfcs_totales), generar_telefono()])
guardar_csv("telefono", ["rfc", "numero"], telefonos)


# 5. Lista Bloqueados (200 registros)
bloqueados = []
rfcs_bloqueados = random.sample(rfcs_totales, 200) # UNIQUE
for i, rfc in enumerate(rfcs_bloqueados, start=1):
    fecha = fake.date_between(start_date='-5y', end_date='today')
    motivo = random.choice(["Operaciones inusuales", "Orden judicial", "Financiamiento ilícito", "Fraude fiscal"])
    bloqueados.append([i, rfc, fecha, motivo])
guardar_csv("lista_bloqueados", ["id_bloqueo", "rfc", "fecha_bloqueo", "motivo"], bloqueados)


# 6. Cuenta Bancaria (200 registros)
cuentas = []
numeros_cuenta = list(set([generar_cuenta() for _ in range(250)]))[:200]
for num_cuenta in numeros_cuenta:
    rfc = random.choice(rfcs_totales)
    fecha = fake.date_between(start_date='-10y', end_date='today')
    saldo = round(random.uniform(500.0, 9000000.0), 2)
    cuentas.append([num_cuenta, rfc, fecha, saldo])
guardar_csv("cuenta_bancaria", ["numero_cuenta", "rfc", "fecha_apertura", "saldo"], cuentas)


# 7. Bien (200 registros)
bienes = []
tipos_bien_permitidos = ['Inmueble', 'Vehículo', 'Aeronave', 'Embarcación', 'Joya o metal precioso', 'Obra de arte', 'Blindaje', 'Activo virtual']
for i in range(1, 201):
    bienes.append([i, random.choice(tipos_bien_permitidos), round(random.uniform(50000.0, 10000000.0), 2)])
guardar_csv("bien", ["id_bien", "tipo_bien", "valor_comercial"], bienes)


# 8. Entidad Reportante (200 registros)
entidades = []
sectores_permitidos = ['Bancario y Financiero', 'Notarial y Fe Pública', 'Inmobiliario y Construcción', 'Metales Preciosos y Joyería', 'Juegos con Apuesta y Sorteos', 'Vehículos y Blindaje', 'Activos Virtuales y Fintech']
for i in range(1, 201):
    entidades.append([i, f"{fake.company().replace(',', '')} SA de CV", random.choice(sectores_permitidos)])
guardar_csv("entidad_reportante", ["id_notario", "nombre_institucion", "sector_economico"], entidades)


# 9. Operación Vulnerable (200 registros)
operaciones = []
for i in range(1, 201):
    rfc = random.choice(rfcs_totales)
    id_bien = random.randint(1, 200)
    id_notario = random.randint(1, 200)
    monto = round(random.uniform(10000.0, 5000000.0), 2)
    fecha = fake.date_between(start_date='-2y', end_date='today')
    operaciones.append([i, rfc, id_bien, id_notario, monto, fecha])
guardar_csv("operacion_vulnerable", ["id_operacion", "rfc", "id_bien", "id_notario", "valor_pactado", "fecha_operacion"], operaciones)


# 10. Reporte UIF (200 registros)
reportes = []
tipos_reporte = ['Operación Relevante', 'Operación Inusual', 'Operación Preocupante', 'Aviso de Actividad Vulnerable']
for i in range(1, 201):
    reportes.append([
        random.randint(1, 200), # id_notario
        i,                      # id_reporte
        random.choice(tipos_reporte),
        fake.date_between(start_date='-1y', end_date='today'),
        round(random.uniform(50000.0, 15000000.0), 2)
    ])
guardar_csv("reporte_uif", ["id_notario", "id_reporte", "tipo_reporte", "fecha_recepcion", "monto_total"], reportes)


# 11. Desglose (250 registros, varios renglones por reporte)
desgloses = []
divisas = ['MXN', 'USD', 'EUR', 'CAD', 'GBP', 'CHF']
for id_rep in range(1, 201):
    for num_renglon in range(1, random.randint(2, 4)):
        desc = fake.sentence(nb_words=6).replace(',', '')
        monto = round(random.uniform(1000.0, 50000.0), 2)
        desgloses.append([id_rep, num_renglon, desc, monto, random.choice(divisas)])
guardar_csv("desglose", ["id_reporte", "numero_renglon", "descripcion", "monto", "divisa"], desgloses)


# 12. Transacción (200 registros - requiere 2 cuentas distintas)
transacciones = []
for i in range(1, 201):
    ctas = random.sample(numeros_cuenta, 2)
    monto = round(random.uniform(500.0, 1000000.0), 2)
    fecha_hora = fake.date_time_between(start_date='-2y', end_date='now').strftime("%Y-%m-%d %H:%M:%S")
    transacciones.append([i, ctas[0], ctas[1], monto, fecha_hora])
guardar_csv("transaccion", ["id_transaccion", "cuenta_origen", "cuenta_destino", "monto", "fecha_hora"], transacciones)


# 13. Alerta (200 registros)
alertas = []
niveles_riesgo = ['Bajo', 'Medio', 'Alto', 'Crítico']
for i in range(1, 201):
    id_trans = random.randint(1, 200)
    fecha_hora = fake.date_time_between(start_date='-1y', end_date='now').strftime("%Y-%m-%d %H:%M:%S")
    alertas.append([i, id_trans, fecha_hora, random.choice(niveles_riesgo)])
guardar_csv("alerta", ["id_alerta", "id_transaccion", "fecha_alerta", "nivel_riesgo"], alertas)


# 14. Expediente (200 registros)
expedientes = []
ids_alerta = random.sample(range(1, 201), 200) # UNIQUE
for i in range(1, 201):
    fecha = fake.date_between(start_date='-6m', end_date='today')
    fiscal = fake.name().replace(',', '')
    expedientes.append([i, ids_alerta[i-1], fecha, fiscal])
guardar_csv("expediente", ["num_expediente", "id_alerta", "fecha_apertura", "fiscal_asignado"], expedientes)

print("\n🎉 Todos los archivos CSV se han generado correctamente.")


# INYECCIÓN DE ERRORES DELIBERADOS
print("\nInyectando 3 errores intencionales para probar el ROLLBACK del script de carga...")

# 1. Error de Dominio (Monto negativo en persona física)
pf_path = os.path.join(DIR_DATOS, "persona_fisica.csv")
with open(pf_path, 'a', encoding='utf-8') as f:
    f.write(f"{rfcs_fisicas[0]},{generar_curp(rfcs_fisicas[0])},Test Error Monto,-5000.00\n")

# 2. Error de Restricción CHECK cruzada (Transacción origen = destino)
tr_path = os.path.join(DIR_DATOS, "transaccion.csv")
with open(tr_path, 'a', encoding='utf-8') as f:
    f.write(f"999,{numeros_cuenta[0]},{numeros_cuenta[0]},10000.00,2023-01-01 10:00:00\n")

# 3. Error de Catálogo (Nivel de riesgo inválido en alerta)
al_path = os.path.join(DIR_DATOS, "alerta.csv")
with open(al_path, 'a', encoding='utf-8') as f:
    f.write(f"999,1,2023-01-01 10:00:00,Super Extremo\n")