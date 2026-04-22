-- ============================================================
-- MÓDULO 5 – LECCIÓN 1: Consultas SQL sobre tabla clientes
-- Archivo: setup.sql
-- Propósito: crear la tabla e insertar datos de prueba
-- Motor: PostgreSQL
-- ============================================================
-- Instrucciones:
--   1. Abre pgAdmin o psql.
--   2. Selecciona (o crea) la base de datos donde quieras trabajar.
--   3. Ejecuta este archivo PRIMERO, antes de correr consultas.sql
-- ============================================================


-- ------------------------------------------------------------
-- PASO 1: Eliminar la tabla si ya existe (para poder reejecutar)
-- ------------------------------------------------------------
-- DROP TABLE IF EXISTS evita un error si la tabla aún no existía.

DROP TABLE IF EXISTS clientes;


-- ------------------------------------------------------------
-- PASO 2: Crear la tabla clientes
-- ------------------------------------------------------------
-- rut    → clave primaria, texto, formato chileno  ej: 12345678-9
-- nombre → texto, máximo 20 caracteres
-- edad   → número entero

CREATE TABLE clientes (
    rut     VARCHAR(12)  PRIMARY KEY,
    nombre  VARCHAR(20)  NOT NULL,
    edad    INTEGER      NOT NULL
);


-- ------------------------------------------------------------
-- PASO 3: Insertar datos de prueba
-- ------------------------------------------------------------
-- Los datos están diseñados para que cada una de las 8 consultas
-- devuelva al menos un resultado visible.

INSERT INTO clientes (rut, nombre, edad) VALUES
    ('13133133-3', 'Mario',    30),
    ('13456789-0', 'Pato',     45),
    ('13987654-1', 'Pedro',    22),
    ('14111222-3', 'Patricia', 38),
    ('14333444-5', 'Diego',    27),
    ('15555666-7', 'Ana',      19),
    ('15777888-9', 'Paula',    50),
    ('16999000-1', 'Pepa',     65),
    ('21111222-3', 'Mario',    55),
    ('21333444-5', 'Carlos',   42),
    ('22555666-7', 'Rosa',     33),
    ('22777888-9', 'Laura',    29);


-- ------------------------------------------------------------
-- Verificar que los datos se insertaron correctamente
-- ------------------------------------------------------------

SELECT * FROM clientes ORDER BY rut;
