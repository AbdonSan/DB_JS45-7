-- ============================================================
-- MÓDULO 5 – LECCIÓN 2.1: Consultas Finanzas Personales
-- Archivo: consultas.sql
-- IMPORTANTE: Ejecutar setup.sql primero
-- ============================================================
-- Conceptos nuevos en esta lección:
--   SUM()        → suma todos los valores de una columna
--   AVG()        → promedio de los valores de una columna
--   MAX()        → valor máximo de una columna
--   MIN()        → valor mínimo de una columna
--   Subconsulta  → SELECT dentro de otro SELECT
--   División /   → división entera o decimal entre columnas
--   Módulo %     → resto de la división (para años y meses)
--   INSERT INTO  → agregar un nuevo registro
--   UPDATE SET   → modificar un registro existente
-- ============================================================


-- ============================================================
-- ESTADO INICIAL DE LA TABLA (referencia)
-- ============================================================
-- nombre           | me_debe | cuotas_cobrar | le_debo | cuotas_pagar
-- -----------------+---------+---------------+---------+-------------
-- tía carmen       |       0 |             0 |    5000 |            1
-- papá             |       0 |             0 |   15000 |            3
-- nacho            |   10000 |             2 |    7000 |            1
-- almacén esquina  |       0 |             0 |   13000 |            2
-- vicios varios    |       0 |             0 |   35000 |           35
-- compañero trabajo|   50000 |             5 |       0 |            0


-- ============================================================
-- Q1: ¿A quién(es) le debo más dinero y cuánto?
-- ============================================================
-- MAX() encuentra el valor más alto de la columna le_debo.
-- La subconsulta devuelve ese máximo y el WHERE filtra las filas
-- que tienen exactamente ese valor (puede haber empate).
--
-- Resultado esperado: vicios varios → $35.000

SELECT nombre, le_debo AS "Le debo"
FROM finanzas_personales
WHERE le_debo = (
    SELECT MAX(le_debo)
    FROM finanzas_personales
);


-- ============================================================
-- Q2: ¿Quién(es) me debe más dinero y cuánto?
-- ============================================================
-- Misma técnica, pero sobre la columna me_debe.
-- Solo tienen valor > 0: nacho (10000) y compañero trabajo (50000).
--
-- Resultado esperado: compañero trabajo → $50.000

SELECT nombre, me_debe AS "Me debe"
FROM finanzas_personales
WHERE me_debe = (
    SELECT MAX(me_debe)
    FROM finanzas_personales
);


-- ============================================================
-- Q3: ¿Cuánto dinero debo en total?
-- ============================================================
-- SUM() suma todos los valores de la columna le_debo.
-- 5000 + 15000 + 7000 + 13000 + 35000 + 0 = 75000
--
-- Resultado esperado: $75.000

SELECT SUM(le_debo) AS "Total que debo"
FROM finanzas_personales;


-- ============================================================
-- Q4: ¿Cuánto debo en promedio?
-- ============================================================
-- AVG() calcula el promedio: total / cantidad de filas.
-- 75000 / 6 filas = 12500
--
-- Resultado esperado: $12.500

SELECT AVG(le_debo) AS "Promedio que debo"
FROM finanzas_personales;


-- ============================================================
-- Q5: ¿Cuántos meses demoraría en saldar la deuda?
--     (Pagando máximo 1 cuota por mes a cada acreedor)
-- ============================================================
-- Cada acreedor tiene sus cuotas acordadas en cuotas_pagar.
-- El mes que más cuotas se pagan a la vez es:
--   tía carmen: 1 cuota | papá: 3 cuotas | nacho: 1 cuota
--   almacén: 2 cuotas | vicios: 35 cuotas | trabajo: 0 cuotas
-- El total de meses es la suma de todas las cuotas individuales.
-- 1 + 3 + 1 + 2 + 35 + 0 = 42 meses

-- RESPUESTA ESTÁNDAR: total de meses
SELECT SUM(cuotas_pagar) AS meses
FROM finanzas_personales;
-- Resultado: 42

-- RESPUESTA EXPERTA: desglose en años y meses restantes
-- / 12 → división entera (años completos)
-- % 12 → módulo = resto de dividir por 12 (meses sobrantes)
SELECT
    SUM(cuotas_pagar) / 12  AS años,
    SUM(cuotas_pagar) % 12  AS meses
FROM finanzas_personales;
-- Resultado: 3 años, 6 meses


