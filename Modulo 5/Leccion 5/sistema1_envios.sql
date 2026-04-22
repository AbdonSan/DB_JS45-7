-- ============================================================
-- MÓDULO 5 – LECCIÓN 5: Modelado ER y Normalización
-- SISTEMA 1: Envío de Encomiendas
-- Archivo: sistema1_envios.sql
-- Motor: PostgreSQL
-- ============================================================
-- DIAGRAMA ER (texto):
--
--  cliente ─────1──────< encomienda >──────1──── cliente
--  (remitente)              │                   (destinatario)
--                           │
--              ┌────────────┼────────────┐
--              │            │            │
--           sucursal    historial     tarifa
--           (origen/    _estado
--           destino)       │
--                        estado
--
-- ENTIDADES:
--   cliente         → quien envía o recibe
--   sucursal        → punto de despacho o entrega
--   encomienda      → el paquete enviado
--   tarifa          → precio base + cargo por kg
--   estado          → catálogo de estados (En tránsito, Entregado...)
--   historial_estado→ cada cambio de estado de una encomienda
--
-- RELACIONES Y CARDINALIDADES:
--   cliente      1:N  encomienda  (como remitente)
--   cliente      1:N  encomienda  (como destinatario)
--   sucursal     1:N  encomienda  (origen)
--   sucursal     1:N  encomienda  (destino)
--   tarifa       1:N  encomienda
--   encomienda   1:N  historial_estado
--   estado       1:N  historial_estado
-- ============================================================
-- NORMALIZACIÓN (hasta 3FN):
--   1FN: Cada atributo contiene un solo valor atómico.
--        (Ej: dirección separada de ciudad, no en un solo campo)
--   2FN: Todos los atributos dependen de la CLAVE COMPLETA.
--        (La tarifa y el estado son tablas propias, no campos en encomienda)
--   3FN: Sin dependencias transitivas.
--        (Ej: precio por kg NO depende del nombre de la tarifa,
--         ambos se guardan en la tabla tarifa directamente)
-- ============================================================

DROP TABLE IF EXISTS historial_estado CASCADE;
DROP TABLE IF EXISTS encomienda       CASCADE;
DROP TABLE IF EXISTS tarifa           CASCADE;
DROP TABLE IF EXISTS estado           CASCADE;
DROP TABLE IF EXISTS sucursal         CASCADE;
DROP TABLE IF EXISTS cliente          CASCADE;


-- Tabla catálogo: tarifa
-- 3FN: precio_base y precio_por_kg dependen solo del id_tarifa
CREATE TABLE tarifa (
    id_tarifa       SERIAL          PRIMARY KEY,
    nombre          VARCHAR(50)     NOT NULL UNIQUE,  -- 'Express', 'Normal', 'Económica'
    precio_base     NUMERIC(10,2)   NOT NULL CHECK (precio_base >= 0),
    precio_por_kg   NUMERIC(10,2)   NOT NULL CHECK (precio_por_kg >= 0)
);

-- Tabla catálogo: estado
CREATE TABLE estado (
    id_estado       SERIAL          PRIMARY KEY,
    nombre          VARCHAR(50)     NOT NULL UNIQUE,  -- 'Recibido', 'En tránsito', 'Entregado'
    descripcion     VARCHAR(255)
);

-- Tabla independiente: sucursal
-- Se separa ciudad/region para evitar dependencia transitiva (3FN)
CREATE TABLE sucursal (
    id_sucursal     SERIAL          PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    direccion       VARCHAR(255)    NOT NULL,
    ciudad          VARCHAR(100)    NOT NULL,
    region          VARCHAR(100)    NOT NULL,
    telefono        VARCHAR(20)
);

-- Tabla: cliente (puede ser remitente o destinatario)
CREATE TABLE cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    rut             VARCHAR(12)     NOT NULL UNIQUE,
    nombre          VARCHAR(100)    NOT NULL,
    email           VARCHAR(120)    UNIQUE,
    telefono        VARCHAR(20),
    direccion       VARCHAR(255)
);

