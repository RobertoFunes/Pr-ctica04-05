-- Dominio para el Código Postal
CREATE DOMAIN dominio_codigo_postal AS CHAR(5)
    CHECK (VALUE ~ '^[0-9]{5}$');

-- Dominio para el RFC
CREATE DOMAIN dominio_rfc AS VARCHAR(13)
    CHECK (VALUE ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-Z0-9]{3}$');

-- Aplicación a la tabla de CONTRIBUYENTE:
ALTER TABLE contribuyente 
    ALTER COLUMN codigo_postal TYPE dominio_codigo_postal;

ALTER TABLE contribuyente 
    ALTER COLUMN rfc TYPE dominio_rfc;
	
-- Regla de dominio: El CURP debe cumplir con la estructura alfanumérica
CREATE DOMAIN dominio_curp AS VARCHAR(18)
    CHECK (VALUE ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z][0-9]$');

-- Regla de dominio: Los ingresos declarados deben ser valores positivos
CREATE DOMAIN monto_positivo AS DECIMAL(20,2)
    CHECK (VALUE >= 0.00);

-- Aplicación de los dominios a la tabla persona_fisica:
ALTER TABLE persona_fisica 
    ALTER COLUMN curp TYPE dominio_curp;

ALTER TABLE persona_fisica 
    ALTER COLUMN ingresos TYPE monto_positivo;

ALTER TABLE persona_fisica 
    ALTER COLUMN rfc TYPE dominio_rfc;

ALTER TABLE persona_moral 
    ALTER COLUMN rfc TYPE dominio_rfc;

-- La fecha de constitución no puede ser posterior a la fecha actual del sistema.
ALTER TABLE persona_moral 
    ADD CONSTRAINT Fecha_constitucion 
    CHECK (fecha_constitucion <= CURRENT_DATE);

-- Regla de dominio: El número debe componerse exactamente de 10 numéros
CREATE DOMAIN dominio_telefono AS VARCHAR(10)
    CHECK (VALUE ~ '^[0-9]{10}$');

-- Aplicación del dominio de RFC ya existente
ALTER TABLE telefono 
    ALTER COLUMN rfc TYPE dominio_rfc;

-- Aplicación del nuevo dominio telefónico
ALTER TABLE telefono 
    ALTER COLUMN numero TYPE dominio_telefono;

--Restricciones de la lista de bloqueados
ALTER TABLE lista_bloqueados 
    ALTER COLUMN rfc TYPE dominio_rfc;

ALTER TABLE lista_bloqueados 
    ADD CONSTRAINT id_positivo 
    CHECK (id_bloqueo > 0);

-- La fecha del acuerdo de bloqueo no puede ser posterior a la fecha actual.
ALTER TABLE lista_bloqueados 
    ADD CONSTRAINT fecha_valida 
    CHECK (fecha_bloqueo <= CURRENT_DATE);

-- Todo bloqueo ordenado por la UIF debe registrar obligatoriamente una causa o fundamento legal.
ALTER TABLE lista_bloqueados 
    ALTER COLUMN motivo SET NOT NULL;

--Restricciones de la tabla CUENTA BANCARIA

-- Dominio para número de cuenta (16 dígitos)
CREATE DOMAIN numero_cuenta AS VARCHAR(16)
    CHECK (VALUE ~ '^[0-9]{16}$');

-- Aplicación del dominio de número de cuenta
ALTER TABLE cuenta_bancaria 
    ALTER COLUMN numero_cuenta TYPE dominio_numero_cuenta;

-- Aplicación del dominio de RFC
ALTER TABLE cuenta_bancaria 
    ALTER COLUMN rfc TYPE dominio_rfc;

-- 5. Regla de dominio: La fecha de apertura de la cuenta no puede ser futura
ALTER TABLE cuenta_bancaria 
    ADD CONSTRAINT fecha_apertura_cuenta 
    CHECK (fecha_apertura <= CURRENT_DATE);


-- DOMINIOS Y RESTRICCIONES: TABLA BIEN
-- Regla de dominio: El tipo de bien debe coincidir con los activos supervisados por la LFPIORPI.
ALTER TABLE bien 
    ADD CONSTRAINT clasificacion 
    CHECK (tipo_bien IN (
        'Inmueble', 
        'Vehículo', 
        'Aeronave', 
        'Embarcación', 
        'Joya o metal precioso', 
        'Obra de arte', 
        'Blindaje', 
        'Activo virtual'
    ));

-- Verifica que el bien tenga un valor positivo
ALTER TABLE bien 
    ALTER COLUMN valor_comercial TYPE monto_positivo;

--Restricciones para ENTIDAD REPORTANTE

