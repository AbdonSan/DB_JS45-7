-- ============================================================
-- MÓDULO 5 – LECCIÓN 2.2: Consultas sobre serie_netflix
-- Archivo: consultas.sql  →  ejecutar DESPUÉS de setup.sql
-- Motor: PostgreSQL
-- ============================================================
-- Conceptos nuevos en esta lección:
--   MIN() / MAX()    → valor mínimo y máximo de una columna
--   AVG()            → promedio de una columna
--   ROUND()          → redondear un número decimal
--   IN / NOT IN      → comparar contra una lista de valores
--   DELETE FROM      → eliminar filas que cumplen una condición
--   ORDER BY DESC    → ordenar de mayor a menor
--   Columna calculada → usar columnas en operaciones (col1 + col2)
-- ============================================================


-- ============================================================
-- ESTADO INICIAL (solo Black Mirror)
-- nombre       | temporadas | genero          | anio_estreno
-- Black Mirror | 5          | Ciencia ficción | 2011
-- ============================================================


-- ============================================================
-- Q1: Insertar 9 series adicionales
-- ============================================================
-- Las series se eligen con variedad de años, temporadas y géneros
-- para que las consultas siguientes (Q2 a Q14) muestren resultados
-- representativos y diferenciados.

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Breaking Bad',    5,  'Drama/Crimen',          2008);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Stranger Things', 4,  'Terror/Ciencia ficción', 2016);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Narcos',          3,  'Crimen/Drama',           2015);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('The Crown',       6,  'Drama histórico',        2016);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Dark',            3,  'Ciencia ficción/Misterio', 2017);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Money Heist',     5,  'Acción/Crimen',          2017);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Squid Game',      2,  'Terror/Drama',           2021);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Friends',         10, 'Comedia',                1994);

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Ozark',           4,  'Drama/Crimen',           2017);

-- Verificar las 10 series
SELECT * FROM serie_netflix ORDER BY anio_estreno;


-- ============================================================
-- Q2: Series con MÁS de 3 temporadas, ordenadas por año DESC
-- ============================================================
-- "Más de 3" → temporadas > 3 (no incluye exactamente 3)
-- ORDER BY anio_estreno DESC → de más reciente a más antigua
--
-- Resultado esperado (de más nuevo a más antiguo):
--   Squid Game NO (2 temp) | Ozark(2017,4) | Money Heist(2017,5)
--   The Crown(2016,6) | Stranger Things(2016,4) | Black Mirror(2011,5)
--   Breaking Bad(2008,5) | Friends(1994,10)

SELECT nombre, temporadas, anio_estreno
FROM serie_netflix
WHERE temporadas > 3
ORDER BY anio_estreno DESC;


-- ============================================================
-- Q3: Año de la serie más antigua
-- ============================================================
-- MIN() devuelve el valor más bajo de la columna anio_estreno.
-- Resultado esperado: 1994 (Friends)

SELECT MIN(anio_estreno) AS "Año más antiguo"
FROM serie_netflix;


-- ============================================================
-- Q4: Año de la serie más nueva
-- ============================================================
-- MAX() devuelve el valor más alto de anio_estreno.
-- Resultado esperado: 2021 (Squid Game)

SELECT MAX(anio_estreno) AS "Año más nuevo"
FROM serie_netflix;


-- ============================================================
-- Q5: Promedio del año de estreno
-- ============================================================
-- AVG() calcula la suma de los años dividido la cantidad de filas.
-- ROUND(..., 0) redondea al entero más cercano.
-- Sin paréntesis, PostgreSQL devuelve un número con decimales.
--
-- Cálculo: (2011+2008+2016+2015+2016+2017+2017+2021+1994+2017) / 10
--        = 20132 / 10 = 2013.2 → redondeado: 2013

SELECT ROUND(AVG(anio_estreno), 0) AS "Promedio año estreno"
FROM serie_netflix;


-- ============================================================
-- Q6: Promedio de temporadas
-- ============================================================
-- Cálculo: (5+5+4+3+6+3+5+2+10+4) / 10 = 47 / 10 = 4.7

SELECT ROUND(AVG(temporadas), 1) AS "Promedio temporadas"
FROM serie_netflix;


-- ============================================================
-- Q7: Series que tengan 1, 2, 4, 5 o 7 temporadas
-- ============================================================
-- IN (lista) es equivalente a:
--   temporadas = 1 OR temporadas = 2 OR temporadas = 4 OR ...
-- Es más compacto y legible que encadenar OR.
--
-- Resultado esperado:
--   Black Mirror(5), Breaking Bad(5), Stranger Things(4),
--   Money Heist(5), Squid Game(2), Ozark(4)

SELECT nombre, temporadas
FROM serie_netflix
WHERE temporadas IN (1, 2, 4, 5, 7)
ORDER BY temporadas;


-- ============================================================
-- Q8: Series que NO tengan 1, 2, 4, 5 o 7 temporadas
-- ============================================================
-- NOT IN excluye los valores de la lista.
-- Resultado esperado:
--   Narcos(3), The Crown(6), Dark(3), Friends(10)