-- Tabla central: encomienda
-- 2FN: cada atributo depende del id_encomienda completo (PK simple → trivialmente 2FN)
-- 3FN: la tarifa y la sucursal están normalizadas en sus propias tablas
CREATE TABLE encomienda (
    id_encomienda       SERIAL          PRIMARY KEY,
    id_remitente        INT             NOT NULL REFERENCES cliente(id_cliente),
    id_destinatario     INT             NOT NULL REFERENCES cliente(id_cliente),
    id_sucursal_origen  INT             NOT NULL REFERENCES sucursal(id_sucursal),
    id_sucursal_destino INT             NOT NULL REFERENCES sucursal(id_sucursal),
    id_tarifa           INT             NOT NULL REFERENCES tarifa(id_tarifa),
    peso_kg             NUMERIC(8,2)    NOT NULL CHECK (peso_kg > 0),
    descripcion         VARCHAR(255),
    fecha_creacion      TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Tabla historial: registra cada cambio de estado de una encomienda
-- Relación 1:N entre encomienda y sus estados a lo largo del tiempo
CREATE TABLE historial_estado (
    id_historial    SERIAL          PRIMARY KEY,
    id_encomienda   INT             NOT NULL REFERENCES encomienda(id_encomienda) ON DELETE CASCADE,
    id_estado       INT             NOT NULL REFERENCES estado(id_estado),
    fecha_cambio    TIMESTAMP       NOT NULL DEFAULT NOW(),
    observacion     VARCHAR(255)
);

-- Índices en FK muy consultadas (mejora rendimiento)
CREATE INDEX idx_encomienda_remitente   ON encomienda(id_remitente);
CREATE INDEX idx_encomienda_destinatario ON encomienda(id_destinatario);
CREATE INDEX idx_historial_encomienda   ON historial_estado(id_encomienda);


-- ============================================================
-- Datos de prueba
-- ============================================================
INSERT INTO tarifa (nombre, precio_base, precio_por_kg) VALUES
    ('Económica', 2990,  500),
    ('Normal',    4990,  800),
    ('Express',   9990, 1200);

INSERT INTO estado (nombre, descripcion) VALUES
    ('Recibido',    'Encomienda ingresada al sistema'),
    ('En tránsito', 'En camino a sucursal destino'),
    ('En reparto',  'Repartidor tiene la encomienda'),
    ('Entregado',   'Recibida por el destinatario'),
    ('Devuelto',    'No fue posible entregar');

INSERT INTO sucursal (nombre, direccion, ciudad, region) VALUES
    ('Sucursal Centro', 'Av. Libertador 100', 'Santiago', 'Metropolitana'),
    ('Sucursal Norte',  'Calle Atacama 50',   'Antofagasta', 'Antofagasta'),
    ('Sucursal Sur',    'Av. Pedro Montt 30', 'Puerto Montt', 'Los Lagos');

INSERT INTO cliente (rut, nombre, email, telefono) VALUES
    ('12345678-9', 'Ana González',   'ana@mail.com',  '+56912345678'),
    ('98765432-1', 'Luis Pérez',     'luis@mail.com', '+56987654321'),
    ('11222333-4', 'María Soto',     'maria@mail.com','+56911222333');

INSERT INTO encomienda (id_remitente, id_destinatario, id_sucursal_origen, id_sucursal_destino, id_tarifa, peso_kg, descripcion)
VALUES (1, 2, 1, 2, 2, 3.5, 'Libros y documentos');

INSERT INTO historial_estado (id_encomienda, id_estado, observacion) VALUES
    (1, 1, 'Ingresada en sucursal Centro'),
    (1, 2, 'Salió en camión nocturno'),
    (1, 4, 'Firmada por Luis Pérez');

-- Consulta de verificación
SELECT e.id_encomienda, c1.nombre AS remitente, c2.nombre AS destinatario,
       t.nombre AS tarifa, s1.ciudad AS origen, s2.ciudad AS destino,
       e.peso_kg, e.fecha_creacion
FROM encomienda e
JOIN cliente c1    ON c1.id_cliente  = e.id_remitente
JOIN cliente c2    ON c2.id_cliente  = e.id_destinatario
JOIN tarifa  t     ON t.id_tarifa    = e.id_tarifa
JOIN sucursal s1   ON s1.id_sucursal = e.id_sucursal_origen
JOIN sucursal s2   ON s2.id_sucursal = e.id_sucursal_destino;
