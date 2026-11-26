1. #### **Selección y proyección**



**I) Selección**



a) Pregunta del dominio: ¿Qué transacciones de la muestra superan un monto de 10,000?



b) Expresión en álgebra relacional: σ monto > 10000 (transaccion)



c) Captura de Relax:



!\[Selección RelaX](/evidencias/seleccion\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Selección RelaX](/evidencias/seleccion\_sql.png)



**II) Proyección**



a) Pregunta del dominio: ¿Cuáles son únicamente los números de cuenta y saldos registrados en las cuentas bancarias?



b) Expresión en álgebra relacional: π numero\_cuenta, saldo (cuenta\_bancaria)



c) Captura de Relax:



!\[Proyección RelaX](/evidencias/proyeccion\_RelaX.png)



d) Consulta SQL con verificación de resultados. Nota: Se observa que los datos están presentados en un orden distinto, pues la primer fila de la consulta en Relax corresponde a la fila 14 de la consulta hecha en pgAdmin.



!\[Proyección RelaX](/evidencias/proyeccion\_sql.png)



**III) Composición**



a) Pregunta del dominio: ¿Cuál es el RFC y nombre de las personas físicas con ingresos mayores a 30,000?



b) Expresión en álgebra relacional: PF\_Altas = σ ingresos > 30000 (persona\_fisica)

π rfc, nombre (PF\_Altas)



c) Captura de Relax:



!\[Composición de RelaX](/evidencias/composicion\_RelaX.png)



d) Consulta SQL con verificación de resultado: Se observa que de igual modo que en la consulta anterior, el orden es distinto, se comprueba en que el dato de la primer fila de la consulta en Relax corresponde a la fila 12 de la consulta hehca en pgAdmin.



!\[Composición de pgAdmin](/evidencias/composicion\_sql.png)



#### **2. Unión, diferencia e intersección**



**I) Unión**



a) Pregunta del dominio: ¿Qué RFCs y nombres/razones sociales conforman el padrón unificado de personas físicas y morales?



b) Expresión en álgebra relacional: Fisicas = π rfc, nombre->titular (persona\_fisica)

Morales = π rfc, razon\_social->titular (persona\_moral)

Fisicas ∪ Morales



c) Captura de Relax:



!\[union de RelaX](/evidencias/union\_RelaX.png)



d) Consulta SQL con verificación de resultado: Como Relax presenta los datos en orden alfabético el orden no es el mismo en el que lo presenta la consulta realizada en pgAdmin.



!\[Unión de sql](/evidencia/union\_sql.png)



**II) Diferencia**



a) Pregunta del dominio: ¿Qué notarios han enviado reportes UIF pero no registran operaciones vulnerables en la muestra?



b) Expresión en álgebra relacional:

Notarios\_Reportes = π id\_notario (reporte\_uif)

Notarios\_Ops = π id\_notario (operacion\_vulnerable)

Notarios\_Reportes - Notarios\_Ops



c) Captura de Relax:



!\[Diferencia en RelaX](/evidencias/diferencia\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Diferencia en sql](/evidencias/diferencia\_sql.png)



**III) Intersección**



a) Pregunta del dominio: ¿Qué entidades reportantes (id\_notario) coinciden tanto en el catálogo de entidades como en los reportes UIF emitidos?



b) Expresión en álgebra relacional:

Catalogo = π id\_notario (entidad\_reportante)

Con\_Reporte = π id\_notario (reporte\_uif)

Catalogo ∩ Con\_Reporte



!\[Intersección en RelaX](/evidencias/interseccion\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Intersección en sql](/evidencias/interseccion\_sql.png)



#### **3. Producto cartesiano**



a) Pregunta del dominio: ¿Cómo resultan todas las combinaciones posibles entre los expedientes y las alertas de la muestra sin ninguna condición de enlace?



b) Expresión en álgebra relacional:

expediente cross join alerta



c) Captura de Relax:



!\[Producto cartesiano de RelaX](/evidencias/cartesiano\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Producto cartesiano de sql](/evidencias/cartesiano\_sql.png)



¿Por qué casi nunca se usa solo?: la razón es que multiplica todas las filas de una tabla por todas las de la otra, emparejando cada expediente con alertas cuyo id\_alerta no coincide, lo que genera 132 combinaciones falsas y solo 12 válidas.



