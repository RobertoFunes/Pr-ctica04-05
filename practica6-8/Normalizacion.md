***1. Contribuyente***

*a) Descripción:* *Cada fila es el registro de un contribuyente (moral o físico) con identificador único y características comunes.*



*b) Semántica clara:* *Esta pauta está cubierta porque la descripción abarca únicamente los datos referentes al contribuyente, es decir, información de actividad económica, ubicación e identificación.*



*c) Anomalías:* *Si un contribuyente cambia de domicilio o actividad económica, el dato se modifica en esta única fila, evitando anomalías de actualización y contradicciones en el resto de la base, por lo tanto este punto está cubierto.*



*d) Pocos nulos:* *Pauta cubierta, pues ninguna fila puede ser un nulo, toda la información almacenada es útil para el común de todos los contribuyentes.*



*e) Tuplas espurias: La tabla está conectada adecuadamente con las tablas de las subclases mediante una única llave primaria.*



***2. Persona física***



*a) Descripción: Cada fila es una particularización de las características de las persona física sobre sus datos de identificación, así como de los ingresos generados en su actividad económica.*



*b) Semántica clara: La pauta está cubierta porque los datos almacenados son comunes únicamente a las personas físicas, pues una persona moral, por ejemplo, no tiene un CURP o un nombre con apellidos.*



*c) Anomalías: Los datos modificados se reflejan únicamente en esta tabla, evitando anomalías y repetición de datos en muchísimas tablas.*



*d) Pocos nulos: Ningún dato puede ser nulo, todos son útiles para la identificación y análisis de información sobre una persona física y sus actividades económicas.*



*e) Tuplas espurias: La tabla está conectada con la superclase contribuyente mediante una única llave foránea, lo que evita que se creen filas con datos erróneos.*



***3. Persona moral***



*a) Descripción: Cada fila guarda el detalle de una empresa o institución registrada, con datos propios como su razón social y fecha de creación.*



*b) Semántica clara: Cumple bien porque solo guarda las características exclusivas de las empresas, sin revolverlas con cosas que no tienen sentido para ellas (como los apellidos o el CURP).*



*c) Anomalías: Si la empresa cambia de razón social, el cambio se hace solo en esta fila, evitando que haya inconsistencias o que tengamos que actualizar su nombre en mil tablas diferentes.*



*d) Pocos nulos: Al estar separada de las personas físicas, todas las columnas que tiene (como el tipo de sociedad) siempre se ocupan, así que no quedan espacios en blanco.*



*e) Tuplas espurias: Se conecta directamente con la tabla contribuyente mediante su RFC, así que cuando cruzamos los datos, es imposible que salgan combinaciones de empresas con datos que no son suyos.*



***4. Transacción***



*a) Descripción: Cada fila es un movimiento real de dinero hecho de una cuenta a otra en una fecha y hora exactas.*



*b) Semántica clara: Su único propósito es guardar el evento del traspaso de dinero y cuánto fue. No mezcla quién es el dueño de la cuenta ni cuánto dinero le sobró.*



*c) Anomalías: Evita repetir los datos del banco o del titular. Si el dueño de la cuenta cambia de dirección, las transacciones anteriores siguen intactas y no se alteran.*



*d) Pocos nulos: Para que un traspaso exista, forzosamente necesita un monto, una fecha y las cuentas involucradas, así que no hay columnas vacías.*



*e) Tuplas espurias: Utiliza llaves foráneas para apuntar exactamente a las cuentas de origen y destino, evitando que las transferencias se revuelvan al consultar la base.*



***5. Cuenta bancaria***



*a) Descripción: Cada fila representa una cuenta financiera abierta por un contribuyente, guardando su saldo actual y su número de cuenta.*



*b) Semántica clara: Habla puramente del estado de la cuenta financiera. No guarda la lista de transacciones ahí mismo, solo es el contenedor del dinero.*



*c) Anomalías: El saldo vive únicamente aquí. Al no copiarlo en otras tablas, evitamos el error de actualizar el saldo en un lugar y que en otro quede viejo.*



*d) Pocos nulos: Todos los campos (número, saldo, fecha de apertura) son necesarios para abrir la cuenta, por lo que ninguna celda queda sin usar.*



*e) Tuplas espurias: Se conecta a su dueño usando el RFC, por lo que siempre sabemos de quién es cada cuenta sin que se cruce información falsa con otros clientes.*



***6. Teléfono***



