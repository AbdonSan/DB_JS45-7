-- ============================================================
-- MÓDULO 5 – LECCIÓN 3: Consultas con JOIN y Agregación
-- Archivo: consultas.sql  →  ejecutar DESPUÉS de setup.sql
-- ============================================================
-- Conceptos nuevos (DQL):
--   JOIN ... ON    → combinar filas de dos tablas por una condición
--   GROUP BY       → agrupar filas con el mismo valor en una columna
--   HAVING         → filtrar grupos (como WHERE pero para grupos)
--   COUNT()        → contar filas de un grupo
--   SUM()          → sumar valores de un grupo
--   AVG()          → promedio de valores de un grupo
--   MIN()          → valor mínimo dentro de un grupo
--   Subconsulta IN → filtrar con resultados de otro SELECT
-- ============================================================
-- Estado de la tabla DESPUÉS del UPDATE y DELETE:
--
-- Ana   (1, 78): cta 101=50000, cta 102=-1200.50, cta 103=100
-- Luis  (2, 25): cta 201=850.75, cta 202=-500
-- Maria (3, 40): cta 301=15000, cta 302=200, cta 303=-4999.99, cta 304=75000
-- Carlos(4, 80): cta 401=1000, cta 402=2500 (actualizada), cta 403=3000
-- Elena (5, 32): cta 501=50, cta 502=120  (503 fue borrada)
-- ============================================================


-- ============================================================
-- Q3: Saldo de cada cuenta del cliente con MÁS años de edad
-- ============================================================
-- El cliente de mayor edad es Carlos Ruiz (80 años).
-- Técnica: subconsulta que encuentra el MAX(edad) y luego
-- filtra las cuentas de ese cliente con JOIN.
--
-- Resultado esperado:
--   id_cuenta | nombre      | saldo
--   401       | Carlos Ruiz | 1000.00
--   402       | Carlos Ruiz | 2500.00   ← actualizada por UPDATE
--   403       | Carlos Ruiz | 3000.00

SELECT
    cu.id_cuenta,
    cl.nombre,
    cu.saldo
FROM Cuentas cu
JOIN Clientes cl ON cu.id_cliente = cl.id_cliente
WHERE cl.edad = (
    SELECT MAX(edad) FROM Clientes   -- subconsulta: encuentra la edad máxima
)
ORDER BY cu.id_cuenta;


-- ============================================================
-- Q4: Promedio de edad de los clientes con saldo negativo
-- ============================================================
-- Clientes que tienen AL MENOS UNA cuenta con saldo < 0:
--   Ana (78) → cuenta 102: -1200.50
--   Luis(25) → cuenta 202: -500.00
--   Maria(40)→ cuenta 303: -4999.99
-- (Carlos y Elena no tienen saldos negativos)
--
-- Se usa subconsulta con IN para obtener los id_cliente que
-- tienen alguna cuenta negativa, evitando duplicados.
--
-- Cálculo: (78 + 25 + 40) / 3 = 47.67

SELECT ROUND(AVG(cl.edad), 2) AS "Promedio edad (clientes con saldo negativo)"
FROM Clientes cl
WHERE cl.id_cliente IN (
    SELECT DISTINCT id_cliente      -- DISTINCT evita contar al cliente 2 veces
    FROM Cuentas
    WHERE saldo < 0
);


-- ============================================================
-- Q5: Nombre y cantidad de cuentas de quienes tienen más de una
-- ============================================================
-- GROUP BY agrupa todas las cuentas por cliente.
-- COUNT() cuenta cuántas cuentas hay en cada grupo.
-- HAVING filtra los grupos donde el conteo > 1.
--
-- Todos los clientes tienen más de 1 cuenta (tras el DELETE de 503,
-- Elena conserva 2 cuentas, que sigue cumpliendo la condición).
--
-- Resultado esperado:
--   nombre       | cantidad_cuentas
--   Maria Soto   | 4
--   Ana García   | 3
--   Carlos Ruiz  | 3
--   Luis Pérez   | 2
--   Elena Torres | 2

SELECT
    cl.nombre,
    COUNT(cu.id_cuenta) AS cantidad_cuentas
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY cantidad_cuentas DESC, cl.nombre;


-- ============================================================
-- Q6: Saldo combinado (suma) de cada cliente con más de una cuenta
-- ============================================================
-- Igual que Q5, pero en vez de COUNT se usa SUM del saldo.
-- HAVING COUNT > 1 mantiene el mismo filtro (más de una cuenta).
--
-- Cálculo por cliente:
--   Ana:    50000 + (-1200.50) + 100       =  48899.50
--   Luis:   850.75 + (-500)                =    350.75
--   Maria:  15000 + 200 + (-4999.99) + 75000 = 85200.01
--   Carlos: 1000 + 2500 + 3000             =   6500.00
--   Elena:  50 + 120                        =    170.00

SELECT
    cl.nombre,
    SUM(cu.saldo) AS saldo_combinado
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY saldo_combinado DESC;


-- ============================================================
-- Q7: Clientes con al menos una cuenta negativa + su saldo total
-- ============================================================
-- Dos condiciones en una misma consulta:
--   1. El cliente tiene AL MENOS UNA cuenta con saldo < 0
--      → se detecta con HAVING MIN(saldo) < 0
--        (si el mínimo de sus saldos es negativo, hay al menos uno)
--   2. Se muestra el SUM de TODOS sus saldos (incluyendo positivos)
--
-- Clientes que cumplen (tienen cuenta negativa):
--   Ana:   saldo combinado = 48899.50
--   Maria: saldo combinado = 85200.01
--   Luis:  saldo combinado =   350.75
--
-- Carlos y Elena quedan excluidos (no tienen saldo negativo).

SELECT
    cl.nombre,
    SUM(cu.saldo)   AS saldo_combinado,
    MIN(cu.saldo)   AS saldo_minimo      -- columna extra para verificar
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING MIN(cu.saldo) < 0                -- al menos un saldo negativo
ORDER BY saldo_combinado DESC;


-- ============================================================
-- BONUS: demostración de ON DELETE CASCADE
-- ============================================================
-- Si se borra el cliente 1 (Ana), todas sus cuentas
-- (101, 102, 103) se borran automáticamente por CASCADE.
-- DESCOMENTA para probar (se puede revertir volviendo a ejecutar setup.sql):

-- DELETE FROM Clientes WHERE id_cliente = 1;
-- SELECT * FROM Cuentas WHERE id_cliente = 1;  -- devuelve 0 filas