SELECT nombre, temporadas
FROM serie_netflix
WHERE temporadas NOT IN (1, 2, 4, 5, 7)
ORDER BY temporadas;


-- ============================================================
-- Q9: Borrar todas las series con año de estreno SUPERIOR a 2010
-- ============================================================
-- DELETE FROM elimina las filas que cumplen el WHERE.
-- "Superior a 2010" → anio_estreno > 2010 (no incluye 2010).
-- REGLA: el WHERE es obligatorio; sin él se borraría toda la tabla.
--
-- Series eliminadas (anio_estreno > 2010):
--   Black Mirror(2011), Stranger Things(2016), Narcos(2015),
--   The Crown(2016), Dark(2017), Money Heist(2017),
--   Squid Game(2021), Ozark(2017)
--
-- Series que PERMANECEN (anio_estreno <= 2010):
--   Breaking Bad(2008), Friends(1994)

DELETE FROM serie_netflix
WHERE anio_estreno > 2010;

-- Verificar lo que quedó
SELECT * FROM serie_netflix;


-- ============================================================
-- Q10: Reinsertar los datos recién borrados
-- ============================================================
-- Volvemos a insertar las 8 series eliminadas en Q9.

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno) VALUES
    ('Black Mirror',    5,  'Ciencia ficción',          2011),
    ('Stranger Things', 4,  'Terror/Ciencia ficción',   2016),
    ('Narcos',          3,  'Crimen/Drama',             2015),
    ('The Crown',       6,  'Drama histórico',          2016),
    ('Dark',            3,  'Ciencia ficción/Misterio', 2017),
    ('Money Heist',     5,  'Acción/Crimen',            2017),
    ('Squid Game',      2,  'Terror/Drama',             2021),
    ('Ozark',           4,  'Drama/Crimen',             2017);

-- Verificar que volvieron las 10 series
SELECT * FROM serie_netflix ORDER BY anio_estreno;


-- ============================================================
-- Q11: Agregar Doctor House (si ya existe, agregar otra)
-- ============================================================
-- 'Doctor House' no está en nuestra tabla → INSERT directo.
-- Si ya existiera (mismo nombre = PK repetido), daría error.
-- En ese caso se usaría un nombre alternativo como 'House MD'.

INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Doctor House', 8, 'Drama médico', 2004);

-- Verificar la inserción (ahora hay 11 series)
SELECT * FROM serie_netflix ORDER BY anio_estreno;


-- ============================================================
-- Q12: Series estrenadas ENTRE 2005 y 2020 (incluidos)
-- ============================================================
-- BETWEEN 2005 AND 2020 es equivalente a:
--   anio_estreno >= 2005 AND anio_estreno <= 2020
-- Ambos extremos son INCLUSIVOS.
--
-- Excluidas: Friends(1994), Doctor House(2004), Squid Game(2021)

SELECT nombre, anio_estreno
FROM serie_netflix
WHERE anio_estreno BETWEEN 2005 AND 2020
ORDER BY anio_estreno;


-- ============================================================
-- Q13: Series con nombre empezado en 'B' o terminado en 'e'
-- ============================================================
-- ILIKE es insensible a mayúsculas/minúsculas en PostgreSQL.
-- 'B%'  → empieza con B (mayúscula o minúscula)
-- '%e'  → termina con e (mayúscula o minúscula)
-- OR    → basta que UNA de las dos condiciones sea verdadera.
--
-- Resultado esperado:
--   Black Mirror   → empieza en B ✓
--   Breaking Bad   → empieza en B ✓
--   Squid Game     → termina en e ✓

SELECT nombre
FROM serie_netflix
WHERE nombre ILIKE 'B%'
   OR nombre ILIKE '%e'
ORDER BY nombre;


-- ============================================================
-- Q14: Series donde (año de estreno + temporadas) excede 2010
-- ============================================================
-- Se puede operar directamente con columnas dentro del WHERE.
-- anio_estreno + temporadas > 2010
--
-- Verificación serie por serie:
--   Doctor House:    2004 + 8  = 2012 > 2010 ✓
--   Friends:         1994 + 10 = 2004 > 2010 ✗  ← única excluida
--   Breaking Bad:    2008 + 5  = 2013 > 2010 ✓
--   Black Mirror:    2011 + 5  = 2016 > 2010 ✓
--   Narcos:          2015 + 3  = 2018 > 2010 ✓
--   Stranger Things: 2016 + 4  = 2020 > 2010 ✓
--   The Crown:       2016 + 6  = 2022 > 2010 ✓
--   Dark:            2017 + 3  = 2020 > 2010 ✓
--   Money Heist:     2017 + 5  = 2022 > 2010 ✓
--   Ozark:           2017 + 4  = 2021 > 2010 ✓
--   Squid Game:      2021 + 2  = 2023 > 2010 ✓
--
-- Solo Friends queda excluida (1994 + 10 = 2004 ≤ 2010)

SELECT nombre, anio_estreno, temporadas,
       (anio_estreno + temporadas) AS "Suma año+temporadas"
FROM serie_netflix
WHERE (anio_estreno + temporadas) > 2010
ORDER BY (anio_estreno + temporadas);
