Lo que logramos usando la función CREATE DOMAIN es que facilita la reutilización de las restricciones definidas para evitar que valores falsos o incorrectos sean ingresados en la base de datos.





TABLA DE CONTRIBUYENTE



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave primaria|Cada contribuyente (persona física o moral) posee un único e irrepetible RFC que permite identificarlos en el registro federal de contribuyentes.|**dominio\_rfc:** Es una restricción que verifica que los RFC ingresados correspondan al formato de un RFC verdadero.|
|Calle|NOT NULL|Cada contribuyente debe de contar con un domicilio fiscal en el cuál se localice la sede de sus operaciones financieras.||
|Código Postal|NOT NULL|Es no nulo porque permite ubicar el domicilio fiscal en las zonas geográficas y obligatoriamente todos los contribuyentes registrados poseen uno.|***dominio\_codigo\_postal:*** Es la restricción de dominio que verifica que el dato ingresado sea válido, garantizando que en la base de datos no existan datos incorrectos o un C.P. con letras.|
|Actividad económica|NOT NULL|Es no nulo pues todo contribuyente puede ser clasificado dentro de alguna para poner especial atención en aquellos que realizan actividades vulnerables o sectores donde el lavado de dinero es altamente probable.||
|E\_firma|NOT NULL UNIQUE|Firma electrónica asignada por el SAT a cada contribuyente, con la cual se pueden rastrear movimientos financieros y contactos con otras entidades.||



TABLA DE PERSONA FÍSICA



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave primaria|Cada persona física posee un único e irrepetible RFC que permite identificarlos en el registro federal de contribuyentes.|**dominio\_rfc:** Al ser un contribuyente aún resta validar que su RFC sea correcto y no caracteres inválidos.|
|CURP|NOT NULL UNIQUE|No puede ser nulo, pues toda persona física tiene una clave Es única porque dos contribuyentes no pueden compartir el mismo CURP, además de que permite localizar información sobre los contribuyentes.|***dominio\_curp:*** *De forma similar que el RFC, mediante comparación de caracteres con los señalados en el código sqlverifica que se trate de un CURP válido.*|
|Nombre|NOT NULL|Todos las personas físicas tienen un nombre al ser registradas en el registro federal de contribuyentes.||
|Ingresos|NOT NULL|No puede admitir nulos porque eso implicaría que no reportó su actividad económica, por lo que incluso si no genera ingresos, debe de reportar que generó 0 MXN en ingresos.|***dominio\_monto\_positivo:*** *Verifica que los ingresos no sean nulos, es decir, verifica que sean mayores o iguales que 0.*|



TABLA DE PERSONA MORAL



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave primaria|Cada persona moral posee un único e irrepetible RFC que permite identificarlos en el registro federal de contribuyentes.|**dominio\_rfc:** Al ser un contribuyente aún resta validar que su RFC sea correcto y no caracteres inválidos.|
|Representante legal|NOT NULL|Toda persona moral debe de poseer al menos un representante legal al que llegarán las denuncias o avisos de las autoridades correspondientes, por lo que no puede ser nulo.||
|Razón social|NOT NULL|Es la figura legal con el que la empresa se identifica en procesos legales y judiciales ante las autoridades, por lo que no puede ser nulo.||
|Fecha de constitución|NOT NULL|Fecha de creación de la empresa, la UIF puede consultar fechas de creación de empresas que apunten a ser sospechosas de ser empresas fachada o fantasma para encubrir actividades ilícitas.|***chk\_fecha:*** Impone una restricción que limita la fecha de constitución a la fecha actual y así evita que se registren fechas de futuros plazos.|



TABLA DE TELÉFONO



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave foránea|Cada contribuyente tiene un único RFC que permite identificarlos en el registro federal de contribuyentes.|**dominio\_rfc:** Al ser un contribuyente aún resta validar que su RFC sea correcto y no caracteres inválidos.|
|Número|Llave primaria|Toda persona moral debe de poseer al menos un representante legal al que llegarán las denuncias o avisos de las autoridades correspondientes, por lo que no puede ser nulo.|**dominio\_telefono:** Solo admite cadenas de caracteres de 10 números, excluyendo letras.|





TABLA DE LISTA DE BLOQUEADOS



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave foránea|Permite vincular a un contribuyente con un bloqueo registrado en la lista.|**dominio\_rfc:** Al ser un contribuyente aún resta validar que su RFC sea correcto y no caracteres inválidos.|
|Id\_bloqueo|Llave primaria|Permite identificar un bloqueo de la lista.|id\_positivo: No permite valores negativos|
|Fecha de bloqueo|NOT NULL|Fecha en la que fue realizada la suspensión de actividades del contribuyente o la congelación de sus activos.|fecha\_valida: La fecha del bloqueo no puede ser posterior al día cconcurrente.|
|Motivo|NOT NULL|De acuerdo a las disposiciones de la LFPIORPI y el artículo 115 de la Ley de Instituciones de Crédito, la inclusión en la Lista de Personas Bloqueadas (LPB) de la UIF nunca puede ser arbitraria ni carecer de causa fundada.||





