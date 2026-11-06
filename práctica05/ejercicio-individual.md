# Ejercicio 2.6. Trabajo Individual - Análisis de Cambio de Acción Referencial

**Estudiante / Integrante:** Equipo UIF - Alumno Responsable de Práctica 5 (`prdx919`)  
**Programa Académico:** Ingeniería en Inteligencia Artificial / Plan 2020  
**Unidad de Aprendizaje:** Bases de Datos  
**Proyecto Propio:** Sistema de Prevención y Detección de Lavado de Dinero (UIF)  

---

## 1. Relación Seleccionada

* **Tabla Padre:** `cuenta_bancaria` (Clave primaria: `numero_cuenta`)
* **Tabla Hija:** `transaccion` (Clave foránea: `cuenta_origen`)
* **Acción Referencial Original en Producción:** `ON DELETE RESTRICT`

---

## 2. Hipótesis del Experimento en Base de Copia

En una copia de la base de datos de la UIF, modificamos la restricción para sustituir la política de protección estricta (`RESTRICT`) por una política de propagación en cascada (`CASCADE`):

```sql
-- Sentencias de migración aplicadas en la copia:
ALTER TABLE transaccion 
    DROP CONSTRAINT fk_transaccion_cuenta_origen;

ALTER TABLE transaccion 
    ADD CONSTRAINT fk_transaccion_cuenta_origen
        FOREIGN KEY (cuenta_origen) REFERENCES cuenta_bancaria(numero_cuenta)
        ON DELETE CASCADE ON UPDATE CASCADE;
```

---

## 3. Demostración Práctica con Datos Reales

### 3.1 Estado de la Base de Datos Antes del Borrado:
* **Cuenta Bancaria a Evaluar:** `4152313188992211` (Perteneciente a un contribuyente bajo investigación).
* **Consultas de Verificación:**
  ```sql
  SELECT numero_cuenta, saldo FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
  -- Retorna: 1 cuenta con saldo de $1,250,000.00 MXN

  SELECT COUNT(*), SUM(monto) FROM transaccion WHERE cuenta_origen = '4152313188992211';
  -- Retorna: 6 transacciones registradas por un total transferido de $2,840,000.00 MXN

  SELECT COUNT(*) FROM alerta WHERE id_transaccion IN (
      SELECT id_transaccion FROM transaccion WHERE cuenta_origen = '4152313188992211'
  );
  -- Retorna: 3 alertas de riesgo crítico generadas por el motor analítico
  ```

---

### 3.2 Ejecución del Borrado del Registro Padre:
Un usuario con permisos de escritura ejecuta la supresión de la cuenta bancaria:
```sql
DELETE FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
-- Resultado: DELETE 1 (Ejecutado con éxito bajo CASCADE)
```

---

### 3.3 Estado de la Base de Datos Después del Borrado:
```sql
-- 1. Verificación de la cuenta bancaria:
SELECT COUNT(*) FROM cuenta_bancaria WHERE numero_cuenta = '4152313188992211';
-- Retorna: 0 (Cuenta eliminada)

-- 2. Verificación de las transacciones financieras hijas:
SELECT COUNT(*) FROM transaccion WHERE cuenta_origen = '4152313188992211';
-- Retorna: 0 (¡6 transferencias por $2,840,000.00 MXN desaparecieron!)

-- 3. Verificación de alertas asociadas:
SELECT COUNT(*) FROM alerta WHERE id_transaccion IN (
    SELECT id_transaccion FROM transaccion WHERE cuenta_origen = '4152313188992211'
);
-- Retorna: 0 (¡3 alertas críticas de lavado de activos borradas en cascada!)
```

---

## 4. Análisis Crítico: ¿Qué se perdió, qué se conservó y cuál es la correcta?

### 4.1 ¿Qué se perdió? (Impacto Destructivo):
1. **Evidencia Forense:** Se destruyó irrevocablemente el historial de transferencias bancarias de la cuenta investigada.
2. **Alertas de Inteligencia:** Se borraron las alertas de operaciones sospechosas asociadas a esas transferencias, inutilizando los modelos predictivos de la UIF.
3. **Pistas de Destino:** Las cuentas receptoras que recibieron los \$2.84 millones de pesos ahora tienen depósitos cuyo origen es imposible rastrear, destruyendo la trazabilidad financiera del esquema de dispersión (*pitufeo*).

### 4.2 ¿Qué se conservó?:
Únicamente se conservaron los registros de los contribuyentes dueños de las cuentas destino y sus saldos, pero el flujo causal quedó desarticulado.

### 4.3 ¿Cuál de las dos opciones es la correcta para el dominio y por qué?
> **Conclusión Fundamentada:** **La acción correcta e indispensable para el dominio de la UIF es `ON DELETE RESTRICT`.**

#### Razones del Dominio Financiero y Jurídico:
1. **Cumplimiento Legal (LFPIORPI y CNBV):** El marco normativo mexicano para el Sistema Financiero y la UIF obliga a las instituciones bancarias y autoridades reguladoras a resguardar la bitácora transaccional por un periodo mínimo de **10 años**. Permitir un `CASCADE` violaría preceptos constitucionales de preservación probatoria.
2. **Prevención del Fraude y Sabotaje Interno:** Si un empleado o atacante malintencionado lograra eliminar una cuenta bancaria, bajo `CASCADE` borraría de un solo golpe todas las pruebas de sobornos, desvíos o lavado de dinero asociadas a ella. Con `RESTRICT`, el gestor aborta la operación y avisa que existen registros vinculados.
3. **Manejo Correcto en Caso de Cancelación:** Si un cliente cancela su contrato bancario en la vida real, el sistema debe aplicar un **Borrado Lógico** (`UPDATE cuenta_bancaria SET estado = 'CANCELADA'`), pero **jamás un `DELETE` físico en cascada**.

---
**Firma:**  
*Responsable de la Práctica 5 - Modelado e Integridad Referencial*  
*Equipo de Desarrollo e Inteligencia de Datos - UIF*