*a) Descripción: Cada fila es un número de contacto que le pertenece a un contribuyente específico.*



*b) Semántica clara: Su única función es guardar números de teléfono. Hacerlo así nos ayuda a que una persona pueda tener varios números sin problema.*



*c) Anomalías: Al tener su propia tabla, no llenamos la tabla principal de contribuyente con columnas raras como "telefono\_1", "telefono\_2", que luego son difíciles de actualizar.*



*d) Pocos nulos: Evitamos tener columnas vacías en los contribuyentes que solo tienen un teléfono. Aquí cada fila agregada es un número real que sí existe.*



*e) Tuplas espurias: Su llave foránea apunta directo al contribuyente, garantizando que al buscar contactos no salgan teléfonos mezclados con personas que no son.*



***7. Reporte (Reporte UIF)***



*a) Descripción: Cada fila es un documento oficial que se genera para avisar de actividades sospechosas, con su propio folio y fecha.*



*b) Semántica clara: Representa el reporte general en sí mismo, sin meter a la fuerza todas las operaciones sospechosas dentro de sus columnas.*



*c) Anomalías: Si el estatus del reporte cambia (por ejemplo, a "aprobado"), solo se toca esta tabla. Así evitamos repetir el estado del documento en cada operación.*



*d) Pocos nulos: Todos los campos (folio, fecha, estatus) son obligatorios para generar un reporte oficial válido, no quedan nulos.*



*e) Tuplas espurias: Se relaciona correctamente con la entidad que lo crea mediante llaves foráneas, así que no hay cruces de reportes fantasmas.*



***8. Desglose***



*a) Descripción: Cada fila sirve como un puente para indicar qué operación vulnerable específica está metida dentro de qué reporte oficial.*



*b) Semántica clara: Es súper clara porque su único trabajo es conectar un reporte con una operación.*



*c) Anomalías: En lugar de repetir todo el texto del reporte adentro de la tabla de operaciones (o viceversa), esta tabla une sus identificadores, eliminando información repetida.*



*d) Pocos nulos: Al ser una tabla puente, solo usa llaves que son obligatorias, por lo que siempre está 100% llena.*



*e) Tuplas espurias: Rompe una relación pesada entre reportes y operaciones, evitando que al consultarlas se generen tablas gigantescas con datos multiplicados por error.*



***9. Entidad reportante***



*a) Descripción: Cada fila es un banco, notario o empresa que tiene la obligación por ley de mandar avisos a la UIF.*



*b) Semántica clara: Guarda exclusivamente los datos de la institución, como su nombre y a qué sector económico pertenece.*



*c) Anomalías: Si el banco cambia de nombre, solo se actualiza aquí y no en los cientos de reportes que ya mandó, lo que previene inconsistencias.*



*d) Pocos nulos: Toda entidad obligada necesita dar estos datos a fuerzas, así que no hay registros incompletos.*



*e) Tuplas espurias: Su identificador sirve como llave para conectarse con los reportes que manda, sabiendo exactamente quién reportó sin confundirse con otros bancos.*



***10. Operación vulnerable***



*a) Descripción: Cada fila es una actividad económica (como la compra de una casa o joyas) que supera ciertos límites de dinero y debe vigilarse.*



*b) Semántica clara: Se enfoca totalmente en la actividad de riesgo y cuánto costó, sin revolverlo con el reporte final o el estatus de la investigación.*



*c) Anomalías: Los detalles de la operación se registran una sola vez. No se duplican los montos ni las fechas en otras partes de la base.*



*d) Pocos nulos: Como son datos exigidos por la ley, la tabla siempre debe estar completa con fecha, monto y tipo de operación.*



*e) Tuplas espurias: Se conecta con los sujetos involucrados de forma limpia, sin crear combinaciones de datos que no ocurrieron en la realidad.*



***11. Lista de bloqueados***



*a) Descripción: Cada fila es el registro de que a un contribuyente se le han congelado sus cuentas bancarias por sospechas.*



*b) Semántica clara: Habla del castigo o bloqueo en sí, guardando el motivo y la fecha, sin meterse con los datos personales o las transacciones del contribuyente.*



*c) Anomalías: Si se levanta el bloqueo o se cambia el motivo, se hace directamente aquí, sin tener que andar buscando y modificando las tablas de las cuentas bancarias.*



*d) Pocos nulos: Cualquier bloqueo necesita a fuerzas un motivo y una fecha por cuestiones legales, no hay espacios en blanco.*