TABLA CUENTA BANCARIA



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|RFC|Llave foránea|Permite vincular una cuenta bancaria con su dueño legal, es decir, un contribuyente.|d**ominio\_rfc:** Al ser un contribuyente aún resta validar que su RFC sea correcto y no caracteres inválidos.|
|Número de cuenta|Llave primaria|Permite identificar la cuenta bancaria al realizar investigaciones.|**numero\_cuenta:** Solo admite cadenas de textos de 16 números, validando que no se usen caracteres inválidos|
|Fecha de apertura|NOT NULL|Registro de fecha de creación para ayudar a determinar niveles de riesgo o de sospecha.|**fecha\_apertura\_cuenta:** Verifica que la fecha registrada para identificar la fecha de creación nunca sea posterior a la fecha actual.|
|Saldo|NOT NULL|Monto existente en la cuenta útil para la detección de movimientos sospechosos.||



TABLA BIEN



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|ID\_bien|Llave primaria|Permite identificar un bien o servicio individualmente y relacionarlo a una operación vulnerable.||
|Tipo de bien|NOT NULL|Clasificación indispensable para determinar la tipología del activo según los supuestos del artículo 17 de la LFPIORPI.|**clasificación:** Limita el bien a las categorías de alto riesgo monitoreadas por la ley antilavado (inmuebles, vehículos, joyas, arte, blindaje o activos virtuales).|
|Valor comercial|NOT NULL|Valuación económica indispensable para cotejar si la operación rebasa los umbrales de identificación y aviso obligatorio.|**monto\_positivo**: verifica que el valor registrado no sea menor que 0.|



TABLA DE ENTIDAD REPORTANTE



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|ID\_notario|Llave primaria|Identificador numérico unívoco del sujeto obligado o fedatario público registrado ante el sistema de recepción de avisos de la UIF.||
|Nombre\_institución|NOT NULL|Razón social o denominación formal de la institución financiera, correduría o notaría responsable del reporte.||
|Sector económico|NOT NULL|Ramo de actividad económica obligado a implementar mecanismos de prevención de operaciones con recursos de procedencia ilícita.|**sector**: verifica que la actividad económica reportada se encuentre dentro de un sector regulado por la ley antilavado|



TABLA DE OPERACIÓN VULNERABLE



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|id\_operacion|Llave primaria, NOT NULL|Folio unívoco asignado para la identificación y trazabilidad del acto u operación vulnerable ante la UIF.||
|rfc|Llave foránea, NOT NULL|Identifica al contribuyente titular o cliente involucrado en la celebración del acto vulnerable.|**dominio\_rfc:** Homologa el campo al tipo de dato creado para validar la estructura oficial del SAT (12 o 13 caracteres).|
|id\_bien|Llave foránea, NOT NULL|Vincula la transacción con el bien mueble, inmueble o activo virtual sujeto a fiscalización.|Hereda las reglas de dominio y tipo de la tabla referenciada bien.|
|id\_notario|Llave foránea, NOT NULL|Identifica al fedatario público o entidad supervisada responsable de remitir el aviso de la operación.|Hereda la integridad referencial y restricciones de entidad\_reportante.|
|valor\_pactado|NOT NULL|Monto monetario de la operación para verificar si rebasa los umbrales de identificación y aviso en UMAs.|**dominio\_monto\_positivo:** Asigna escala fija de dos decimales <br />**operacion\_valor\_positivo:** garantiza un valor mayor a cero.|
|fecha\_operacion|NOT NULL|Momento en que se concretó el acto mercantil para determinar los plazos de entrega del reporte mensual.|**operacion\_fecha\_valida:** Impide asentar operaciones con fechas posteriores al día de ejecución del sistema.|



TABLA DE REPORTE A LA UIF



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|id\_reporte|Llave primaria|Folio asignado al expediente o informe preventivo remitido a la UIF.||
|id\_notario|Llave foránea|Identifica a la entidad financiera o fedatario público que genera y remite la alerta obligatoria.|Hereda la integridad referencial y restricciones de la tabla entidad\_reportante.|
|tipo\_reporte|NOT NULL|Clasificación regulatoria del informe de acuerdo con el grado y criterio de riesgo antilavado detectado.|**reporte\_tipo:** Limita los tipos a las categorías normativas como Operación Relevante, Operación Inusual, Operación Preocupante o Aviso.|
|fecha\_recepcion|NOT NULL|Momento cronológico formal en el que la UIF registra la recepción del aviso o expediente.|**reporte\_fecha\_valida:** Impide asentar informes con fechas de recepción posteriores al día actual del sistema.|
|monto\_total|NOT NULL|Cantidad económica acumulada de los actos reportados.|**monto\_positivo:** Asigna escala fija de dos decimales|



