-- ============================================================================
-- MIGRACIÓN 003: INTEGRIDAD REFERENCIAL Y ACCIONES REFERENCIALES (PRACTICA 5)
-- Sistema: Unidad de Inteligencia Financiera (UIF)
-- Gestor: PostgreSQL 16
-- ============================================================================

-- 1. Especializaciones de Contribuyente (CASCADE / CASCADE)
ALTER TABLE persona_fisica
    DROP CONSTRAINT IF EXISTS llave_foranea_pf,
    ADD CONSTRAINT fk_persona_fisica_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE persona_moral
    DROP CONSTRAINT IF EXISTS llave_foranea_pm,
    ADD CONSTRAINT fk_persona_moral_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. Atributos Multivalorados y Listas de Control (CASCADE / CASCADE)
ALTER TABLE telefono
    DROP CONSTRAINT IF EXISTS foranea_contribuyente,
    ADD CONSTRAINT fk_telefono_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE lista_bloqueados
    DROP CONSTRAINT IF EXISTS fk_bloqueados_contribuyente,
    ADD CONSTRAINT fk_lista_bloqueados_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE CASCADE ON UPDATE CASCADE;

-- 3. Cuentas Bancarias del Contribuyente (CASCADE / CASCADE)
ALTER TABLE cuenta_bancaria
    DROP CONSTRAINT IF EXISTS llave_foranea_cuenta,
    ADD CONSTRAINT fk_cuenta_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE CASCADE ON UPDATE CASCADE;

-- 4. Operaciones Vulnerables (RESTRICT / CASCADE)
-- Blindaje contra borrado de historiales antilavado
ALTER TABLE operacion_vulnerable
    DROP CONSTRAINT IF EXISTS foranea_operacion,
    DROP CONSTRAINT IF EXISTS foranea_operacion_bien,
    DROP CONSTRAINT IF EXISTS foranea_operacion_entidad,
    ADD CONSTRAINT fk_operacion_contribuyente
        FOREIGN KEY (rfc) REFERENCES contribuyente(rfc)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_operacion_bien
        FOREIGN KEY (id_bien) REFERENCES bien(id_bien)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_operacion_entidad
        FOREIGN KEY (id_notario) REFERENCES entidad_reportante(id_notario)
        ON DELETE RESTRICT ON UPDATE CASCADE;

-- 5. Reportes Regulatorios UIF y Desglose
ALTER TABLE reporte_uif
    DROP CONSTRAINT IF EXISTS foranea_reporte,
    ADD CONSTRAINT fk_reporte_entidad
        FOREIGN KEY (id_notario) REFERENCES entidad_reportante(id_notario)
        ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE desglose
    DROP CONSTRAINT IF EXISTS foranea_desglose,
    ADD CONSTRAINT fk_desglose_reporte
        FOREIGN KEY (id_reporte) REFERENCES reporte_uif(id_reporte)
        ON DELETE CASCADE ON UPDATE CASCADE;

-- 6. Transacciones Bancarias (RESTRICT / CASCADE)
-- Las cuentas involucradas no pueden eliminarse si tienen registros de transferencias
ALTER TABLE transaccion
    DROP CONSTRAINT IF EXISTS foranea_origen,
    DROP CONSTRAINT IF EXISTS foranea_destino,
    ADD CONSTRAINT fk_transaccion_cuenta_origen
        FOREIGN KEY (cuenta_origen) REFERENCES cuenta_bancaria(numero_cuenta)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    ADD CONSTRAINT fk_transaccion_cuenta_destino
        FOREIGN KEY (cuenta_destino) REFERENCES cuenta_bancaria(numero_cuenta)
        ON DELETE RESTRICT ON UPDATE CASCADE;

-- 7. Alertas de Inteligencia y Carpetas de Expediente
ALTER TABLE alerta
    DROP CONSTRAINT IF EXISTS foranea_transaccion,
    ADD CONSTRAINT fk_alerta_transaccion
        FOREIGN KEY (id_transaccion) REFERENCES transaccion(id_transaccion)
        ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE expediente
    DROP CONSTRAINT IF EXISTS foranea_expediente,
    ADD CONSTRAINT fk_expediente_alerta
        FOREIGN KEY (id_alerta) REFERENCES alerta(id_alerta)
        ON DELETE RESTRICT ON UPDATE CASCADE;