*e) Tuplas espurias: La llave foránea apunta directo al RFC, por lo que es imposible que al cruzar tablas aparezca como bloqueado alguien que está limpio.*



***12. Expediente***

*a) Descripción: Cada fila es una investigación abierta por la UIF contra alguien debido a que saltaron las alarmas.*



*b) Semántica clara: Solo guarda cómo va la investigación y cuándo se abrió, separando el caso general de las alertas individuales que lo provocaron.*



*c) Anomalías: La resolución del caso se guarda solo aquí. Si se declarara la resolución en cada alerta, tendríamos que actualizar todo repetido.*



*d) Pocos nulos: Al abrir un expediente, automáticamente tienes un ID y una fecha, por lo que siempre se usan sus columnas.*



*e) Tuplas espurias: Las llaves foráneas conectan el expediente exactamente con la alerta que le toca, evitando mezclar investigaciones de casos diferentes.*



***13. Bien***

*a) Descripción: Cada fila representa un activo de alto valor (como un inmueble, un auto de lujo o joyas) que le pertenece a un contribuyente y está bajo el radar de la UIF.*



*b) Semántica clara: Describe puramente al objeto físico, qué es y cuánto cuesta. No revuelve estos datos con las cuentas bancarias ni con los reportes.*



*c) Anomalías: Si la casa o el auto suben de valor comercial, el precio se actualiza solo en esta celda. Así evitamos repetir el valor del bien en mil documentos diferentes, lo que causaría inconsistencias.*



*d) Pocos nulos: Para que un bien se registre, la ley obliga a saber qué tipo de bien es y cuál es su valor estimado, por lo que ninguna columna se queda vacía.*



*e) Tuplas espurias: Se conecta al dueño original usando el RFC como llave foránea. Esto garantiza que, al hacer búsquedas, no le asignemos yates o mansiones a contribuyentes que nada que ver.*



***14. Alerta***

*a) Descripción: Cada fila es una señal de advertencia automática que genera el sistema al detectar un movimiento o comportamiento financiero que parece sospechoso.*



*b) Semántica clara: Se enfoca totalmente en el evento de la alarma, indicando cuándo sonó y su nivel de gravedad, sin meter el expediente completo de investigación ahí mismo.*



*c) Anomalías: La información de la advertencia vive de forma independiente. Si el riesgo sube de "Bajo" a "Crítico", el cambio se hace en esta única fila, evitando errores de actualización.*



*d) Pocos nulos: (Fallo intencional detectado) Esta tabla falla en esta pauta. Como incluimos una columna llamada justificacion\_descarte (para cuando es falsa alarma), el 90% de las filas tienen este espacio vacío (NULL), ya que la mayoría de las alertas sí proceden a revisión. Lo ideal habría sido separar los descartes en otra tabla.*



*e) Tuplas espurias: Cuenta con llaves foráneas bien definidas que apuntan a la transacción que hizo saltar la alarma, impidiendo cruzar datos con operaciones limpias al hacer un JOIN.*



##### *Ejercicio 1.2: Dependencias funcionales*



1. ***Contribuyente***



*Dependencia Funcional: RFC --> actividad económica, e\_firma, domicilio fiscal (calle y C.P.).*

*Regla de negocio: El RFC es el identificador único de un contribuyente, cualquiera que sea el tipo que a su vez posee un domicilio fiscal y una actividad económica asociada.*



***2. Persona física***



*Dependencia Funcional: RFC --> CURP, Nombre, Ingresos.*

*Regla de negocio: Estos tres atributos están asociados de forma única a un RFC que pertenece a una persona física y sirven para su identificación y análisis de actividades.*



***3. Persona moral***



*Dependencia Funcional: RFC --> Representante legal, razón social, fecha de constitución.*

*Regla de negocio: Toda empresa está registrada bajo un único RFC, posee un representante legal, un nombre por el cual se identifica legalmente (razón social) y una fecha de creación.*



***4. Teléfono***



*Dependencia Funcional: No tiene dependencias funcionales no triviales.*

*Regla de negocio: La tabla está conformada por su llave primaria compuesta (rfc, numero\_telefono), sirviendo solo como puente de multiplicidad, por lo que carece de atributos subordinados.*



***5. Desglose***



*Dependencia Funcional: ID Reporte, Renglon --> Descripción, monto, divisa.*

