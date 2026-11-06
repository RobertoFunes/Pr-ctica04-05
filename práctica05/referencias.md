# Práctica 5 - Integridad Referencial y Acciones Referenciales

**Proyecto Propio:** Sistema de Prevención y Detección de Lavado de Dinero (UIF)  
**Programa Académico:** Ingeniería en Inteligencia Artificial / Plan 2020  
**Unidad de Aprendizaje:** Bases de Datos  

---

## Ejercicio 2.1. Las Claves Foráneas del Proyecto Propio

La integridad referencial garantiza que ninguna clave foránea apunte a un registro inexistente. En el modelo relacional de la UIF, cada clave foránea materializa una interrelación del diagrama EER (Especializaciones, Agregaciones, Composiciones y Asociaciones operativas).

A continuación se presenta el inventario exhaustivo de las claves foráneas, su origen, destino y su política de nulabilidad determinada por la cardinalidad mínima de la relación en el modelo conceptual:

| # | Relación EER Implementada | Tabla Hija (Origen) | Columna FK | Tabla Padre (Referenciada) | Columna PK | ¿Admite Nulos? | Justificación por Cardinalidad Mínima |
|---|---|---|---|---|---|:---:|---|
| 1 | Especialización *es-un* (Persona Física) | `persona_fisica` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Una persona física no puede existir en el sistema sin estar registrada primero como contribuyente base. |
| 2 | Especialización *es-un* (Persona Moral) | `persona_moral` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Una persona moral requiere forzosamente existir en el catálogo maestro de contribuyentes. |
| 3 | Asociación *Posee-Teléfono* (Multivalorado) | `telefono` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Forma parte de la clave primaria compuesta; un teléfono sin contribuyente asociado carece de significado. |
| 4 | Registro *Inclusión-Lista-Negra* | `lista_bloqueados` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: La orden de aseguramiento de fondos de la UIF debe vincularse obligatoriamente a un contribuyente específico. |
| 5 | Titularidad *Apertura-Cuenta* | `cuenta_bancaria` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: En el marco bancario mexicano, ninguna cuenta de depósito puede existir sin un titular tributario plenamente identificado. |
| 6 | Participación *Sujeto-Operación-Vulnerable* | `operacion_vulnerable` | `rfc` | `contribuyente` | `rfc` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: El aviso antilavado exige identificar indubitablemente al cliente que celebra el acto vulnerable. |
| 7 | Objeto *Bien-Transaccionado* | `operacion_vulnerable` | `id_bien` | `bien` | `id_bien` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Toda operación vulnerable debe recaer sobre un activo patrimonial cuantificable (inmueble, joyas, vehículos). |
| 8 | Intervención *Fe-Pública / Notarial* | `operacion_vulnerable` | `id_notario` | `entidad_reportante` | `id_notario` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: La ley antilavado obliga a reportar la clave de la entidad o fedatario que protocolizó el aviso. |
| 9 | Emisión *Reporte-Regulatorio* | `reporte_uif` | `id_notario` | `entidad_reportante` | `id_notario` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Todo informe de inteligencia enviado a la UIF debe tener un emisor institucional responsable. |
| 10 | Composición débil *Detalle-Renglón* | `desglose` | `id_reporte` | `reporte_uif` | `id_reporte` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Entidad débil por identificación; una partida individual no existe fuera de su reporte contenedor. |
| 11 | Flujo Financiero *Débito-Origen* | `transaccion` | `cuenta_origen` | `cuenta_bancaria` | `numero_cuenta` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Toda transferencia electrónica interbancaria (SPEI) requiere una cuenta emisora de fondos. |
| 12 | Flujo Financiero *Crédito-Destino* | `transaccion` | `cuenta_destino` | `cuenta_bancaria` | `numero_cuenta` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: La dispersión de fondos exige forzosamente una cuenta receptora destino válida. |
| 13 | Monitoreo *Disparo-Alerta-Anómala* | `alerta` | `id_transaccion` | `transaccion` | `id_transaccion` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Un alertamiento de riesgo surge única y exclusivamente a partir del monitoreo de una transacción registrada. |
| 14 | Judicialización *Apertura-Carpeta* | `expediente` | `id_alerta` | `alerta` | `id_alerta` | **NO** (`NOT NULL`) | Cardinalidad mínima 1: Un expediente ministerial de la UIF se apertura formalmente con fundamento en una alerta de inteligencia previa. |

---

## Ejercicio 2.2. Acciones Referenciales