-- ============================================================
-- Q6: Si cobro todo lo que me deben y lo uso para pagar mi deuda
-- ============================================================
-- Total que me deben (me_debe): 0 + 0 + 10000 + 0 + 0 + 50000 = 60000
-- Total que debo   (le_debo):  75000
-- Nueva deuda = 75000 - 60000 = 15000

-- 6a. ¿A cuánto asciende la nueva deuda reducida?
SELECT
    SUM(le_debo)                    AS "Deuda original",
    SUM(me_debe)                    AS "Lo que cobro",
    SUM(le_debo) - SUM(me_debe)     AS "Nueva deuda reducida"
FROM finanzas_personales;
-- Resultado: 15000

-- 6b. ¿Cuánto pagar mensualmente para cubrir la deuda
--     restante en las cuotas ya acordadas?
-- Cuotas totales acordadas = SUM(cuotas_pagar) = 42
-- Pago por cuota = 15000 / 42 ≈ 357
SELECT
    (SUM(le_debo) - SUM(me_debe)) / SUM(cuotas_pagar) AS "Valor cuota"
FROM finanzas_personales;
-- Resultado: 357


-- ============================================================
-- Q7: Insertar nuevo registro — "pareja" (¡50 lucas olvidadas!)
-- ============================================================
-- Le debo $50.000 a la pareja, pactado en 1 cuota.
-- La pareja no me debe nada (me_debe = 0, cuotas_cobrar = 0).

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('pareja', 0, 0, 50000, 1);

-- Verificar que se insertó
SELECT * FROM finanzas_personales ORDER BY nombre;


-- ============================================================
-- Q8: ¿Cuánto hay que pagar ESTE mes? (después de insertar pareja)
-- ============================================================
-- La cuota mensual de cada acreedor = le_debo / cuotas_pagar
--   tía carmen:        5000  / 1  = 5000
--   papá:             15000  / 3  = 5000
--   nacho:             7000  / 1  = 7000
--   almacén esquina:  13000  / 2  = 6500
--   vicios varios:    35000  / 35 = 1000
--   compañero trabajo:    0  / 0  → excluido (WHERE cuotas_pagar > 0)
--   pareja:           50000  / 1  = 50000
--
-- Total del mes: 5000 + 5000 + 7000 + 6500 + 1000 + 50000 = 74500

SELECT SUM(le_debo / cuotas_pagar) AS "cuota mes"
FROM finanzas_personales
WHERE cuotas_pagar > 0;
-- Resultado: 74500


-- ============================================================
-- Q9: UPDATE — almacén esquina pasa de 2 a 13 cuotas
-- ============================================================
-- La señora del almacén acepta dividir la deuda en 13 cuotas.
-- Se actualiza SOLO la fila de 'almacén esquina'.
-- El WHERE es CRÍTICO: sin él, se actualizarían TODAS las filas.

UPDATE finanzas_personales
SET cuotas_pagar = 13
WHERE nombre = 'almacén esquina';

-- Verificar el cambio
SELECT * FROM finanzas_personales ORDER BY nombre;


-- ============================================================
-- Q10: ¿Cuánto hay que pagar este mes? (después del UPDATE)
-- ============================================================
-- Ahora almacén esquina: 13000 / 13 = 1000 (antes era 6500)
-- La cuota baja $5.500 respecto al mes anterior.
--
--   tía carmen:        5000  / 1  = 5000
--   papá:             15000  / 3  = 5000
--   nacho:             7000  / 1  = 7000
--   almacén esquina:  13000  / 13 = 1000  ← cambió
--   vicios varios:    35000  / 35 = 1000
--   compañero trabajo:    0  / 0  → excluido
--   pareja:           50000  / 1  = 50000
--
-- Total del mes: 5000 + 5000 + 7000 + 1000 + 1000 + 50000 = 69000

SELECT SUM(le_debo / cuotas_pagar) AS "cuota mes"
FROM finanzas_personales
WHERE cuotas_pagar > 0;
-- Resultado: 69000


-- ============================================================
-- BONUS: Resumen completo del estado financiero actual
-- ============================================================

SELECT
    SUM(me_debe)                        AS "Total que me deben",
    SUM(le_debo)                        AS "Total que debo",
    SUM(le_debo) - SUM(me_debe)         AS "Deuda neta",
    SUM(cuotas_pagar)                   AS "Total cuotas pendientes",
    SUM(cuotas_pagar) / 12              AS "Años para saldar",
    SUM(cuotas_pagar) % 12              AS "Meses restantes"
FROM finanzas_personales;
