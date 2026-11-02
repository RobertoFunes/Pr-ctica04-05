**1. Creación de roles**



a) Consulta: Solo cuenta con permisos de lectura (SELECT) en el catálogo y tablas analíticas. Tiene restringido cualquier comando de escritura (INSERT, UPDATE, DELETE).

&#x09;



b) Aplicación: Dispone de permisos de lectura e inserción (SELECT, INSERT, UPDATE) en las tablas transaccionales y de catálogo, así como uso de tablas temporales (TEMPORARY), pero carece de permisos de destrucción de estructura (DROP, ALTER, TRUNCATE).



&#x09;

c) Administrador: Posee control DDL y DML sobre los objetos del esquema public, pudiendo modificar tablas, índices y secuencias, pero sin privilegios globales en el servidor.



**2. Asignación de permisos usando GRANT**



a) Permisos de consulta:

Se otorgaron los permisos usando el comando: GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol\_consulta;



b) Permisos de modificación:

Se otorgaron los permisos usando los comandos:

\---> GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO rol\_app;

\---> GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol\_app;



c) Permisos de administrador:

Los permisos de administrador se asignaron con los siguientes comandos:

\---> GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO rol\_admin;

\---> GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO rol\_admin;



**3. Proceso de conexión entre el script con el rol de la aplicación.**



Para conectar con la base de datos usando un usuario dado con valores externos definimos los valores de conexión del usuario de aplicación para poder realizar las pruebas DML:



set PGHOST=localhost

set PGPORT=5434

set PGDATABASE=UIF

set PGUSER=usr\_app

set PGPASSWORD=controlador



Después de haber ejecutado el código bd\_uif.py pasando los valores de las variables externas, se comprueba que la conexión fue exitosa, únicamente el motor de la base de datos detecta los datos corruptos insertados anteriormente a propósito para confirmar que la base de datos está protegida.



!\[Conexión de usuario de aplicación](../evidencias/conexión.png)



4\. Pruebas de funcionamiento de permisos para cada usuario



a) Administrador:

* Operación permitida: Vaciar con TRUNCATE una tabla.

!\[Operacion\_consulta](/evidencias/operacion\_permitida\_admin.png)



* Operación negada: Creación de una nueva base de datos sin privilegios de clúster

!\[Operacion\_consulta](/evidencias/operacion\_denegada\_admin.png)



b) Modificación:

* Operación permitida: Insertar valores para un teléfono

!\[Operacion\_consulta](/evidencias/operacion\_permitida\_telefono.png)



* Operación negada: Borrar la tabla de teléfono.

!\[Operacion\_consulta](/evidencias/operacion\_negada\_telefono.png)



c) Consulta:

* Operación permitida: Consultar el rfc, calle y actividad\_economica de un solo contribuyente.

!\[Operacion\_consulta](/evidencias/operacionpermitida\_consulta.png)



* Operación negada: La operación "DELETE" fue rechazada debido a los permisos otorgados.

!\[Operacion\_denegada](/evidencias/operacion\_negada\_consulta.png)



d) Retiro de privilegios



Como administrador se retiran los permisos de modificación del rol\_app con el comando:

RESET ROLE; REVOKE INSERT ON TABLE bien FROM rol\_app;

Después de retirar los permisos, intentamos insertar valores en la tabla de bien.

SET ROLE rol\_app;

INSERT INTO bien (id\_bien, tipo\_bien, valor\_comercial)

VALUES (9999, 'Inmueble', 1500000.00);

Regresa un error 'ERROR:  permission denied for table bien'



!\[Operacion\_denegada](/evidencias/permiso\_revocado.png)



5. Matriz de permisos



|Tabla|rol\_admin|rol\_app|rol\_consulta|
|-|-|-|-|
|contribuyente|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|persona\_fisica|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|persona\_moral|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|telefono|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|lista\_bloqueados|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|cuenta\_bancaria|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|bien|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|entidad\_reportante|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|operacion\_vulnerable|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|reporte\_uif|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|desglose|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|transaccion|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|alerta|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|
|expediente|ALL PRIVILEGES|SELECT, INSERT, UPDATE|SELECT|