#### **4. Reunión natural, theta y externa**



**I) Reunión natural**



a) Pregunta del dominio: ¿Qué expedientes corresponden realmente a cada alerta y qué nivel de riesgo detonó su apertura?



b) Expresión en álgebra relacional:

Exp\_Alertas = expediente ⋈ alerta

π num\_expediente, fiscal\_asignado, id\_alerta, nivel\_riesgo (Exp\_Alertas)



c) Captura de Relax:



!\[Reunión natural RelaX](/evidencias/reunion\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Reunión natural sql](/evidencias/reunion\_sql.png)



* Filas conservadas/perdidas: conserva solo los 12 pares reales (eliminando las 132 combinaciones falsas del producto cartesiano), perdiendo cualquier alerta sin expediente asociado.



**II) Reunión theta**



a) Pregunta del dominio: ¿Qué transacciones salieron de cada cuenta bancaria de origen y cuál es el RFC y saldo de esa cuenta?



b) Expresión en álgebra relacional:

Tx\_Origen = transaccion ⋈ cuenta\_origen = numero\_cuenta cuenta\_bancaria

π id\_transaccion, cuenta\_origen, rfc, monto, saldo (Tx\_Origen)



c) Captura de Relax:



!\[Theta en RelaX](/evidencias/theta\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Theta en sql](/evidencias/theta\_sql.png)



* Filas conservadas/perdidas: conserva las transacciones ligadas a su cuenta de origen y pierde las cuentas bancarias que solo participaron como destinatarios.



**III) Reunión externa**



a) Pregunta del dominio: ¿Qué entidades reportantes existen y qué reportes UIF han enviado, conservando incluso a las entidades sin reportes UIF?



b) Expresión en álgebra relacional:

Ent\_Rep = entidad\_reportante ⟕ reporte\_uif

π id\_notario, nombre\_institucion, id\_reporte, monto\_total (Ent\_Rep)



c) Captura de Relax:



!\[Reunión externa en RelaX](/evidencias/externa\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Reunión externa en sql](/evidencias/externa\_sql.png)



* Filas conservadas/perdidas: conserva todas las filas de entidad\_reportante, las entidades que solo hicieron operaciones vulnerables y no tienen reporte UIF no se pierden, sino que aparecen con null en id\_reporte y monto\_total.



#### **5. Agregación y agrupación**



**I) Agregación**



a) Pregunta del dominio: ¿Cuántos renglones de desglose y qué monto acumulado tiene cada reporte UIF?



b) Expresión en álgebra relacional:

γ id\_reporte; count(numero\_renglon)->total\_renglones, sum(monto)->monto\_acumulado (desglose)



c) Captura de Relax:



!\[Agregación en RelaX](/evidencias/agregacion.png)



d) Consulta SQL con verificación de resultado:



!\[Agregación en sql](/evidencias/agregacion\_sql.png)



**II) Agrupación**



a) Pregunta del dominio: ¿Cuántos bienes y cuál es el valor comercial promedio por cada tipo de bien?



b) Expresión en álgebra relacional:

γ tipo\_bien; count(id\_bien)->cantidad\_bienes, avg(valor\_comercial)->valor\_promedio (bien)



c) Captura de Relax:



!\[Agrupación en RelaX](/evidencias/agrupacion\_RelaX.png)



d) Consulta SQL con verificación de resultado:



!\[Agrupación en sql](/evidencias/agrupacion\_sql.png)



#### **6. División**



a) Pregunta del dominio: ¿Qué reportes UIF contienen renglones de desglose en todas las divisas registradas en la muestra?



b) Expresión en álgebra relacional:

Reportes\_Divisas = π id\_reporte, divisa (desglose)

Todas\_Divisas = π divisa (desglose)

Reportes\_Divisas ÷ Todas\_Divisas



c) Captura de Relax:



!\[División en RelaX](/evidencias/division\_RelaX.png)



d) Consulta SQL con verificación de resultado: En este último punto comprobamos que la información es correcta, pues a pesar de que en ambas aparentemente no existe ningún dato compatible con la búsqueda, eso qsignifica que no existe ningún reporte en el que se incluyan todas las divisas a la vez



!\[División en sql](/evidencias/division\_sql.png)





#### **Álgebra del proyecto asignado (sismos)**



* Consulta 1: 



!\[Consulta1](evidencias/Consulta1.png)













