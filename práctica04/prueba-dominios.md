

**Caso 1:** Restricción NOT NULL



\---> Operación intentada: Insertar un contribuyente enviando el valor NULL en el atributo calle.

\---> Resultado esperada: Rechazo de la inserción porque la dirección fiscal es obligatoria.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso1.png)



\---> Regla de dominio protegida: NOT NULL en el campo calle.



**Caso 2:** Restricción UNIQUE



\---> Operación intentada: Insertar un nuevo expediente utilizando un num\_expediente (15) que ya fue registrado previamente en la carga masiva.

\---> Resultado esperada: Rechazo por colisión de identificadores; no pueden existir dos expedientes con el mismo folio.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción UNIQUE](../evidencias/Caso2.png)



\---> Regla de dominio protegida: UNIQUE / PRIMARY KEY simple en num\_expediente.



**Caso 3:** Restricción UNIQUE



\---> Operación intentada: Insertar en la tabla telefono un número y RFC que ya existen juntos.

\---> Resultado esperada: Rechazo porque un mismo contribuyente no puede registrar dos veces exactamente la misma línea telefónica.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción UNIQUE](../evidencias/Caso3.png)



\---> Regla de dominio protegida: PRIMARY KEY (rfc, numero) (Llave primaria compuesta).



**Caso 4:** Restricción CHECK



\---> Operación intentada: Insertar un monto negativo asignándole un valor negativo (-10.00) a ingresos de persona\_fisica.

\---> Resultado esperada: Rechazo lógico; los valores de ingresos debido al dominio monto\_positivo deben ser estrictamente positivos.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción CHECK](../evidencias/Caso4.png)



\---> Regla de dominio protegida: CREATE DOMAIN monto\_positivo AS DECIMAL(20,2) CHECK (VALUE >= 0.00);



**Caso 5:** Restricción CHECK



\---> Operación intentada: Insertar un numero de cuenta que contiene letras en lugar de 16 números.

\---> Resultado esperada: Rechazo de tipo de dato; el formato no corresponde al estándar bancario nacional.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso5.png)



\---> Regla de dominio protegida: CREATE DOMAIN dominio\_numero\_cuenta (VALUE \~ '^\[0-9]{16}$').



**Caso 6:** Restricción CHECK



\---> Operación intentada: Insertar una transaccion financiera donde la cuenta\_origen y la cuenta\_destino son exactamente la misma.

\---> Resultado esperada: Rechazo de negocio; una transferencia requiere forzosamente dos cuentas distintas.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso1.png)



\---> Regla de dominio protegida: CHECK (cuenta\_origen <> cuenta\_destino)



**Caso 7:** Restricción CHECK



\---> Operación intentada: Insertar un tipo de bien inventado ('Servicio') en la tabla bien.

\---> Resultado esperada: Rechazo semántico; el valor debe pertenecer al catálogo cerrado de la UIF.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso7.png)



\---> Regla de dominio protegida: CHECK (tipo\_bien IN ('Inmueble', 'Vehículo', 'Aeronave', 'Embarcación', 'Joya o metal precioso', 'Obra de arte', 'Blindaje', 'Activo virtual')



**Caso 8:** Restricción DEFAULT



\---> Operación intentada: Insertar una transaccion forzando explícitamente el valor NULL en fecha\_hora, intentando evadir la generación automática de la marca de tiempo.

\---> Resultado esperada: Rechazo de la transacción; aunque tiene un valor DEFAULT, forzar un nulo viola la restricción estructural de la base.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso8.png)



\---> Regla de dominio protegida: Combinación de DEFAULT CURRENT\_TIMESTAMP con NOT NULL.



**Caso 9:** Restricción CHECK



\---> Operación intentada: Insertar una persona\_moral utilizando un RFC ficticio de 5 caracteres ('ABC12').

\---> Resultado esperada: Rechazo por longitud y formato incorrecto del identificador fiscal.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso9.png)



\---> Regla de dominio protegida: CREATE DOMAIN dominio\_rfc (Expresión regular de 12-13 caracteres).



**Caso 10:** Restricción CHECK



\---> Operación intentada: Insertar un reporte\_uif estableciendo como fecha\_recepcion el año 2099.

\---> Resultado esperada: Rechazo temporal; la base de datos no puede registrar recepciones en fechas que aún no han ocurrido en el sistema.

\---> Mensaje que devolvió el gestor:



!\[Caso de violación de restricción NOT NULL](../evidencias/Caso10.png)



\---> Regla de dominio protegida: CHECK (fecha\_recepcion <= CURRENT\_DATE)