*Regla de negocio: Un desglose de reporte está asociado con un único reporte y a su vez identifica la causa por la que fue originado y la descripción del análisis realizado por la UIF, que incluye el motivo, la cantidad de dinero involucrada y la divisa.*



***6. Reporte UIF***



*Dependencia Funcional: ID de reporte --> ID de notario, tipo de reporte, fecha de recepción, monto total.*

*Regla de negocio: Cada reporte tiene un identificador único, el cuál a su vez vinculo el contenido de este (tipo de reporte, fecha que se recibió y el monto reportado) con la entidad que lo reporta (el notario).*



***7. Lista de bloqueados***



*Dependencia Funcional: ID de bloqueo --> RFC, fecha de bloqueo, motivo.*

*Regla de negocio: Cada bloqueo se identifica a sí mismo de forma única, así como también contiene la descripción del motivo por el cual fue bloqueado y la fecha correspondiente a la sanción y cada sanción se encuentra asociada a un contribuyente mediante el RFC.*



***8. Transacción***



*Dependencia Funcional: ID de transacción --> Emisor, receptor, monto, fecha y hora.*

*Regla de negocio: Cada transacción se identifica mediante un código único que permite averiguar desde que cuenta bancaria se envió dinero y en que cantidad y fecha a una cuenta destinataria.*



***9. Operación vulnerable***



*Dependencia Funcional: ID de operación --> RFC, ID de bien, ID de notario, valor pactado, fecha.*

*Regla de negocio: Toda operación vulnerable reúne tres actores necesarios para poder existir, una entidad reportante, el bien adquirido y el valor pactado el cuál se le atribuye, cada Id de operación representa un único evento de comercio del mundo real.*



***10. Expediente***



*Dependencia Funcional: Número de expediente --> ID de alerta, fecha de apertura, fiscal asignado.*

*Regla de negocio: Cada expediente de investigación abierto por la UIF está relacionado a una única alerta en una determinada fecha y cuenta con un fiscal asignado para el seguimiento jurídico del caso.*



***11. Entidad reportante***



*Dependencia Funcional: ID del notario --> Nombre de la institución, sector económico.*

*Regla de negocio: Todo notario es identificado por un nombre legal y que mediante el identificador otorgado por el organismo responsable (UIF o SHCP) es asociado a un grupo económico determinado por las leyes vigentes.*



***12. Cuenta bancaria***



*Dependencia Funcional: Número de cuenta --> RFC, fecha de apertura, saldo.*

*Regla de negocio: Cada identificador representa una cuenta bancaria que contiene información útil a los intereses de la UIF, como la fecha de apertura y el saldo existente, y que esta ligada a un único contribuyente mediante su RFC.*



***13. Bien***



*Dependencia Funcional: ID de bien --> Tipo de bien, valor comercial.*

*Regla de negocio: Cada bien está identificado de forma única por la UIF, clasificando también el tipo de bien (producto o servicio) y el valor comercial que posee con el fin de ligar cada bien con una operación vulnerable y analizar las operaciones en las que se vuelve fácil esconder delitos fiscales.*



***14. Alerta***



*Dependencia Funcional: ID de alerta --> Id transacción, fecha de emisión, nivel de riesgo.*

*Regla de negocio: Una transacción puede provocar alertas, las cuales son identificadas por un ID y contienen información relativo al suceso que las provocó, como la fecha acompañada de un nivel de riesgo.*



#### ***2. Cálculo del Cierre de Atributos***



***1. Tabla: Contribuyente***



*Total de columnas (T): {rfc, calle, codigo\_postal, actividad\_economica, e\_firma}*



*Cálculo:*



*Tenemos el identificador: {rfc}+ = {rfc}*



*Usando la regla de negocio, el RFC desbloquea el resto de los datos: {rfc}+ = {rfc, calle, codigo\_postal, actividad\_economica, e\_firma}*



*Conclusión: Como con solo el RFC es posible recolectar todas las columnas de la tabla ({rfc}+ = T), se comprueba que rfc es la llave primaria.*



***2. Tabla: Persona moral***



*Total de columnas (T): {rfc, razon\_social, fecha\_constitucion, representante\_legal}*



*Cálculo:*



*Iniciamos con: {rfc}+ = {rfc}*



*La regla dice que el RFC de una empresa nos da su nombre oficial y cuándo se creó, además de su representante legal: {rfc}+ = {rfc, razon\_social, fecha\_constitucion}*



