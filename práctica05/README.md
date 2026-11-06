# Práctica 5: Edición de Valores empleando DML e Integridad Referencial

Este directorio contiene la totalidad de los entregables correspondientes a la **Práctica 5** de la Unidad de Aprendizaje de *Bases de Datos* (Plan 2020 - Ingeniería en Inteligencia Artificial).

---

## 📂 Contenido del Directorio

| Archivo / Carpeta | Ejercicio Correspondiente | Descripción |
|---|:---:|---|
| **`referencias.md`** | **Ejercicio 2.1 y 2.2** | Inventario formal de todas las claves foráneas, cardinalidades, nulabilidad y justificación de acciones referenciales (`CASCADE`/`RESTRICT`) en una sola línea. |
| **`migraciones/003-referencias.sql`** | **Continuidad DDL** | Script SQL de migración numerado para estandarizar las claves foráneas con `ALTER TABLE`. |
| **`pruebas-referencias.md`** | **Ejercicio 2.3** | Pruebas de integridad referencial con datos reales: conteos antes/después de DELETE, rechazo de huérfanos, orden de dependencias de carga y 4 consultas de auditoría en cero. |
| **`transacciones-dml.md`** | **Ejercicio 2.4** | Documentación de sentencias DML complejas: INSERT con SELECT y ON CONFLICT, UPDATEs con JOIN y CASE, DELETE vs. Borrado lógico, Transacciones con SAVEPOINT y prueba de atomicidad ante fallo. |
| **`scripts/ejecutar_transacciones_dml.sql`** | **Ejercicio 2.4 (Ejecución)** | Script SQL ejecutable en bloque con todas las sentencias DML y transacciones del ejercicio 2.4. |
| **`almacen-sismos.md`** | **Ejercicio 2.5** | Proyecto asignado (DWSismos): Identificación de hechos, dimensiones, definición de granularidad, consultas de detección de huérfanos y análisis de omisión de FKs en Big Data / OLAP. |
| **`ejercicio-individual.md`** | **Ejercicio 2.6** | Trabajo individual firmado: Análisis de impacto al cambiar `RESTRICT` a `CASCADE` en la relación `cuenta_bancaria -> transaccion`. |
| **`evidencias/`** | **Evidencias** | Capturas y bitácoras de ejecución de pruebas en consola de PostgreSQL. |

---

## 🚀 Guía de Ejecución Rápida

### 1. Aplicar la migración de claves foráneas
```bash
docker exec -i practica01 psql -U usr_admin -d UIF < migraciones/003-referencias.sql
```

### 2. Ejecutar las transacciones y operaciones DML
```bash
docker exec -i practica01 psql -U usr_app -d UIF < scripts/ejecutar_transacciones_dml.sql
```

### 3. Ejecutar las comprobaciones de auditoría (no huérfanos)
```bash
docker exec -i practica01 psql -U usr_consulta -d UIF -c "
SELECT t.id_transaccion 
FROM transaccion t 
LEFT JOIN cuenta_bancaria c ON t.cuenta_origen = c.numero_cuenta 
WHERE c.numero_cuenta IS NULL;"
```