Las acciones referenciales definen el comportamiento de la base de datos ante operaciones de eliminación (`ON DELETE`) o modificación (`ON UPDATE`) sobre la clave primaria de la tabla padre.

Para el sistema de la UIF, estas acciones no se eligen al azar: están dictadas por el **principio de inalterabilidad probatoria y trazabilidad legal**.

| Clave Foránea (`Hija -> Padre`) | Acción `ON DELETE` | Acción `ON UPDATE` | Regla del Dominio (Justificación en una sola línea) |
|---|:---:|:---:|---|
| `persona_fisica(rfc) -> contribuyente(rfc)` | `CASCADE` | `CASCADE` | Si se suprime el contribuyente base, se extinguen en cascada sus atributos específicos de persona física. |
| `persona_moral(rfc) -> contribuyente(rfc)` | `CASCADE` | `CASCADE` | La cancelación registral del contribuyente moral elimina automáticamente sus datos constitutivos asociados. |
| `telefono(rfc) -> contribuyente(rfc)` | `CASCADE` | `CASCADE` | Los números de contacto pierden validez jurídica si el contribuyente causante es purgado del padrón. |
| `lista_bloqueados(rfc) -> contribuyente(rfc)` | `CASCADE` | `CASCADE` | Al eliminar la entidad matriz del padrón, se retira en cascada su mandamiento de aseguramiento precautorio. |
| `cuenta_bancaria(rfc) -> contribuyente(rfc)` | `CASCADE` | `CASCADE` | La baja administrativa de un contribuyente liquida el registro de sus contratos de cuentas bancarias. |
| `operacion_vulnerable(rfc) -> contribuyente(rfc)` | `RESTRICT` | `CASCADE` | Se prohíbe borrar a un contribuyente mientras existan operaciones sospechosas reportadas a su nombre por valor probatorio. |
| `operacion_vulnerable(id_bien) -> bien(id_bien)` | `RESTRICT` | `CASCADE` | Ningún bien puede desincorporarse del catálogo si está sujeto a una investigación por operación vulnerable activa. |
| `operacion_vulnerable(id_notario) -> entidad_reportante(id_notario)` | `RESTRICT` | `CASCADE` | Se prohíbe eliminar a la entidad reportante mientras subsistan declaraciones de operaciones avaladas por su firma. |
| `reporte_uif(id_notario) -> entidad_reportante(id_notario)` | `RESTRICT` | `CASCADE` | Una institución financiera o notaría no puede borrarse si ha remitido reportes regulatorios al Estado. |
| `desglose(id_reporte) -> reporte_uif(id_reporte)` | `CASCADE` | `CASCADE` | Las partidas de desglose son dependencias débiles que carecen de autonomía si se anula el reporte que las agrupa. |
| `transaccion(cuenta_origen) -> cuenta_bancaria(numero_cuenta)` | `RESTRICT` | `CASCADE` | Una cuenta bancaria jamás debe destruirse físicamente si tiene transferencias originadas en la bitácora financiera. |
| `transaccion(cuenta_destino) -> cuenta_bancaria(numero_cuenta)` | `RESTRICT` | `CASCADE` | Una cuenta bancaria con abonos monetarios recibidos no puede borrarse para preservar la pista de auditoría. |
| `alerta(id_transaccion) -> transaccion(id_transaccion)` | `CASCADE` | `CASCADE` | Si una transacción fue invalidada y retirada del motor transaccional, sus alertas generadas se descartan en cascada. |
| `expediente(id_alerta) -> alerta(id_alerta)` | `RESTRICT` | `CASCADE` | Una alerta que dio origen a una carpeta de investigación penal queda blindada contra eliminación involuntaria. |

### Justificación Técnica de las Elecciones:
1. **Uso de `RESTRICT`**: Protege la evidencia jurídica en transacciones y expedientes penales. Evita que un operador o usuario borre por error entidades clave cuyos movimientos son materia de investigación ministerial.
2. **Uso de `CASCADE`**: Se restringe exclusivamente a jerarquías de especialización (*subtipos* persona física/moral), atributos multivalorados (*teléfonos*) y entidades débiles compuestas (*desgloses* de un reporte).
3. **Uso de `ON UPDATE CASCADE` universal**: Garantiza que si la autoridad tributaria o bancaria homologa o reclasifica una clave primaria de negocio (como una corrección de RFC o número de cuenta CLABE), todas las relaciones dependientes actualicen su puntero de forma consistente y transparente.