*Conclusión: El cierre se completó ({rfc}+ = T), demostrando que rfc es su llave primaria.*



***3. Tabla: Persona física***



*Total de columnas (T): {rfc, curp, nombre, ingresos}*



*Cálculo:*



*Iniciamos con: {rfc}+ = {rfc}*



*Al ser una persona, el RFC nos da sus datos personales e información sobre ingresos financieros: {rfc}+ = {rfc, curp, nombre, ingresos}*



*Conclusión: Juntamos todas las columnas ({rfc}+ = T), por lo que rfc es la llave primaria.*



***4. Tabla: Teléfono***



*Total de columnas (T): {rfc, numero\_telefono}*



*Cálculo:*



*Como un contribuyente puede tener varios teléfonos, empezamos juntando dos datos: {rfc, numero\_telefono}+ = {rfc, numero\_telefono}*



*Con el número obtenemos el RFC asociado, pero sin un número de teléfono no tiene sentido una tabla multivaluada: {rfc}+ = {rfc, numero\_telefono}*



*Conclusión: Se necesita la unión de ambos para tener la tabla completa, así que la llave primaria es compuesta: (rfc, numero\_telefono).*



***5. Tabla: Desglose***



*Total de columnas (T): {id\_reporte, numero\_renglon, descripcion, monto, divisa}*



*Cálculo:*



*Es una tabla que corresponde a una relación con una entidad débil, así que se usa la clave foránea y primaria: {folio\_reporte, id\_operacion}+ = {folio\_reporte, id\_operacion}*



*En conjunto ambos atributos identifican un reporte y el análisis elaborado: {folio\_reporte, id\_operacion}+ = {id\_reporte, numero\_renglon, descripcion, monto, divisa}*



*Conclusión: Se comprueba que su llave primaria es la combinación (folio\_reporte, id\_operacion).*



***6. Tabla: Reporte UIF***



*Total de columnas (T): {folio\_reporte, id\_entidad, fecha\_reporte, estatus}*



*Cálculo:*



*Empezamos con el puro folio: {folio\_reporte}+ = {folio\_reporte}*



*Con el folio del reporte podemos saber quién lo mandó, cuándo y su estado: {folio\_reporte}+ = {folio\_reporte, id\_entidad, fecha\_reporte, estatus}*



*Conclusión: Se llena el conjunto ({folio\_reporte}+ = T), así que folio\_reporte es la llave.*



***7. Tabla: Lista de bloqueados***



*Total de columnas (T): {id\_bloqueo, rfc, fecha\_bloqueo, motivo}*



*Cálculo:*



*Seleccionamos el ID de la restricción o bloqueo impuesto : {id\_bloqueo}+ = {id\_bloqueo}*



*Este ID de bloqueo indica que contribuyente fue bloqueado o sancionado, cuándo y por qué: {id\_bloqueo}+ = {id\_bloqueo, rfc, fecha\_bloqueo, motivo}*



*Conclusión: Obtenemos todas las columnas ({id\_bloqueo}+ = T), comprobando que id\_bloqueo es la llave primaria.*



***8. Tabla: Transacción***



*Total de columnas (T): {id\_transaccion, cuenta\_origen, cuenta\_destino, monto, fecha\_hora}*



*Cálculo:*



*Seleccioné el atributo: {id\_transaccion}+ = {id\_transaccion}*



*El ID de la transferencia indica quien mandó dinero, quién recibió y cuánto: {id\_transaccion}+ = {id\_transaccion, cuenta\_origen, cuenta\_destino, monto, fecha\_hora}*



*Conclusión: El cierre está completo ({id\_transaccion}+ = T); la llave es id\_transaccion.*



***9. Tabla: Operación vulnerable***



*Total de columnas (T): {id\_operacion, id\_contribuyente, id\_entidad, id\_bien, fecha, monto\_operacion}*



*Cálculo:*



*Seleccionamos el atributo: {id\_operacion}+ = {id\_operacion}*



*El ID de la operación indica quién realizó la oepración, qué compró y ante quién es declarada tal compra: {id\_operacion}+ = {id\_operacion, id\_contribuyente, id\_entidad, id\_bien, fecha, monto\_operacion}*



*Conclusión: Recolectamos todo ({id\_operacion}+ = T), así que id\_operacion es la llave.*



***10. Tabla: Expediente***



*Total de columnas (T): {id\_expediente, id\_alerta, fecha\_apertura, fiscal\_asignado}*



