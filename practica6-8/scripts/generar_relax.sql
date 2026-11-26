\set QUIET on
\pset tuples_only on
\pset format unaligned
\pset footer off

-- Función temporal auxiliar para formatear textos en sintaxis RelaX
-- (agrega comillas simples, limpia saltos de línea y maneja valores NULL)
CREATE FUNCTION pg_temp.rx_str(val text) RETURNS text LANGUAGE sql IMMUTABLE AS $$
    SELECT CASE
        WHEN val IS NULL THEN 'null'
        ELSE '''' || regexp_replace(REPLACE(TRIM(val), '''', ''), E'[\r\n]+', ' ', 'g') || ''''
    END;
$$;

-- Rama 1: expediente -> alerta -> transaccion -> cuenta_bancaria
CREATE TEMP TABLE m_expediente AS
SELECT DISTINCT ON (id_alerta) *
FROM expediente
ORDER BY id_alerta, num_expediente
LIMIT 12;

CREATE TEMP TABLE m_alerta AS
SELECT * FROM alerta
WHERE id_alerta IN (SELECT id_alerta FROM m_expediente)
ORDER BY id_alerta;

CREATE TEMP TABLE m_transaccion AS
SELECT * FROM transaccion
WHERE id_transaccion IN (SELECT id_transaccion FROM m_alerta)
ORDER BY id_transaccion;

CREATE TEMP TABLE m_cuenta_bancaria AS
SELECT * FROM cuenta_bancaria
WHERE numero_cuenta IN (
    SELECT cuenta_origen FROM m_transaccion
    UNION
    SELECT cuenta_destino FROM m_transaccion
)
ORDER BY numero_cuenta;

-- Rama 2: operacion_vulnerable -> bien / entidad_reportante
--         desglose -> reporte_uif -> entidad_reportante
CREATE TEMP TABLE m_operacion_vulnerable AS
SELECT DISTINCT ON (id_bien) *
FROM operacion_vulnerable
ORDER BY id_bien, id_operacion
LIMIT 12;

CREATE TEMP TABLE m_bien AS
SELECT * FROM bien
WHERE id_bien IN (SELECT id_bien FROM m_operacion_vulnerable)
ORDER BY id_bien;

CREATE TEMP TABLE m_reporte_uif AS
SELECT * FROM reporte_uif
ORDER BY id_reporte
LIMIT 12;

CREATE TEMP TABLE m_desglose AS
SELECT * FROM desglose
WHERE id_reporte IN (SELECT id_reporte FROM m_reporte_uif)
ORDER BY id_reporte, numero_renglon
LIMIT 25;

CREATE TEMP TABLE m_entidad_reportante AS
SELECT * FROM entidad_reportante
WHERE id_notario IN (
    SELECT id_notario FROM m_operacion_vulnerable
    UNION
    SELECT id_notario FROM m_reporte_uif
)
ORDER BY id_notario;

-- Tablas relacionadas por RFC (priorizamos RFCs que aparezcan en cuentas u operaciones
-- para que los JOIN por RFC en RelaX sí devuelvan coincidencias)
CREATE TEMP TABLE m_rfcs_usados AS
SELECT rfc FROM m_cuenta_bancaria WHERE rfc IS NOT NULL
UNION
SELECT rfc FROM m_operacion_vulnerable WHERE rfc IS NOT NULL;

CREATE TEMP TABLE m_persona_fisica AS
SELECT * FROM persona_fisica
ORDER BY (CASE WHEN rfc IN (SELECT rfc FROM m_rfcs_usados) THEN 0 ELSE 1 END), rfc
LIMIT 20;

CREATE TEMP TABLE m_persona_moral AS
SELECT * FROM persona_moral
ORDER BY (CASE WHEN rfc IN (SELECT rfc FROM m_rfcs_usados) THEN 0 ELSE 1 END), rfc
LIMIT 20;

CREATE TEMP TABLE m_lista_bloqueados AS
SELECT * FROM lista_bloqueados
ORDER BY (CASE WHEN rfc IN (
    SELECT rfc FROM m_rfcs_usados
    UNION SELECT rfc FROM m_persona_fisica
    UNION SELECT rfc FROM m_persona_moral
) THEN 0 ELSE 1 END), id_bloqueo
LIMIT 15;

CREATE TEMP TABLE m_contribuyente AS
SELECT * FROM contribuyente
ORDER BY (CASE WHEN rfc IN (
    SELECT rfc FROM m_rfcs_usados
    UNION SELECT rfc FROM m_persona_fisica
    UNION SELECT rfc FROM m_persona_moral
) THEN 0 ELSE 1 END), rfc
LIMIT 20;


-- FASE 2: EXPORTACIÓN AL FORMATO DE GRUPO DE RELAX

SELECT 'group: UIF_Normalizada';
SELECT 'description: Muestra normalizada de la base UIF conservando integridad referencial';
SELECT '';

-- 1. entidad_reportante
SELECT 'entidad_reportante = {';
SELECT '  id_notario:number, nombre_institucion:string, sector_economico:string';
SELECT '  ' ||
    COALESCE(id_notario::text, 'null') || ', ' ||
    pg_temp.rx_str(nombre_institucion) || ', ' ||
    pg_temp.rx_str(sector_economico)
FROM m_entidad_reportante
ORDER BY id_notario;
SELECT '}';
SELECT '';

-- 2. bien
SELECT 'bien = {';
SELECT '  id_bien:number, tipo_bien:string, valor_comercial:number';
SELECT '  ' ||
    COALESCE(id_bien::text, 'null') || ', ' ||
    pg_temp.rx_str(tipo_bien) || ', ' ||
    COALESCE(valor_comercial::text, 'null')
FROM m_bien
ORDER BY id_bien;
SELECT '}';
SELECT '';

-- 3. operacion_vulnerable
SELECT 'operacion_vulnerable = {';
SELECT '  id_operacion:number, rfc:string, id_bien:number, id_notario:number, valor_pactado:number, fecha_operacion:date';
SELECT '  ' ||
    COALESCE(id_operacion::text, 'null') || ', ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    COALESCE(id_bien::text, 'null') || ', ' ||
    COALESCE(id_notario::text, 'null') || ', ' ||
    COALESCE(valor_pactado::text, 'null') || ', ' ||
    COALESCE(to_char(fecha_operacion, 'YYYY-MM-DD'), 'null')
FROM m_operacion_vulnerable
ORDER BY id_operacion;
SELECT '}';
SELECT '';

-- 4. reporte_uif
SELECT 'reporte_uif = {';
SELECT '  id_reporte:number, id_notario:number, tipo_reporte:string, fecha_recepcion:date, monto_total:number';
SELECT '  ' ||
    COALESCE(id_reporte::text, 'null') || ', ' ||
    COALESCE(id_notario::text, 'null') || ', ' ||
    pg_temp.rx_str(tipo_reporte) || ', ' ||
    COALESCE(to_char(fecha_recepcion, 'YYYY-MM-DD'), 'null') || ', ' ||
    COALESCE(monto_total::text, 'null')
FROM m_reporte_uif
ORDER BY id_reporte;
SELECT '}';
SELECT '';

-- 5. desglose
SELECT 'desglose = {';
SELECT '  id_reporte:number, numero_renglon:number, descripcion:string, monto:number, divisa:string';
SELECT '  ' ||
    COALESCE(id_reporte::text, 'null') || ', ' ||
    COALESCE(numero_renglon::text, 'null') || ', ' ||
    pg_temp.rx_str(descripcion) || ', ' ||
    COALESCE(monto::text, 'null') || ', ' ||
    pg_temp.rx_str(divisa)
FROM m_desglose
ORDER BY id_reporte, numero_renglon;
SELECT '}';
SELECT '';

-- 6. cuenta_bancaria
SELECT 'cuenta_bancaria = {';
SELECT '  numero_cuenta:string, rfc:string, fecha_apertura:date, saldo:number';
SELECT '  ' ||
    pg_temp.rx_str(numero_cuenta) || ', ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    COALESCE(to_char(fecha_apertura, 'YYYY-MM-DD'), 'null') || ', ' ||
    COALESCE(saldo::text, 'null')
FROM m_cuenta_bancaria
ORDER BY numero_cuenta;
SELECT '}';
SELECT '';

-- 7. transaccion
SELECT 'transaccion = {';
SELECT '  id_transaccion:number, cuenta_origen:string, cuenta_destino:string, monto:number, fecha_hora:date';
SELECT '  ' ||
    COALESCE(id_transaccion::text, 'null') || ', ' ||
    pg_temp.rx_str(cuenta_origen) || ', ' ||
    pg_temp.rx_str(cuenta_destino) || ', ' ||
    COALESCE(monto::text, 'null') || ', ' ||
    COALESCE(to_char(fecha_hora, 'YYYY-MM-DD'), 'null')
FROM m_transaccion
ORDER BY id_transaccion;
SELECT '}';
SELECT '';

-- 8. alerta
SELECT 'alerta = {';
SELECT '  id_alerta:number, id_transaccion:number, fecha_alerta:date, nivel_riesgo:string';
SELECT '  ' ||
    COALESCE(id_alerta::text, 'null') || ', ' ||
    COALESCE(id_transaccion::text, 'null') || ', ' ||
    COALESCE(to_char(fecha_alerta, 'YYYY-MM-DD'), 'null') || ', ' ||
    pg_temp.rx_str(nivel_riesgo)
FROM m_alerta
ORDER BY id_alerta;
SELECT '}';
SELECT '';

-- 9. expediente
SELECT 'expediente = {';
SELECT '  num_expediente:number, id_alerta:number, fecha_apertura:date, fiscal_asignado:string';
SELECT '  ' ||
    COALESCE(num_expediente::text, 'null') || ', ' ||
    COALESCE(id_alerta::text, 'null') || ', ' ||
    COALESCE(to_char(fecha_apertura, 'YYYY-MM-DD'), 'null') || ', ' ||
    pg_temp.rx_str(fiscal_asignado)
FROM m_expediente
ORDER BY num_expediente;
SELECT '}';
SELECT '';

-- 10. persona_fisica
SELECT 'persona_fisica = {';
SELECT '  rfc:string, curp:string, nombre:string, ingresos:number';
SELECT '  ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    pg_temp.rx_str(curp) || ', ' ||
    pg_temp.rx_str(nombre) || ', ' ||
    COALESCE(ingresos::text, 'null')
FROM m_persona_fisica
ORDER BY rfc;
SELECT '}';
SELECT '';

-- 11. persona_moral
SELECT 'persona_moral = {';
SELECT '  rfc:string, representante_legal:string, razon_social:string, fecha_constitucion:date';
SELECT '  ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    pg_temp.rx_str(representante_legal) || ', ' ||
    pg_temp.rx_str(razon_social) || ', ' ||
    COALESCE(to_char(fecha_constitucion, 'YYYY-MM-DD'), 'null')
FROM m_persona_moral
ORDER BY rfc;
SELECT '}';
SELECT '';

-- 12. lista_bloqueados
SELECT 'lista_bloqueados = {';
SELECT '  id_bloqueo:number, rfc:string, fecha_bloqueo:date, motivo:string';
SELECT '  ' ||
    COALESCE(id_bloqueo::text, 'null') || ', ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    COALESCE(to_char(fecha_bloqueo, 'YYYY-MM-DD'), 'null') || ', ' ||
    pg_temp.rx_str(motivo)
FROM m_lista_bloqueados
ORDER BY id_bloqueo;
SELECT '}';
SELECT '';

-- 13. contribuyente
SELECT 'contribuyente = {';
SELECT '  rfc:string, calle:string, actividad_economica:string, e_firma:string, codigo_postal:string';
SELECT '  ' ||
    pg_temp.rx_str(rfc) || ', ' ||
    pg_temp.rx_str(calle) || ', ' ||
    pg_temp.rx_str(actividad_economica) || ', ' ||
    pg_temp.rx_str(e_firma) || ', ' ||
    pg_temp.rx_str(codigo_postal)
FROM m_contribuyente
ORDER BY rfc;
SELECT '}';
SELECT '';