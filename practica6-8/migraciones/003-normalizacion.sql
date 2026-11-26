-- Tabla desnormalizada
CREATE TABLE reporte_desnormalizado (
    id_reporte         INT NOT NULL,
    renglon            INT NOT NULL,
    descripcion        VARCHAR(200) NOT NULL,
    monto              DECIMAL(20, 2) NOT NULL,
    fecha_reporte      TIMESTAMP NOT NULL,
    id_notario         INT NOT NULL,
    nombre_institucion VARCHAR(50) NOT NULL,
    sector_economico   VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_reporte, renglon)
);

INSERT INTO reporte_desnormalizado VALUES
(1001, 1, 'Compra de inmueble en efectivo',   1850000.00, '2026-10-05 10:30:00', 54, 'Notaria Publica No. 182', 'Servicios (Sector 54)'),
(1001, 2, 'Adquisicion de vehiculo blindado',  950000.00, '2026-10-05 10:30:00', 54, 'Notaria Publica No. 182', 'Servicios (Sector 54)'),
(1002, 1, 'Transferencia internacional',      2400000.00, '2026-10-12 14:15:00', 54, 'Notaria Publica No. 182', 'Servicios (Sector 54)'),
(1003, 1, 'Compra de joyeria de alto valor',   620000.00, '2026-10-18 09:00:00', 71, 'Notaria Publica No. 45',  'Servicios (Sector 54)');

-- Transformación a 3FN
BEGIN;

-- Creación de tablas normalizadas
CREATE TABLE entidad_norm (
    id_notario         INT PRIMARY KEY,
    nombre_institucion VARCHAR(50) NOT NULL,
    sector_economico   VARCHAR(50) NOT NULL
);

CREATE TABLE reporte_norm (
    id_reporte    INT PRIMARY KEY,
    fecha_reporte TIMESTAMP NOT NULL,
    id_notario    INT NOT NULL REFERENCES entidad_norm(id_notario) ON DELETE RESTRICT
);

CREATE TABLE desglose_norm (
    id_reporte  INT NOT NULL REFERENCES reporte_norm(id_reporte) ON DELETE RESTRICT,
    renglon     INT NOT NULL,
    descripcion VARCHAR(200) NOT NULL,
    monto       DECIMAL(20, 2) NOT NULL,
    PRIMARY KEY (id_reporte, renglon)
);

-- Inserción de datos automáticamente, es decir, sin hacerlo a mano
INSERT INTO entidad_norm (id_notario, nombre_institucion, sector_economico)
SELECT DISTINCT id_notario, nombre_institucion, sector_economico
FROM reporte_desnormalizado;

INSERT INTO reporte_norm (id_reporte, fecha_reporte, id_notario)
SELECT DISTINCT id_reporte, fecha_reporte, id_notario
FROM reporte_desnormalizado;

INSERT INTO desglose_norm (id_reporte, renglon, descripcion, monto)
SELECT id_reporte, renglon, descripcion, monto
FROM reporte_desnormalizado;

-- Eliminar la tabla desnormalizada al migrar los datos
DROP TABLE reporte_desnormalizado;

COMMIT;

-- Reunión sin pérdida
SELECT d.id_reporte, d.renglon, d.descripcion, d.monto,
       r.fecha_reporte, e.id_notario, e.nombre_institucion, e.sector_economico
FROM desglose_norm d
JOIN reporte_norm r ON d.id_reporte = r.id_reporte
JOIN entidad_norm e ON r.id_notario = e.id_notario
ORDER BY d.id_reporte, d.renglon;