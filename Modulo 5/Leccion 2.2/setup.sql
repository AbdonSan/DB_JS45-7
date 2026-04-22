-- ============================================================
-- MÓDULO 5 – LECCIÓN 2.2: Catálogo Netflix
-- Archivo: setup.sql  →  ejecutar PRIMERO
-- Motor: PostgreSQL
-- ============================================================
-- Tabla: serie_netflix
-- Columnas:
--   nombre       → nombre de la serie (PK)
--   temporadas   → número de temporadas
--   genero       → género de la serie
--   anio_estreno → año de lanzamiento
-- ============================================================

DROP TABLE IF EXISTS serie_netflix;

CREATE TABLE serie_netflix (
    nombre       CHARACTER VARYING NOT NULL,
    temporadas   INTEGER,
    genero       CHARACTER VARYING(50),
    anio_estreno INTEGER,
    CONSTRAINT serie_netflix_pkey PRIMARY KEY (nombre)
);

-- Registro inicial del enunciado
INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Black Mirror', 5, 'Ciencia ficción', 2011);

-- Verificar estado inicial
SELECT * FROM serie_netflix;
