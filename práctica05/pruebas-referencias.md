# Ejercicio 2.3. Pruebas de Integridad Referencial

**Proyecto Propio:** Sistema de Prevención y Detección de Lavado de Dinero (UIF)  
**Gestor:** PostgreSQL 16 (Contenedor Docker `practica01` / puerto 5434)  

---

## 1. Pruebas por Acción Referencial con Datos Reales

### Caso A: Comprobación de `ON DELETE CASCADE` (`reporte_uif` -> `desglose`)
* **Regla Protegida:** Las partidas del desglose dependen por completo del reporte regulatorio. Si el reporte se anula, sus partidas se eliminan en cascada sin dejar residuos.
* **Estado Previo (Conteos):**
  ```sql
  SELECT COUNT(*) FROM reporte_uif WHERE id_reporte = 101;
  -- Resultado: 1
  SELECT COUNT(*) FROM desglose WHERE id_reporte = 101;
  -- Resultado: 4
  ```
* **Sentencia DML de Eliminación del Padre:**
  ```sql
  DELETE FROM reporte_uif WHERE id_reporte = 101;
  ```
* **Estado Posterior (Conteos):**
  ```sql
  SELECT COUNT(*) FROM reporte_uif WHERE id_reporte = 101;
  -- Resultado: 0
  SELECT COUNT(*) FROM desglose WHERE id_reporte = 101;
  -- Resultado: 0  <-- Verificado: 4 partidas hijas borradas automáticamente por CASCADE
  ```

---

### Caso B: Comprobación de `ON DELETE RESTRICT` (`cuenta_bancaria` -> `transaccion`)
* **Regla Protegida:** Inalterabilidad de la pista de auditoría financiera. Una cuenta bancaria no puede borrarse mientras tenga transacciones activas en el historial de transferencias.
* **Estado Previo (Conteos):**
  ```sql
  SELECT COUNT(*) FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
  -- Resultado: 1
  SELECT COUNT(*) FROM transaccion WHERE cuenta_origen = '4152313188992211';
  -- Resultado: 6
  ```
* **Sentencia DML Ejecutada:**
  ```sql
  DELETE FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
  ```
* **Respuesta del Gestor (Bloqueo por RESTRICT):**
  ```text
  ERROR:  update or delete on table "cuenta_bancaria" violates foreign key constraint "fk_transaccion_cuenta_origen" on table "transaccion"
  DETAIL:  Key (numero_cuenta)=(4152313188992211) is still referenced from table "transaccion".
  ```
* **Estado Posterior (Conteos Inalterados):**
  ```sql
  SELECT COUNT(*) FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
  -- Resultado: 1 (Registro protegido intacto)
  SELECT COUNT(*) FROM transaccion WHERE cuenta_origen = '4152313188992211';
  -- Resultado: 6 (Historial transaccional íntegro)
  ```

---

## 2. Inserción con Clave Foránea Inexistente (Huérfano Rechazado)

* **Operación:** Intento de registrar una transferencia bancaria desde una cuenta que no existe en el catálogo maestro de cuentas de la UIF.
* **Sentencia DML:**
  ```sql
  INSERT INTO transaccion (id_transaccion, cuenta_origen, cuenta_destino, monto, fecha_hora)
  VALUES (99999, '0000000000000000', '4152313188992211', 850000.00, '2026-11-02 12:00:00');
  ```
* **Mensaje de Error Devuelto por PostgreSQL:**
  ```text
  ERROR:  insert or update on table "transaccion" violates foreign key constraint "fk_transaccion_cuenta_origen"
  DETAIL:  Key (cuenta_origen)=(0000000000000000) is not present in table "cuenta_bancaria".
  ```
* **Regla Protegida:** Ninguna transacción puede atribuirse a cuentas fantasmas o inexistentes en el sistema financiero.

---

## 3. Demostración del Orden de Carga de Dependencias

### El problema de invertir el orden de carga:
Si el script automatizado intentara cargar primero las tablas dependientes (hijas) antes que sus catálogos maestros (padres):
```bash
# Intento incorrecto: Cargar transacciones antes que cuentas bancarias
psql -U usr_app -d UIF -c "\copy transaccion FROM 'datos/transacciones.csv' CSV HEADER;"
```
* **Salida del Gestor:**
  ```text
  ERROR:  insert or update on table "transaccion" violates foreign key constraint "fk_transaccion_cuenta_origen"
  DETAIL:  Key (cuenta_origen)=(1234567890123456) is not present in table "cuenta_bancaria".
  CONTEXT:  COPY transaccion, line 2: "1,1234567890123456,6543210987654321,150000.00,2026-10-15 08:30:00"
  ```

### Solución Arquitectural en el Script de Carga (`bd_uif.py`):
El pipeline de ingesta establece una secuencia estricta basada en el **Grafo Dirigido Acíclico (DAG)** de dependencias relacionales:

1. **Nivel 0 (Tablas Padre independientes):**
   * `contribuyente`
   * `bien`
   * `entidad_reportante`
2. **Nivel 1 (Dependencias directas del Nivel 0):**
   * `persona_fisica`
   * `persona_moral`
   * `telefono`
   * `lista_bloqueados`
   * `cuenta_bancaria`
   * `reporte_uif`
3. **Nivel 2 (Dependencias compuestas):**
   * `operacion_vulnerable` (depende de `contribuyente`, `bien`, `entidad_reportante`)
   * `desglose` (depende de `reporte_uif`)
   * `transaccion` (depende de `cuenta_bancaria`)
4. **Nivel 3 (Dependencias de monitoreo):**
   * `alerta` (depende de `transaccion`)
5. **Nivel 4 (Dependencias de judicialización):**
   * `expediente` (depende de `alerta`)

Al ejecutar en este orden estricto, la carga es 100% determinista y libre de colisiones por claves foráneas.

---

## 4. Consultas de Comprobación de Integridad (Resultado Esperado: 0 Renglones)

Las siguientes consultas de auditoría se ejecutan periódicamente sobre la base de datos poblada; si cualquiera arroja un renglón, significa que la integridad referencial se ha corrompido:

### Comprobación 4.1: Detección de Transacciones Huérfanas
```sql
SELECT t.id_transaccion, t.cuenta_origen, t.cuenta_destino
FROM transaccion t
LEFT JOIN cuenta_bancaria c_orig ON t.cuenta_origen = c_orig.numero_cuenta
LEFT JOIN cuenta_bancaria c_dest ON t.cuenta_destino = c_dest.numero_cuenta
WHERE c_orig.numero_cuenta IS NULL OR c_dest.numero_cuenta IS NULL;
```
* **Resultado:** `(0 rows)`

### Comprobación 4.2: Detección de Expedientes Judiciales sin Alerta Válida
```sql
SELECT e.num_expediente, e.id_alerta
FROM expediente e
LEFT JOIN alerta a ON e.id_alerta = a.id_alerta
WHERE a.id_alerta IS NULL;
```
* **Resultado:** `(0 rows)`

### Comprobación 4.3: Detección de RFCs duplicados o inválidos en Subtipos
```sql
SELECT pf.rfc, COUNT(*)
FROM persona_fisica pf
GROUP BY pf.rfc
HAVING COUNT(*) > 1;
```
* **Resultado:** `(0 rows)`

### Comprobación 4.4: Detección de Desgloses sin Reporte Contenedor
```sql
SELECT d.id_reporte, d.numero_renglon
FROM desglose d
LEFT JOIN reporte_uif r ON d.id_reporte = r.id_reporte
WHERE r.id_reporte IS NULL;
```
* **Resultado:** `(0 rows)`