*Cálculo:*



*Iniciamos con: {id\_expediente}+ = {id\_expediente}*



*El número de expediente indica de qué alerta nació y el fiscal asignado para su seguimiento jurídico: {id\_expediente}+ = {id\_expediente, id\_alerta, fecha\_apertura, fiscal\_asignado}*



*Conclusión: El conjunto abarca toda la tabla ({id\_expediente}+ = T); la llave es id\_expediente.*



***11. Tabla: Entidad reportante***



*Total de columnas (T): {id\_notario, nombre\_institucion, sector\_economico}*



*Cálculo:*



*Empezamos con su identificador de registro: {id\_notario}+ = {id\_notario}*



*Este número nos da el nombre del notario/banco y a qué sector pertenece: {id\_notario}+ = {id\_notario, nombre\_institucion, sector\_economico}*



*Conclusión: Se obtiene el total ({id\_notario}+ = T), comprobando que id\_notario es la llave primaria.*



***12. Tabla: Cuenta bancaria***



*Total de columnas (T): {numero\_cuenta, rfc, fecha\_apertura, saldo}*



*Cálculo:*



*Iniciamos con: {numero\_cuenta}+ = {numero\_cuenta}*



*El número de cuenta nos dice de quién es y cuánto dinero tiene: {numero\_cuenta}+ = {numero\_cuenta, rfc, fecha\_apertura, saldo}*



*Conclusión: Todo coincide ({numero\_cuenta}+ = T); la llave es numero\_cuenta.*



***13. Tabla: Bien***



*Total de columnas (T): {id\_bien, rfc, tipo\_bien, valor\_comercial}*



*Cálculo:*



*Empezamos con: {id\_bien}+ = {id\_bien}*



*El ID del objeto nos dice a quién pertenece, si es casa o auto, y cuánto cuesta: {id\_bien}+ = {id\_bien, rfc, tipo\_bien, valor\_comercial}*



*Conclusión: Completamos la tabla ({id\_bien}+ = T), la llave es id\_bien.*



***14. Tabla: Alerta***



*Total de columnas (T): {id\_alerta, id\_transaccion, fecha\_alerta, nivel\_gravedad, justificacion\_descarte}*



*Cálculo:*



*Iniciamos con el folio de la alarma: {id\_alerta}+ = {id\_alerta}*



*Este ID nos revela por qué transacción sonó la alarma y si fue falsa: {id\_alerta}+ = {id\_alerta, id\_transaccion, fecha\_alerta, nivel\_gravedad, justificacion\_descarte}*



*Conclusión: Al tener el 100% de los datos ({id\_alerta}+ = T), demostramos que id\_alerta es la llave primaria.*



#### ***3. Reducción a un conjunto mínimo***





***-Contribuyente***



*a) Lado derecho simple:*

rfc --> calle

rfc --> C.P.

rfc --> Actividad económica

rfc --> firma electrónica



*b) Atributos sobrantes:*

No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.



*c) Dependencias redundantes:*

No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.



*Reducción mínima:*

rfc --> calle

rfc --> C.P.

rfc --> Actividad económica

rfc --> firma electrónica





***-Persona física***



*a) Lado derecho simple*

rfc --> CURP

rfc --> Nombre

rfc --> Ingresos



*b) Atributos sobrantes*

No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.



*c) Dependencias redundantes*

No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.



*Reducción mínima:*

rfc --> CURP

rfc --> Nombre

rfc --> Ingresos





***-Persona moral***



*a) Lado derecho simple*

rfc --> Razón social

rfc --> Fecha de constitución

rfc --> Representante legal



*b) Atributos sobrantes*

No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.



*c) Dependencias redundantes*

No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.



*Reducción mínima:*

rfc --> Razón social

rfc --> Fecha de constitución

rfc --> Representante legal





***-Teléfono***



*a) Lado derecho simple:*

*No es posible hacer esta descomposición porque no contiene dependencias funcionales no triviales.*



*b) Atributos sobrantes:*

*No es posible evaluar porque no existen dependencias funcionales no triviales.*



*c) Dependencias redundantes:*

*Estas son un conjunto vacío*



*Reducción mínima:*

*La tabla ya se encuentra reducida a su forma mínima.*



***-Lista de bloqueados***



*a) Lado derecho simple:*

*id\_bloqueo --> RFC*

*id\_bloqueo --> Fecha*

