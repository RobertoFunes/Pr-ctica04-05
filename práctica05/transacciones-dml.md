# Ejercicio 2.4. Edición de Valores (DML) y Control de Transacciones (TCL)

**Proyecto Propio:** Sistema de Prevención y Detección de Lavado de Dinero (UIF)  
**Gestor:** PostgreSQL 16  

---

## 1. INSERT con SELECT y Resolución de Conflictos (UPSERT / Idempotencia)

### Situación de Negocio:
El motor analítico de la UIF debe evaluar las transferencias bancarias de alto monto e insertar de forma masiva en la tabla `alerta` a aquellas transacciones superiores a \$500,000 MXN. En caso de que la alerta ya haya sido generada en una ejecución previa, no debe arrojar error ni duplicar el registro.

```sql
INSERT INTO alerta (id_alerta, id_transaccion, fecha_alerta, nivel_riesgo)
SELECT 
    t.id_transaccion + 10000 AS id_alerta,
    t.id_transaccion,
    CURRENT_TIMESTAMP,
    'ALTO'
FROM transaccion t
WHERE t.monto >= 500000.00
ON CONFLICT (id_alerta) DO UPDATE
SET fecha_alerta = EXCLUDED.fecha_alerta,
    nivel_riesgo = EXCLUDED.nivel_riesgo;
```

* **Explicación Técnica:**
  - El `SELECT` filtra operaciones de alto impacto que superan el umbral regulatorio.
  - La cláusula `ON CONFLICT (id_alerta)` captura la violación de clave primaria.
  - `DO UPDATE SET ... = EXCLUDED...` garantiza idempotencia: si la alerta ya existe, refresca los metadatos sin interrumpir el flujo del pipeline.

---

## 2. Sentencias UPDATE Avanzadas

### 2.1 UPDATE Dependiente de Otra Tabla (Vía Cláusula FROM / JOIN)
**Situación de Negocio:** Actualizar el saldo disponible de las cuentas bancarias de origen tras la ejecución de transferencias electrónicas registradas en el día.

```sql
UPDATE cuenta_bancaria c
SET saldo = c.saldo - deducciones.total_debitado
FROM (
    SELECT cuenta_origen, SUM(monto) AS total_debitado
    FROM transaccion
    WHERE fecha_hora >= CURRENT_DATE
    GROUP BY cuenta_origen
) deducciones
WHERE c.numero_cuenta = deducciones.cuenta_origen;
```

### 2.2 UPDATE con Clasificación Condicional (`CASE`)
**Situación de Negocio:** Homologar y reclasificar el nivel de riesgo de todas las alertas activas en función del monto financiero de la transacción asociada.

```sql
UPDATE alerta a
SET nivel_riesgo = CASE
    WHEN t.monto >= 1000000.00 THEN 'CRITICO'
    WHEN t.monto >= 500000.00  THEN 'ALTO'
    WHEN t.monto >= 200000.00  THEN 'MEDIO'
    ELSE 'BAJO'
END
FROM transaccion t
WHERE a.id_transaccion = t.id_transaccion;
```

---

## 3. DELETE con Subconsulta vs. Borrado Lógico

### 3.1 DELETE Físico con Subconsulta
**Situación de Negocio:** Purgar transacciones preliminares de prueba registradas antes del año 2020 que provengan de cuentas inactivas con saldo cero.

```sql
DELETE FROM transaccion
WHERE id_transaccion IN (
    SELECT t.id_transaccion
    FROM transaccion t
    JOIN cuenta_bancaria c ON t.cuenta_origen = c.numero_cuenta
    WHERE c.saldo = 0.00 AND t.fecha_hora < '2020-01-01 00:00:00'
);
```

### 3.2 Borrado Lógico (Soft Delete)
**Situación de Negocio:** En lugar de destruir el registro histórico de un contribuyente, se marca su estado registral y se fecha su baja administrativa.

```sql
-- Agregar columna de estado si no existe
ALTER TABLE contribuyente ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE;
ALTER TABLE contribuyente ADD COLUMN IF NOT EXISTS fecha_baja TIMESTAMP NULL;

-- Sentencia de borrado lógico
UPDATE contribuyente
SET activo = FALSE,
    fecha_baja = CURRENT_TIMESTAMP
WHERE rfc = 'XAXX010101000';
```

### 3.3 Comparativa Técnica y de Negocio:

