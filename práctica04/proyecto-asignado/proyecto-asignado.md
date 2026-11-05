* Comparación de lo obtenido y lo declarado en el artículo



En la descarga del archivo csv disponible desde la página del SSN, se realizó una búsqueda que abarca los sismos ocurridos en el periodo de 1-12-1900 a la fecha actual 4-11-2026, en esta búsqueda se obtuvo un archivo.csv que contiene 401865 filas de datos, a diferencia de las aproximadamente 300,000 contenidas en la base de datos del repositorio creado por el profesor.



Esta diferencia se debe al periodo analizado por el profesor, que abarcan todos los sismos hasta el año 2020, fecha de la cual ya han transcurrido seis años.



* Cambios de restricciones propuestos



Se crearon copias de dim\_sismos y dim\_tiempo para poder probar tres restricciones propuestas implementadas en el siguiente código:



!\[Código de restricciones](/evidencias/propuestas\_restricciones.png)



A continuación se registró que las restricciones añadidas funcionaran correctamente.



a) Clasificación de sismos según su intensidad



!\[Clasificación según la intensidad](/evidencias/clasificacion\_sismos.png)



b) Restricción de validación de fecha de registro de sismos (1900-fecha actual)



!\[Restricción de validación de fechas](/evidencias/validacion\_tiempo\_sismos.png)



c) Validación de epicentros físicamente posibles de un sismo



!\[Validación de epicentros](/evidencias/validacion\_epicentro.png)

