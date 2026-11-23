#### ***Formas normales***

* ***Contribuyente:***

&#x09;*-1FN: Cada atributo contenido en la tabla corresponde a un solo dato indivisible, por esa razón se separó el atributo "Domicilio fiscal" en C.P. y Calle, por lo tanto cumple con la 1FN.*

&#x09;*-2FN: Al poseer únicamente un atributo como llave primaria, no es posible que existan dependencias parciales, por lo tanto cumple con 2FN.*

&#x09;*-3FN: No existen atributos que determinen a otros con excepción de la llave primaria, es decir, no hay dependencias transitivas, por lo que cumple 3FN.*

&#x09;*-BCNF: El cierre de la llave primaria abarca toda la tabla siendo también una llave candidata, por lo tanto también cumple BCNF.*



* ***Persona física:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con un RFC como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Persona moral:***

&#x09;*-1FN: Ningún atributo es divisible, por lo tanto cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con un atributo (RFC) como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Teléfono:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, por lo que cumple con 1FN.*

&#x09;*-2FN: Como ambos atributos componen la llave primaria y no existen atributos fuera de esta, no existen dependencias parciales, por lo que cumple con 2FN.*

&#x09;*-3FN: Por la razón mencionada en el punto anterior tampoco existen dependencias transitivas, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es también la única llave candidata y describe la totalidad de atributos de la tabla, siendo su único determinante, por lo tanto cumple con BCNF.*



* ***Lista de bloqueados:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_bloqueo como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Cuenta bancaria***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con 'Número de cuenta' como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Bien***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_bien como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Entidad reportante***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_notario como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Operación vulnerable:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con ID\_operación como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*

* ***Reporte***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible del reporte, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_reporte como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Desglose:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible del reporte analizado, por lo que cumple con 1FN.*

&#x09;*-2FN: Ningún atributo puede inferirse eliminando un atributo de la clave primaria, por lo que no existen dependencias parciales y cumple así con la 2FN.*

&#x09;*-3FN: Fuera de la clave primaria compuesta, no existen atributos que determinen a otros, por lo que no existen dependencias transitivas y así se cumple la 3FN.*

&#x09;*-BCNF: La llave primaria es también candidata y únicamente por medio la llave se determina la totalidad de atributos de la tabla, siendo esta su única determinante, por lo tanto cumple con BCNF.*



* ***Transacción:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible que identifica a los actores de cada transacción hecha, por lo tanto cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_transacción como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



* ***Alerta:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible de una alerta generada por movimientos financieros, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_alerta como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*

* ***Expediente:***

&#x09;*-1FN: Cada atributo corresponde a un dato indivisible de los expedientes de casos de investigación, cumple con 1FN.*

&#x09;*-2FN: No existen dependencias parciales en la tabla, pues únicamente cuenta con Id\_expediente como llave primaria.*

&#x09;*-3FN: No existen dependencias transitivas, es decir, todos los atributos se determinan únicamente mediante la llave primaria, cumpliendo con 3FN.*

&#x09;*-BCNF: La llave primaria es el único determinante de la tabla y es también una llave candidata, por lo tanto cumple con BCNF.*



###### ***Tabla desnormalizada (Reporte):***





|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID de reporte|INT|Primary Key|
|Renglón|INT|Primary Key|
|Descripción|VARCHAR(200)|NOT NULL|
|Monto|DECIMAL(20, 2)|NOT NULL|
|Fecha de reporte|TIMESTAMP|NOT NULL|
|ID de Notario|INT|NOT NULL|
|Nombre de institución|VARCHAR(50)|NOT NULL|
|Sector económico|VARCHAR(50)|NOT NULL|



*La tabla anterior está desnormalizada a propósito para corregirla según las reglas de formas normales y posee las siguientes dependencias funcionales:*

* *ID de reporte, renglón --> descripción, monto.*
* *ID de reporte --> fecha de reporte, ID de notario.*
* *ID de notario --> Nombre de institución, sector económico.*



