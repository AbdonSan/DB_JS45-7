-- ============================================================
-- MÓDULO 5 – LECCIÓN 3: SQL Llaves, DDL/DML y Agregación
-- Archivo: setup.sql  →  ejecutar PRIMERO
-- Motor: PostgreSQL
-- ============================================================
-- Nuevos conceptos (DDL):
--   PRIMARY KEY   → identifica de forma única cada fila
--   FOREIGN KEY   → vincula una columna a la PK de otra tabla
--   CHECK         → restringe los valores aceptados en una columna
--   ON DELETE CASCADE → si se borra el padre, se borran los hijos
--   ON UPDATE CASCADE → si cambia la PK del padre, se actualiza en los hijos
--   CREATE SEQUENCE   → generador automático de números (auto-incremento)
-- ============================================================


-- ------------------------------------------------------------
-- PASO 0: Limpiar objetos anteriores si existen
-- ------------------------------------------------------------
DROP TABLE IF EXISTS Cuentas  CASCADE;
DROP TABLE IF EXISTS Clientes CASCADE;

DROP SEQUENCE IF EXISTS seq_cliente_id;
DROP SEQUENCE IF EXISTS seq_cuenta_id;


-- ------------------------------------------------------------
-- PASO 1: Crear SECUENCIAS para IDs auto-incrementales
-- ------------------------------------------------------------
-- Una SEQUENCE genera un número único cada vez que se llama.
-- nextval('seq_cliente_id') → devuelve 1, luego 2, luego 3...
-- En la práctica evita tener que escribir el ID manualmente.

CREATE SEQUENCE seq_cliente_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_cuenta_id  START WITH 1 INCREMENT BY 1;


-- ------------------------------------------------------------
-- PASO 2: Crear tabla Clientes (tabla PADRE)
-- ------------------------------------------------------------
-- PRIMARY KEY  → id_cliente es único y no puede ser NULL
-- CHECK        → solo se aceptan edades entre 18 y 85 inclusive
-- NOT NULL     → nombre y edad son obligatorios

CREATE TABLE Clientes (
    id_cliente  INT           PRIMARY KEY,
    nombre      VARCHAR(100)  NOT NULL,
    edad        INT           CHECK (edad BETWEEN 18 AND 85) NOT NULL
);


-- ------------------------------------------------------------
-- PASO 3: Crear tabla Cuentas (tabla HIJA)
-- ------------------------------------------------------------
-- FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
--   → cada cuenta DEBE pertenecer a un cliente que ya exista
--
-- ON DELETE CASCADE
--   → si se borra un cliente, TODAS sus cuentas se borran también
--     (integridad referencial automática)
--
-- ON UPDATE CASCADE
--   → si cambia el id_cliente en Clientes, se actualiza en Cuentas
--
-- CHECK (saldo BETWEEN -5000.00 AND 100000.00)
--   → el saldo solo puede estar en ese rango

CREATE TABLE Cuentas (
    id_cuenta   INT             PRIMARY KEY,
    id_cliente  INT             NOT NULL,
    saldo       NUMERIC(10, 2)  CHECK (saldo BETWEEN -5000.00 AND 100000.00) NOT NULL,

    CONSTRAINT fk_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ------------------------------------------------------------
-- PASO 4: Insertar 5 Clientes (edades entre 18 y 85)
-- ------------------------------------------------------------

INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (1, 'Ana García',    78);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (2, 'Luis Pérez',    25);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (3, 'Maria Soto',    40);
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (4, 'Carlos Ruiz',   80);  -- el de mayor edad
INSERT INTO Clientes (id_cliente, nombre, edad) VALUES (5, 'Elena Torres',  32);


-- ------------------------------------------------------------
-- PASO 5: Insertar 15 Cuentas (saldos entre -5000 y 100000)
-- ------------------------------------------------------------
-- Distribución: Ana(3), Luis(2), Maria(4), Carlos(3), Elena(3)

-- Cliente 1 – Ana García (3 cuentas)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (101, 1,  50000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (102, 1,  -1200.50);  -- negativo
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (103, 1,    100.00);

-- Cliente 2 – Luis Pérez (2 cuentas)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (201, 2,    850.75);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (202, 2,   -500.00);  -- negativo

-- Cliente 3 – Maria Soto (4 cuentas)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (301, 3,  15000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (302, 3,    200.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (303, 3,  -4999.99);  -- negativo
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (304, 3,  75000.00);

-- Cliente 4 – Carlos Ruiz (3 cuentas)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (401, 4,   1000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (402, 4,   2000.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (403, 4,   3000.00);

-- Cliente 5 – Elena Torres (3 cuentas)
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (501, 5,     50.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (502, 5,    120.00);
INSERT INTO Cuentas (id_cuenta, id_cliente, saldo) VALUES (503, 5,    900.00);

-- Verificar inserciones
SELECT * FROM Clientes ORDER BY id_cliente;
SELECT * FROM Cuentas  ORDER BY id_cuenta;


-- ------------------------------------------------------------
-- PASO 6: DML – UPDATE y DELETE
-- ------------------------------------------------------------

-- UPDATE: aumentar el saldo de la cuenta 402 (Carlos) en $500
-- "saldo = saldo + 500.00" usa el valor actual de la columna
-- como parte del cálculo. Cuenta 402: 2000 + 500 = 2500.
UPDATE Cuentas
SET saldo = saldo + 500.00
WHERE id_cuenta = 402;

-- DELETE: eliminar la cuenta 503 de Elena (saldo 900)
-- ON DELETE CASCADE en Clientes → Cuentas protege la integridad,
-- pero este DELETE es de una cuenta, no de un cliente.
DELETE FROM Cuentas
WHERE id_cuenta = 503;

-- Verificar estado final (14 cuentas quedan)
SELECT 'Clientes' AS tabla, COUNT(*) AS filas FROM Clientes
UNION ALL
SELECT 'Cuentas',           COUNT(*)            FROM Cuentas;

SELECT cu.id_cuenta, cl.nombre, cu.saldo
FROM Cuentas cu
JOIN Clientes cl ON cu.id_cliente = cl.id_cliente
ORDER BY cl.id_cliente, cu.id_cuenta;
