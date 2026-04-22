-- ============================================================
-- MÓDULO 5 – LECCIÓN 1: Consultas SQL sobre tabla clientes
-- Archivo: consultas.sql
-- Motor: PostgreSQL
-- ============================================================
-- IMPORTANTE: Ejecuta setup.sql primero para crear la tabla
--             e insertar los datos de prueba.
-- ============================================================
-- Conceptos que practicas en este archivo:
--   SELECT *       → seleccionar todas las columnas
--   WHERE          → filtrar filas por condición
--   =  <>  >  <   → operadores de comparación
--   LIKE / ILIKE   → búsqueda por patrón de texto
--   %              → comodín: cualquier cantidad de caracteres
--   AND / OR / NOT → combinar condiciones
--   IN (...)       → comparar contra una lista de valores
--   BETWEEN a AND b → rango numérico inclusivo
--   NOT ILIKE      → negación de patrón (case-insensitive)
-- ============================================================


-- ============================================================
-- R1: Todos los clientes con rut '13133133-3'
-- ============================================================
-- Filtro exacto por clave primaria usando el operador =
-- Se espera 1 fila: Mario, 30 años

SELECT *
FROM clientes
WHERE rut = '13133133-3';


-- ============================================================
-- R2: Todos los clientes mayores de 25 años
-- ============================================================
-- El operador > excluye el valor 25 (no incluye 25)
-- Para incluir 25 se usaría >=
-- Se esperan varias filas (edad > 25)

SELECT *
FROM clientes
WHERE edad > 25
ORDER BY edad;


-- ============================================================
-- R3: Todos los clientes que NO se llamen 'Mario'
-- ============================================================
-- ILIKE en PostgreSQL: búsqueda SIN distinguir mayúsculas/minúsculas
-- NOT ILIKE 'mario' excluye 'mario', 'Mario', 'MARIO', etc.
-- Alternativa portátil (sensible a mayúsculas): WHERE nombre <> 'Mario'

SELECT *
FROM clientes
WHERE nombre NOT ILIKE 'mario'
ORDER BY nombre;


-- ============================================================
-- R4: Todos los clientes con rut empezado en '13'
-- ============================================================
-- LIKE 'patrón': en PostgreSQL es sensible a mayúsculas/minúsculas
-- El comodín % representa CERO o más caracteres cualquiera
-- '13%' → empieza con '13', luego cualquier cosa

SELECT *
FROM clientes
WHERE rut LIKE '13%'
ORDER BY rut;


-- ============================================================
-- R5: Todos los clientes con nombre finalizado en 'a'
-- ============================================================
-- '%a'  → termina con la letra 'a' (minúscula exacta con LIKE)
-- ILIKE '%a' ignora mayúsculas: encuentra 'Ana', 'Rosa', 'Laura', etc.

SELECT *
FROM clientes
WHERE nombre ILIKE '%a'
ORDER BY nombre;


-- ============================================================
-- R6: Clientes con nombre empezado en 'P' Y edad mayor a 34
-- ============================================================
-- AND requiere que AMBAS condiciones sean verdaderas
-- ILIKE 'P%' encuentra 'Pato', 'Patricia', 'Pedro', 'Paula', 'Pepa'
-- La segunda condición (edad > 34) filtra aún más el resultado

SELECT *
FROM clientes
WHERE nombre ILIKE 'P%'
  AND edad > 34
ORDER BY nombre;


-- ============================================================
-- R7: rut empieza en '1', nombre NO empieza en 'M', edad < 40
-- ============================================================
-- Tres condiciones unidas con AND: todas deben cumplirse
-- NOT ILIKE 'M%' excluye nombres que comienzan con M o m
-- LIKE '1%' usa el comodín para el inicio del rut

SELECT *
FROM clientes
WHERE rut    LIKE '1%'
  AND nombre NOT ILIKE 'M%'
  AND edad < 40
ORDER BY nombre;


-- ============================================================
-- R8: rut empieza en '13' O termina en '1',
--     nombre IN lista específica,
--     edad BETWEEN 20 AND 80
-- ============================================================
-- OR: al menos UNA de las dos condiciones del rut debe cumplirse
-- Usamos paréntesis () para agrupar el OR y que AND lo trate como bloque
-- IN ('a','b','c') equivale a: nombre='a' OR nombre='b' OR nombre='c'
-- BETWEEN 20 AND 80 incluye los valores extremos (>= 20 y <= 80)

SELECT *
FROM clientes
WHERE (rut LIKE '13%' OR rut LIKE '%1')
  AND nombre IN ('Diego', 'Mario', 'Pato', 'Pepa')
  AND edad BETWEEN 20 AND 80
ORDER BY nombre;


-- ============================================================
-- BONUS: Ver toda la tabla ordenada de distintas formas
-- ============================================================

-- Ordenada por nombre ascendente (A → Z)
SELECT * FROM clientes ORDER BY nombre ASC;

-- Ordenada por edad descendente (mayor → menor)
SELECT * FROM clientes ORDER BY edad DESC;

-- Contar cuántos clientes hay por especie (GROUP BY)
SELECT nombre, COUNT(*) AS cantidad
FROM clientes
GROUP BY nombre
ORDER BY cantidad DESC;
