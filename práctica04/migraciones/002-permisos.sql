-- Creación de roles

DROP ROLE IF EXISTS usr_admin;
DROP ROLE IF EXISTS usr_app;
DROP ROLE IF EXISTS usr_consulta;

DROP ROLE IF EXISTS rol_admin;
DROP ROLE IF EXISTS rol_app;
DROP ROLE IF EXISTS rol_consulta;

CREATE ROLE rol_admin;
CREATE ROLE rol_app;
CREATE ROLE rol_consulta;

--Asignación de privilegios

-- Concesión de conexión y uso de esquema
GRANT CONNECT, TEMPORARY ON DATABASE "UIF" TO rol_admin, rol_app, rol_consulta;
GRANT USAGE, CREATE ON SCHEMA public TO rol_admin;
GRANT USAGE ON SCHEMA public TO rol_app, rol_consulta;

-- A) rol_consulta: Únicamente lectura
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_consulta;

-- B) rol_app: Lectura, inserción y actualización
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO rol_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_app;

-- C) rol_admin: Control total sobre objetos del esquema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rol_admin;

-- Privilegios por defecto para futuras tablas creadas por rol_admin
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO rol_consulta;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE ON TABLES TO rol_app;

-- Usuarios y su rol

CREATE USER usr_admin WITH PASSWORD 'administrador' IN ROLE rol_admin;
CREATE USER usr_app WITH PASSWORD 'controlador' IN ROLE rol_app;
CREATE USER usr_consulta WITH PASSWORD 'Auditoria' IN ROLE rol_consulta;