*id\_bloqueo --> Motivo*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*id\_bloqueo --> RFC*

*id\_bloqueo --> Fecha*

*id\_bloqueo --> Motivo*





***-Cuenta bancaria***



*a) Lado derecho simple:*

*número de cuenta --> RFC*

*número de cuenta --> Fecha de apertura*

*número de cuenta --> Saldo*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*número de cuenta --> RFC*

*número de cuenta --> Fecha de apertura*

*número de cuenta --> Saldo*





***-Bien***



*a) Lado derecho simple:*

*id\_bien --> Tipo*

*id\_bien --> Valor comercial*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*id\_bien --> Tipo*

*id\_bien --> Valor comercial*





***-Entidad reportante***



*a) Lado derecho simple:*

*id\_notario --> Nombre de la institución*

*id\_notario --> Sector económico*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*id\_notario --> Nombre de la institución*

*id\_notario --> Sector económico*





***-Operación Vulnerable***



*a) Lado derecho simple:*

*Id\_operación --> RFC*

*Id\_operación --> Id\_bien*

*Id\_operación --> Id\_notario*

*Id\_operación --> Valor pactado*

*Id\_operación --> Fecha de operación*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*Id\_operación --> RFC*

*Id\_operación --> Id\_bien*

*Id\_operación --> Id\_notario*

*Id\_operación --> Valor pactado*

*Id\_operación --> Fecha de operación*





***-Reporte UIF***



*a) Lado derecho simple:*

*id\_reporte --> Id\_notario*

*id\_reporte --> Tipo de reporte*

*id\_reporte --> Fecha de recepción*

*id\_reporte --> Monto total*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*id\_reporte --> Id\_notario*

*id\_reporte --> Tipo de reporte*

*id\_reporte --> Fecha de recepción*

*id\_reporte --> Monto total*





***-Desglose***



*a) Lado derecho simple:*

*Id\_reporte, Número de renglón --> Descripción*

*Id\_reporte, Número de renglón --> Monto*

*Id\_reporte, Número de renglón --> Divisa*



*b) Atributos sobrantes:*

*Al eliminar un atributo de la clave primaria, no es posible determinar de forma alguna la totalidad de los atributos, por lo tanto en ambos casos ninguno es sobrante.*



*c) Dependencias redundantes:*

*Al eliminar un atributo de la regla, no es posible determinarlo o conocerlo mediante otra, por lo tanto, no contiene dependencias redundantes y la tabla se encuentra en su forma mínima.*



*Reducción mínima:*

*Id\_reporte, Número de renglón --> Descripción*

*Id\_reporte, Número de renglón --> Monto*

*Id\_reporte, Número de renglón --> Divisa*





***-Transacción***



*a) Lado derecho simple:*

*Id\_transacción --> Emisor*

*Id\_transacción --> Receptor*

*Id\_transacción --> Monto*

*Id\_transacción --> Fecha y hora*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*Id\_transacción --> Emisor*

*Id\_transacción --> Receptor*

*Id\_transacción --> Monto*

*Id\_transacción --> Fecha y hora*





***-Alerta***



*a) Lado derecho simple:*

*Id\_alerta --> Id\_transacción*

*Id\_alerta --> Nivel de riesgo*

*Id\_alerta --> Fecha*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*Id\_alerta --> Id\_transacción*

*Id\_alerta --> Nivel de riesgo*

*Id\_alerta --> Fecha*





***-Expediente***



*a) Lado derecho simple:*

*Número de expediente --> Id\_alerta*

*Número de expediente --> Fecha de apertura*

*Número de expediente --> Fiscal asignado*



*b) Atributos sobrantes:*

*No es posible probar este punto, pues solo se cuenta con un único atributo en el lado izquierdo.*



*c) Dependencias redundantes:*

*No fue posible obtener todos los atributos al omitir cualquier dependencia, por lo que no tiene dependencias redundantes, todas son necesarias.*



*Reducción mínima:*

*Número de expediente --> Id\_alerta*

*Número de expediente --> Fecha de apertura*

*Número de expediente --> Fiscal asignado*



***Implementación del esquema resultante:*** <i>En la imagen se observa que la operación SELECT devolvió los 4 renglones originales sin alteraciones, lo que comprueba que no se perdió información en el proceso de normalización en el esquema resultante.</i>



!\[Evidencia de población de tabla](/evidencias/poblacion\_tabla\_desnormalizada.png)







