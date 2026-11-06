-- ============================================================================
-- SCRIPT DE SENTENCIAS DML Y CONTROL TRANSACCIONAL (PRACTICA 5 - EJERCICIO 2.4)
-- Sistema: Unidad de Inteligencia Financiera (UIF)
-- ============================================================================

\echo '----------------------------------------------------------------------'
\echo '1. INSERT CON SELECT Y ON CONFLICT (UPSERT / IDEMPOTENCIA)'
\echo '----------------------------------------------------------------------'
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

\echo '----------------------------------------------------------------------'
\echo '2. UPDATES AVANZADOS (CON FROM Y CON CASE)'
\echo '----------------------------------------------------------------------'
-- 2.1 Reclasificación con CASE
UPDATE alerta a
SET nivel_riesgo = CASE
    WHEN t.monto >= 1000000.00 THEN 'CRITICO'
    WHEN t.monto >= 500000.00  THEN 'ALTO'
    WHEN t.monto >= 200000.00  THEN 'MEDIO'
    ELSE 'BAJO'
END
FROM transaccion t
WHERE a.id_transaccion = t.id_transaccion;

\echo '----------------------------------------------------------------------'
\echo '3. BORRADO LOGICO'
\echo '----------------------------------------------------------------------'
ALTER TABLE contribuyente ADD COLUMN IF NOT EXISTS activo BOOLEAN DEFAULT TRUE;
ALTER TABLE contribuyente ADD COLUMN IF NOT EXISTS fecha_baja TIMESTAMP NULL;

UPDATE contribuyente
SET activo = FALSE,
    fecha_baja = CURRENT_TIMESTAMP
WHERE rfc IN (SELECT rfc FROM contribuyente LIMIT 1);

\echo '----------------------------------------------------------------------'
\echo '4. TRANSACCION MULTI-TABLA CON SAVEPOINT Y REVERSION PARCIAL'
\echo '----------------------------------------------------------------------'
BEGIN;

-- Insertar alerta preliminar usando una transacción existente
INSERT INTO alerta (id_alerta, id_transaccion, fecha_alerta, nivel_riesgo)
SELECT 77777, MIN(id_transaccion), CURRENT_TIMESTAMP, 'CRITICO'
FROM transaccion
ON CONFLICT (id_alerta) DO NOTHING;

SAVEPOINT punto_alerta_creada;

-- Registro temporal que se cancela
INSERT INTO expediente (num_expediente, id_alerta, fecha_apertura, fiscal_asignado)
VALUES (99999, 77777, '2099-01-01', 'Fiscalia Temporal Cancelada')
ON CONFLICT (num_expediente) DO NOTHING;

-- Revertir el expediente provisional
ROLLBACK TO SAVEPOINT punto_alerta_creada;

-- Asignación definitiva
INSERT INTO expediente (num_expediente, id_alerta, fecha_apertura, fiscal_asignado)
VALUES (88888, 77777, CURRENT_DATE, 'Lic. Juan Carlos Montero - Agente MPF')
ON CONFLICT (num_expediente) DO UPDATE
SET fiscal_asignado = EXCLUDED.fiscal_asignado;

COMMIT;

\echo '----------------------------------------------------------------------'
\echo '5. TRANSACCION QUE FALLA POR RESTRICCION Y PRUEBA DE ATOMICIDAD'
\echo '----------------------------------------------------------------------'
DO $$
DECLARE
    v_saldo_inicial NUMERIC;
    v_cuenta_test VARCHAR(16);
BEGIN
    SELECT numero_cuenta, saldo INTO v_cuenta_test, v_saldo_inicial 
    FROM cuenta_bancaria LIMIT 1;

    RAISE NOTICE 'Saldo inicial de la cuenta %: %', v_cuenta_test, v_saldo_inicial;

    BEGIN
        -- Intentamos actualizar saldo
        UPDATE cuenta_bancaria SET saldo = saldo - 50000 WHERE numero_cuenta = v_cuenta_test;

        -- Forzamos violación de FK
        INSERT INTO transaccion (id_transaccion, cuenta_origen, cuenta_destino, monto, fecha_hora)
        VALUES (99998, v_cuenta_test, 'INEXISTENTE_000', 50000, CURRENT_TIMESTAMP);
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Excepcion capturada exitosamente: foreign_key_violation.';
        RAISE NOTICE 'Verificando que la transaccion se revierte automaticamente por el bloque...';
    END;

    -- Comprobamos que el saldo no cambió tras el rollback del sub-bloque
    SELECT saldo INTO v_saldo_inicial FROM cuenta_bancaria WHERE numero_cuenta = v_cuenta_test;
    RAISE NOTICE 'Saldo verificado posterior (intacto): %', v_saldo_inicial;
END $$;
