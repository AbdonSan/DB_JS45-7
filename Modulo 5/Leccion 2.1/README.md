# Módulo 5 – Lección 2.1: Finanzas Personales con SQL

## Objetivo
Practicar funciones de agregación (`SUM`, `AVG`, `MAX`), subconsultas, operaciones aritméticas entre columnas, `INSERT` y `UPDATE` sobre una tabla real con contexto financiero.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `setup.sql` | Crea la tabla `finanzas_personales` e inserta los 6 registros iniciales |
| `consultas.sql` | Las 10 consultas comentadas con resultados esperados |

---

## Estructura de la tabla

```sql
CREATE TABLE finanzas_personales (
    nombre        VARCHAR(20) PRIMARY KEY,  -- quién es
    me_debe       INTEGER,   -- dinero que esa persona me debe a mí
    cuotas_cobrar INTEGER,   -- en cuántas cuotas me lo pagará
    le_debo       INTEGER,   -- dinero que yo le debo a esa persona
    cuotas_pagar  INTEGER    -- en cuántas cuotas yo le pagaré
);
```

### Datos iniciales

| nombre | me_debe | cuotas_cobrar | le_debo | cuotas_pagar |
|---|---|---|---|---|
| tía carmen | 0 | 0 | 5.000 | 1 |
| papá | 0 | 0 | 15.000 | 3 |
| nacho | 10.000 | 2 | 7.000 | 1 |
| almacén esquina | 0 | 0 | 13.000 | 2 |
| vicios varios | 0 | 0 | 35.000 | 35 |
| compañero trabajo | 50.000 | 5 | 0 | 0 |

---

## Las 10 Consultas

### Q1 – ¿A quién le debo más?
```sql
SELECT nombre, le_debo AS "Le debo"
FROM finanzas_personales
WHERE le_debo = (SELECT MAX(le_debo) FROM finanzas_personales);
```
**Resultado:** vicios varios → $35.000

**`MAX()` + subconsulta:**
```
Subconsulta: SELECT MAX(le_debo) → devuelve 35000
Consulta exterior: filtra las filas donde le_debo = 35000
```
Usar una subconsulta en vez de `ORDER BY ... LIMIT 1` tiene la ventaja de que captura **empates**: si dos personas me debieran el mismo máximo, ambas aparecen.

---

### Q2 – ¿Quién me debe más?
```sql
SELECT nombre, me_debe AS "Me debe"
FROM finanzas_personales
WHERE me_debe = (SELECT MAX(me_debe) FROM finanzas_personales);
```
**Resultado:** compañero trabajo → $50.000

---

### Q3 – Total que debo
```sql
SELECT SUM(le_debo) AS "Total que debo"
FROM finanzas_personales;
```
**Cálculo:** 5.000 + 15.000 + 7.000 + 13.000 + 35.000 + 0 = **$75.000**

---

### Q4 – Promedio de deuda
```sql
SELECT AVG(le_debo) AS "Promedio que debo"
FROM finanzas_personales;
```
**Cálculo:** 75.000 ÷ 6 filas = **$12.500**

**Funciones de agregación disponibles:**
| Función | Qué hace |
|---|---|
| `SUM(col)` | Suma todos los valores |
| `AVG(col)` | Promedio (suma / cantidad) |
| `MAX(col)` | Valor más alto |
| `MIN(col)` | Valor más bajo |
| `COUNT(col)` | Cuenta filas no nulas |

---

### Q5 – ¿Cuántos meses para saldar la deuda?
```sql
-- Estándar: total de meses
SELECT SUM(cuotas_pagar) AS meses
FROM finanzas_personales;
-- → 42

-- Experto: años y meses
SELECT
    SUM(cuotas_pagar) / 12  AS años,
    SUM(cuotas_pagar) % 12  AS meses
FROM finanzas_personales;
-- → 3 años, 6 meses
```
**Cálculo:** 1 + 3 + 1 + 2 + 35 + 0 = **42 cuotas totales**

**Operadores aritméticos en SQL:**
| Operador | Significado | Ejemplo |
|---|---|---|
| `/` | División (entera si ambos son INTEGER) | `42 / 12 = 3` |
| `%` | Módulo (resto de la división) | `42 % 12 = 6` |
| `*` | Multiplicación | `cuotas_pagar * 1000` |
| `+` / `-` | Suma / resta | `le_debo - me_debe` |

---

