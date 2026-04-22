-- ============================================================
-- MÓDULO 5 – LECCIÓN 2.1: Finanzas Personales
-- Archivo: setup.sql  →  ejecutar PRIMERO
-- Motor: PostgreSQL
-- ============================================================
-- Tabla: finanzas_personales
-- Columnas:
--   nombre        → identificador (PK), quien es la persona/entidad
--   me_debe       → cuánto dinero me debe esa persona
--   cuotas_cobrar → en cuántas cuotas me lo pagará
--   le_debo       → cuánto dinero le debo yo a esa persona
--   cuotas_pagar  → en cuántas cuotas se lo pagaré yo
-- ============================================================

DROP TABLE IF EXISTS finanzas_personales;

CREATE TABLE finanzas_personales (
    nombre        CHARACTER VARYING(20) NOT NULL,
    me_debe       INTEGER,
    cuotas_cobrar INTEGER,
    le_debo       INTEGER,
    cuotas_pagar  INTEGER,
    CONSTRAINT finanzas_personales_pkey PRIMARY KEY (nombre)
);

-- Datos iniciales (estado de partida)
INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('tía carmen',       0,     0, 5000,  1);

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('papá',             0,     0, 15000, 3);

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('nacho',            10000, 2, 7000,  1);

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('almacén esquina',  0,     0, 13000, 2);

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('vicios varios',    0,     0, 35000, 35);

INSERT INTO finanzas_personales (nombre, me_debe, cuotas_cobrar, le_debo, cuotas_pagar)
VALUES ('compañero trabajo', 50000, 5, 0,   0);

-- Verificar estado inicial
SELECT * FROM finanzas_personales;