TABLA DE DESGLOSE



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|id\_reporte|Llave primaria, Llave foránea|Identificador del informe global de la UIF al cual pertenece el renglón analítico detallado\[cite: 20].|Hereda la integridad referencial y restricciones de tipo de la tabla reporte\_uif.|
|numero\_renglon|Llave primaria|Secuencia ordinal o número de partida que enumera cada hecho u operación desglosada dentro del mismo expediente\[cite: 20].||
|descripcion|NOT NULL|Narrativa explicativa de los hechos, conceptos o indicios de riesgo que motivaron el registro de la partida\[cite: 20].||
|monto|NOT NULL|Valor monetario individualizado de la partida analizada para verificar si amerita agregación\[cite: 20].|**monto\_positivo:** Asigna escala fija de dos decimales.<br />**desglose\_monto\_positivo:** asegura un importe mayor a cero.|
|divisa|DEFAULT 'MXN'|Moneda utilizada en la operación reportada conforme al estándar bancario internacional ISO 4217\[cite: 20].|**desglose\_divisa:** Valida que la divisa pertenezca a los códigos monetarios oficiales autorizados como MXN, USD o EUR.|



TABLA DE TRANSACCIÓN



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|id\_transaccion|Llave primaria|Folio de identificación para el registro y rastreo de transferencias monetarias ante la UIF.||
|cuenta\_origen|Llave foránea|Cuenta bancaria ordenante de la cual se emite el fondo hacia una cuenta destino.|**numero\_cuenta:** Verífica que el número de cuenta conste exactamente de 16 dígitos numéricos.|
|cuenta\_destino|Llave foránea|Cuenta bancaria receptora a la cual se transfieren y acreditan los fondos monetarios.|**numero\_cuenta:** Verífica que el número de cuenta conste exactamente de 16 dígitos numéricos. <br />**cuentas\_distintas:** evita que origen y destino sean idénticos.|
|monto|NOT NULL|Cantidad económica transferida que se examina para identificar transferencias inusuales y fraccionadas.|**monto\_positivo:** Asigna escala fija de dos decimales<br />**transaccion\_monto\_positivo:** Asegura un importe mayor a cero.|
|fecha\_hora|NOT NULL|Registro temporal exacto de la transferencia para la reconstrucción cronológica de flujos de capital.|**fecha\_valida:** Impide asentar transferencias con marcas de tiempo posteriores al momento actual.|



TABLA DE ALERTA



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|id\_alerta|Llave primaria|Folio asignado para la identificación y seguimiento de la señal de alerta preventiva.||
|id\_transaccion|Llave foránea|Vincula el evento de riesgo con la transacción.|Hereda la integridad referencial y el tipo de dato de la tabla transacción.|
|fecha\_alerta|NOT NULL|Momento en que el sistema detecta y asienta la conducta sospechosa o atípica.|**fecha\_valida:** Impide asentar alertas con marcas de tiempo posteriores al momento actual del sistema.|
|nivel\_riesgo|NOT NULL|Ponderación prudencial del riesgo financiero asignada al evento conforme a las matrices de mitigación de la UIF\[cite: 21].|**nivel\_riesgo:** Limita la clasificación a los niveles reglamentarios Bajo, Medio, Alto o Crítico.|



TABLA DE EXPEDIENTE



|Atributo|Restricciones|Descripción|Dominio añadido|
|-|-|-|-|
|num\_expediente|Llave primaria|Folio oficial asignado al expediente judicial o administrativo de investigación patrimonial ante la UIF.||
|id\_alerta|Llave foránea|Vincula el procedimiento formal de investigación con la alerta preventiva que detonó el caso.|Hereda la integridad referencial y tipo de dato de la tabla alerta.|
|fecha\_apertura|NOT NULL|Momento en el que se radica el expediente y comienzan las diligencias ministeriales.|**fecha\_valida:** Impide radicar expedientes con fechas de apertura posteriores al día actual del sistema.|
|fiscal\_asignado|NOT NULL|Servidor público o agente de investigación responsable de coordinar la recopilación de evidencia del caso.|**fiscal:** Impide registrar al titular asignado mediante cadenas vacías o solo espacios en blanco.|