### Q6 – Cobro todo y pago lo que puedo
```sql
-- 6a. Nueva deuda después de cobrar todo
SELECT
    SUM(le_debo) - SUM(me_debe) AS "Nueva deuda reducida"
FROM finanzas_personales;
-- → 75.000 - 60.000 = 15.000

-- 6b. Cuota mensual para pagar lo restante
SELECT
    (SUM(le_debo) - SUM(me_debe)) / SUM(cuotas_pagar) AS "Valor cuota"
FROM finanzas_personales;
-- → 15.000 / 42 = 357
```

**Paso a paso:**
```
Total me deben:  SUM(me_debe)  = 60.000
Total que debo:  SUM(le_debo)  = 75.000
Deuda reducida:  75.000 - 60.000 = 15.000
Cuotas totales:  SUM(cuotas_pagar) = 42
Cuota mensual:   15.000 / 42 ≈ 357
```

---

### Q7 – INSERT: agregar a la pareja
```sql
INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('pareja', 0, 0, 50000, 1);
```

**Sintaxis del INSERT:**
```sql
INSERT INTO nombre_tabla (col1, col2, col3)
VALUES (valor1, valor2, valor3);
```
- Los valores deben ir en el **mismo orden** que las columnas declaradas.
- Los strings van entre comillas simples `'...'`.
- Los números van sin comillas.

---

### Q8 – Cuota del mes tras agregar pareja
```sql
SELECT SUM(le_debo / cuotas_pagar) AS "cuota mes"
FROM finanzas_personales
WHERE cuotas_pagar > 0;
```
**Cálculo:**
```
tía carmen:       5.000 / 1  = 5.000
papá:            15.000 / 3  = 5.000
nacho:            7.000 / 1  = 7.000
almacén esquina: 13.000 / 2  = 6.500
vicios varios:   35.000 / 35 = 1.000
pareja:          50.000 / 1  = 50.000
───────────────────────────────────────
TOTAL MES                    = 74.500
```
**¿Por qué `WHERE cuotas_pagar > 0`?** Para evitar una división por cero con `compañero trabajo` (cuotas_pagar = 0).

---

### Q9 – UPDATE: almacén esquina pasa a 13 cuotas
```sql
UPDATE finanzas_personales
SET cuotas_pagar = 13
WHERE nombre = 'almacén esquina';
```

**Sintaxis del UPDATE:**
```sql
UPDATE nombre_tabla
SET columna = nuevo_valor
WHERE condicion;
```
> **Regla crítica:** el `WHERE` es obligatorio. Sin él, se actualizarían **todas** las filas de la tabla.

---

### Q10 – Cuota del mes tras el UPDATE
```sql
SELECT SUM(le_debo / cuotas_pagar) AS "cuota mes"
FROM finanzas_personales
WHERE cuotas_pagar > 0;
```
**Cálculo:**
```
tía carmen:       5.000 / 1  = 5.000
papá:            15.000 / 3  = 5.000
nacho:            7.000 / 1  = 7.000
almacén esquina: 13.000 / 13 = 1.000   ← bajó de 6.500 a 1.000
vicios varios:   35.000 / 35 = 1.000
pareja:          50.000 / 1  = 50.000
───────────────────────────────────────
TOTAL MES                    = 69.000
```
El cambio de 2 a 13 cuotas en el almacén redujo la cuota mensual en **$5.500**.

---

## Resumen de resultados

| Consulta | Resultado |
|---|---|
| Q1 – A quién le debo más | vicios varios → $35.000 |
| Q2 – Quién me debe más | compañero trabajo → $50.000 |
| Q3 – Total que debo | $75.000 |
| Q4 – Promedio que debo | $12.500 |
| Q5 – Meses para saldar (estándar) | 42 meses |
| Q5 – Meses para saldar (experto) | 3 años, 6 meses |
| Q6a – Nueva deuda reducida | $15.000 |
| Q6b – Cuota sobre deuda reducida | $357 |
| Q8 – Cuota mes (con pareja) | $74.500 |
| Q10 – Cuota mes (con UPDATE) | $69.000 |

---

## Errores frecuentes

| Error | Causa | Solución |
|---|---|---|
| `division by zero` | `cuotas_pagar = 0` en la división | Agregar `WHERE cuotas_pagar > 0` |
| UPDATE modifica todas las filas | Olvidar el `WHERE` | Siempre usar `WHERE` en UPDATE |
| Resultado `INTEGER` truncado | División entera en PostgreSQL | Usar `CAST(col AS NUMERIC)` si se necesitan decimales |
| `duplicate key value` en INSERT | El nombre ya existe (es PK) | Verificar con `SELECT` antes de insertar |