-- Regla de dominio: El sector económico debe corresponder a un sector regulado por la ley antilavado.
ALTER TABLE entidad_reportante 
    ADD CONSTRAINT sector 
    CHECK (sector_economico IN (
        'Bancario y Financiero',
        'Notarial y Fe Pública',
        'Inmobiliario y Construcción',
        'Metales Preciosos y Joyería',
        'Juegos con Apuesta y Sorteos',
        'Vehículos y Blindaje',
        'Activos Virtuales y Fintech'
    ));

--Operaciones vulnerables

-- Dominios de RFC y Montos
ALTER TABLE operacion_vulnerable 
    ALTER COLUMN rfc TYPE dominio_rfc;

ALTER TABLE operacion_vulnerable 
    ALTER COLUMN valor_pactado TYPE dominio_monto_positivo;

-- Regla de dominio: El valor pactado en la transacción debe ser estrictamente mayor a cero.
ALTER TABLE operacion_vulnerable 
    ADD CONSTRAINT operacion_valor_positivo 
    CHECK (valor_pactado > 0.00);

-- Regla de dominio: La fecha de celebración de la operación no puede ser posterior a la fecha actual.
ALTER TABLE operacion_vulnerable 
    ADD CONSTRAINT operacion_fecha 
    CHECK (fecha_operacion <= CURRENT_DATE);

-- Tabla de Reporte UIF

-- Regla de dominio: El tipo de reporte debe limitarse a las categorías oficiales antilavado.
ALTER TABLE reporte_uif 
    ADD CONSTRAINT reporte_tipo 
    CHECK (tipo_reporte IN (
        'Operación Relevante',
        'Operación Inusual',
        'Operación Preocupante',
        'Aviso de Actividad Vulnerable'
    ));

-- Regla de dominio: La fecha de recepción no puede ser futura.
ALTER TABLE reporte_uif 
    ADD CONSTRAINT reporte_fecha_valida 
    CHECK (fecha_recepcion <= CURRENT_DATE);

-- Regla de dominio: El monto acumulado reportado debe ser mayor a cero.
ALTER TABLE reporte_uif 
    ADD CONSTRAINT chk_reporte_monto_positivo 
    CHECK (monto_total > 0.00);

--Tabla de desglose

ALTER TABLE desglose 
    ADD CONSTRAINT chk_desglose_divisa 
    CHECK (divisa IN ('MXN', 'USD', 'EUR', 'CAD', 'GBP', 'CHF'));
ALTER TABLE desglose 
    ALTER COLUMN monto TYPE monto_positivo;
ALTER TABLE desglose 
    ADD CONSTRAINT desglose_positivo 
    CHECK (monto > 0.00);

--Tabla de transacción

-- Homologación de dominios de Cuentas Bancarias y Montos
ALTER TABLE transaccion 
    ALTER COLUMN cuenta_origen TYPE numero_cuenta;

ALTER TABLE transaccion 
    ALTER COLUMN cuenta_destino TYPE numero_cuenta;

ALTER TABLE transaccion 
    ALTER COLUMN monto TYPE monto_positivo;

-- Regla de dominio: El monto de la transferencia debe ser estrictamente mayor a cero.
ALTER TABLE transaccion 
    ADD CONSTRAINT transaccion_monto_positivo 
    CHECK (monto > 0.00);

-- Regla de negocio: Una transferencia requiere cuentas distintas en origen y destino.
ALTER TABLE transaccion 
    ADD CONSTRAINT cuentas_distintas 
    CHECK (cuenta_origen <> cuenta_destino);

-- Regla de dominio: La fecha y hora de la transacción no puede ser futura respecto al sistema.
ALTER TABLE transaccion 
    ADD CONSTRAINT fecha_valida 
    CHECK (fecha_hora <= CURRENT_TIMESTAMP);

--Tabla de alerta

ALTER TABLE alerta 
    ADD CONSTRAINT fecha_valida 
    CHECK (fecha_alerta <= CURRENT_TIMESTAMP);

-- Regla de dominio: El nivel de riesgo debe ajustarse a la escala oficial de supervisión antilavado.

ALTER TABLE alerta 
    ADD CONSTRAINT nivel_riesgo 
    CHECK (nivel_riesgo IN ('Bajo', 'Medio', 'Alto', 'Crítico'));

--Tabla de expediente

ALTER TABLE expediente 
    ADD CONSTRAINT fecha_valida 
    CHECK (fecha_apertura <= CURRENT_DATE);

-- Regla de dominio: El fiscal asignado no puede consistir en una cadena en blanco.
ALTER TABLE expediente 
    ADD CONSTRAINT fiscal 
    CHECK (trim(fiscal_asignado) <> '');