1. *1FN: Cada atributo de la tabla corresponde a un dato indivisible del mundo real, cumple con la 1FN.*
2. *2FN: En esta tabla existe una llave primaria compuesta, se observa que fecha de reporte e ID de notario se pueden obtener únicamente con ID de reporte, es decir, existen dependencias parciales las cuales rompen con la 2FN.*
3. *3FN:  En la tercer dependencia funcional se observa que de ID de notario dependen los atributos: Nombre de institución y sector económico, es decir, se pueden obtener atributos de un atributo que no forma parte de la llave primaria y por lo tanto, existe una dependencia transitiva, por lo que rompe la 3FN.*



*Para corregir estos errores y poder normalizar la tabla primero se separan las tablas en dos resultantes a modo de eliminar las dependencias parciales, se repite el proceso para las dependencias transitivas.*



* *a) Dependencia parcial 'ID de reporte --> fecha de reporte, ID de notario.': para eliminar esta dependencia, se separa en dos tablas que comparten un atributo en común, es decir, una tiene una llave foránea. Después de la separación de la tabla, obtenemos dos en las que podemos observar que la dependencia parcial fue eliminada y en su lugar ahora ID de reporte por sí solo sí define a estos atributos sin la necesidad de contar con Renglón como elemento de llave primaria.*



* *Reporte normalizado*



|Atributo|Tipo de dato|Restricción|
|-|-|-|
|ID de reporte|INT|PRIMARY KEY|
|Fecha de reporte|TIMESTAMP|NOT NULL|
|ID de notario|INT|NOT NULL|
|Nombre de institución|VARCHAR(50)|NOT NULL|
|Sector económico|VARCHAR(50)|NOT NULL|



* *Desglose normalizado*



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID de reporte|INT|PRIMARY KEY, FOREIGN KEY|
|Renglón|INT|PRIMARY KEY|
|Descripción|VARCHAR(200)|NOT NULL|
|Monto|DECIMAL(20,2)|NOT NULL|



* *Prueba de reunión sin pérdidas: Al calcular el cierre de la tabla Reporte normalizado usando su llave primaria (ID de reporte) observamos que se elimino la dependencia parcial que impedía cumplir con 2FN.*
* *Preservación de dependencias: La dependencia transitiva aún se conserva en Reporte normalizado, por lo que se repite el proceso de separación para poder eliminar las dependencias transitivas.*
* *La tabla Desglose normalizado ya se encuentra en 3FN y BCFN.*



* *Reporte normalizado A*



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID de reporte|INT|PRIMARY KEY|
|Fecha de reporte|TIMESTAMP|NOT NULL|
|ID de notario|INT|FOREIGN KEY, NOT NULL|



* *Reporte normalizado B*



|Atributo|Tipo de dato|Restricciones|
|-|-|-|
|ID de Notario|INT|PRIMARY KEY|
|Nombre de institución|VARCHAR(50)|NOT NULL|
|Sector económico |VARCHAR(50)|NOT NULL|



* *Prueba de reunión sin pérdidas: Al calcular el cierre de ambas tablas mediante el atributo ID de Notario, notamos que se obtienen la totalidad de atributos de la tabla Reporte Normalizado original, por lo que se comprueba la reunión sin pérdida.*
* *Preservación de dependencias: ID de reporte --> fecha de reporte, ID de notario se encuentra alojada en Reporte normalizado A, mientras que '**ID de notario --> Nombre de institución, sector económico.**' se encuentra alojada en Reporte normalizado B, por lo tanto, no se perdió ninguna dependencia.*
* *Al separar Reporte normalizado en dos tablas, observamos que la dependencia transitiva 'I**D de notario --> Nombre de institución, sector económico.'** ha desaparecido, pues ahora ID de notario define por sí mismo en una tabla aislada a estos dos atributos, por lo que al eliminar esa dependencia se cumple con la 3FN.*
* *Después de haber normalizado la tabla original, obtenemos tres tablas (Desglose normalizado, Reporte normalizado A, Reporte normalizado B) que cumplen con BCFB.*





#### ***Almacén asignado***



* ***Dim\_economía***



* ***Dim\_sismos***



* ***Dim\_tiempo***



* ***Dim\_zonas*** 