| Aspecto | Borrado Físico (`DELETE`) | Borrado Lógico (`UPDATE activo = FALSE`) |
|---|---|---|
| **Efecto en la Base** | Destruye permanentemente las tuplas del disco. | Conserva el registro marcando un indicador booleano o fecha. |
| **Pista de Auditoría** | Se pierde por completo; los logs de transacciones quedan vacíos. | Totalmente auditable; preserva la evidencia forense histórica. |
| **Impacto en Acciones Referenciales** | Dispara `ON DELETE RESTRICT` (bloqueo) o `ON DELETE CASCADE` (destrucción masiva de hijos). | No activa eventos `ON DELETE`; las claves foráneas hacia transacciones o expedientes se preservan íntegras. |
| **Cuándo conviene** | Para tablas temporales, staging de ETL o datos sin valor legal. | **Imprescindible en sistemas financieros, fiscales y judiciales (UIF)**, donde la ley prohíbe eliminar antecedentes bancarios durante al menos 10 años. |

---

## 4. Transacción Multi-Tabla con SAVEPOINT y Reversión Parcial

### Escenario:
Un operador judicial de la UIF va a registrar una nueva alerta de lavado de dinero y abrir formalmente su carpeta de investigación penal en `expediente`. Si el registro del expediente tiene un error de captura en el identificador o fiscal asignado, se revierte solo el expediente sin perder la alerta generada.

```sql
BEGIN;

-- Paso 1: Generar una nueva alerta válida
INSERT INTO alerta (id_alerta, id_transaccion, fecha_alerta, nivel_riesgo)
VALUES (77777, 1, CURRENT_TIMESTAMP, 'CRITICO');

-- Establecer Punto de Recuperación
SAVEPOINT punto_alerta_creada;

-- Paso 2: Operación con error o tentativa errónea
INSERT INTO expediente (num_expediente, id_alerta, fecha_apertura, fiscal_asignado)
VALUES (99999, 77777, '2035-01-01', 'Fiscalía Especializada'); 
-- Supongamos que se decide descartar esta asignación por fecha inválida

-- Reversión Parcial hacia el SAVEPOINT
ROLLBACK TO SAVEPOINT punto_alerta_creada;

-- Paso 3: Operación de expediente con datos rectificados
INSERT INTO expediente (num_expediente, id_alerta, fecha_apertura, fiscal_asignado)
VALUES (88888, 77777, CURRENT_DATE, 'Lic. Juan Carlos Montero - Agente MPF');

-- Confirmación definitiva
COMMIT;
```

* **Resultado Verificado:**
  - La alerta `77777` fue persistida.
  - El expediente provisional `99999` fue revertido.
  - El expediente rectificado `88888` quedó confirmado en la base de datos.

---

## 5. Transacción que Falla por Restricción y Garantiza Atomicidad

### Escenario:
Transferencia de fondos entre dos cuentas bancarias: se debe debitar a la cuenta de origen, acreditar a la cuenta de destino y registrar la fila en `transaccion`. Durante la operación, el crédito intenta violar una restricción de clave foránea.

```sql
BEGIN;

-- 1. Débito a cuenta origen (Operación válida preliminar)
UPDATE cuenta_bancaria 
SET saldo = saldo - 100000.00 
WHERE numero_cuenta = '4152313188992211';

-- 2. Registro de transacción que VIOLA Clave Foránea (cuenta_destino inexistente)
INSERT INTO transaccion (id_transaccion, cuenta_origen, cuenta_destino, monto, fecha_hora)
VALUES (99998, '4152313188992211', 'CUENTA_FANTASMA_000', 100000.00, CURRENT_TIMESTAMP);
-- El gestor devuelve de inmediato:
-- ERROR: insert or update on table "transaccion" violates foreign key constraint "fk_transaccion_cuenta_destino"

-- 3. Ante el error, la transacción queda abortada por el motor
ROLLBACK;
```

* **Comprobación de Estado Inalterado (Atomicidad):**
  ```sql
  -- Consultamos el saldo de la cuenta de origen
  SELECT numero_cuenta, saldo 
  FROM cuenta_bancaria 
  WHERE numero_cuenta = '4152313188992211';
  ```
* **Resultado:** El saldo permanece en su valor original previo a la transacción. El débito del Paso 1 **no se aplicó** porque la atomicidad obligó a deshacer todos los cambios de la transacción fallida.
