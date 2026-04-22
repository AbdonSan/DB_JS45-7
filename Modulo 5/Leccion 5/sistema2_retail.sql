-- ============================================================
-- MÓDULO 5 – LECCIÓN 5: Modelado ER y Normalización
-- SISTEMA 2: Venta de Productos Retail
-- Archivo: sistema2_retail.sql
-- Motor: PostgreSQL
-- ============================================================
-- DIAGRAMA ER (texto):
--
--  categoria ──1──< producto >──N──< detalle_pedido >──N── pedido ──1──< pago
--                                                              │
--                                                           cliente
--
-- ENTIDADES:
--   categoria      → clasificación del producto
--   producto       → artículo con precio y stock
--   cliente        → quien compra
--   pedido         → orden de compra
--   detalle_pedido → línea de productos de un pedido (N:M)
--   pago           → registro del pago del pedido
--
-- RELACIONES Y CARDINALIDADES:
--   categoria    1:N  producto
--   cliente      1:N  pedido
--   pedido       N:M  producto   → tabla intermedia: detalle_pedido
--   pedido       1:1  pago       (un pedido tiene un pago, aunque podría ser 1:N)
--
-- CLAVE DE DISEÑO – precio_unitario en detalle_pedido:
--   El precio del producto puede cambiar en el futuro.
--   Guardarlo en detalle_pedido preserva el precio HISTÓRICO de la venta.
--   Si usáramos solo producto.precio, el total de la factura cambiaría
--   cada vez que se actualiza el precio del producto.
-- ============================================================
-- NORMALIZACIÓN:
--   1FN: Atributos atómicos. (nombre + descripcion + precio son simples)
--   2FN: detalle_pedido tiene PK compuesta (id_pedido, id_producto).
--        cantidad y precio_unitario dependen de AMBAS claves → cumple 2FN.
--   3FN: categoria separada de producto (el nombre de categoría
--        depende de id_categoria, no de id_producto → sin trans. dep.)
-- ============================================================

DROP TABLE IF EXISTS pago           CASCADE;
DROP TABLE IF EXISTS detalle_pedido CASCADE;
DROP TABLE IF EXISTS pedido         CASCADE;
DROP TABLE IF EXISTS producto       CASCADE;
DROP TABLE IF EXISTS categoria      CASCADE;
DROP TABLE IF EXISTS cliente        CASCADE;


-- Tabla catálogo: categoria
-- 3FN: descripcion depende solo de id_categoria, no del nombre del producto
CREATE TABLE categoria (
    id_categoria    SERIAL          PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL UNIQUE,
    descripcion     VARCHAR(255)
);

-- Tabla: cliente
CREATE TABLE cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    rut             VARCHAR(12)     NOT NULL UNIQUE,
    nombre          VARCHAR(100)    NOT NULL,
    email           VARCHAR(120)    UNIQUE,
    telefono        VARCHAR(20),
    fecha_registro  DATE            NOT NULL DEFAULT CURRENT_DATE
);

-- Tabla: producto
-- id_categoria FK → evita guardar el nombre de categoría aquí (3FN)
CREATE TABLE producto (
    id_producto     SERIAL          PRIMARY KEY,
    id_categoria    INT             NOT NULL REFERENCES categoria(id_categoria),
    nombre          VARCHAR(255)    NOT NULL,
    descripcion     VARCHAR(255),
    precio          NUMERIC(12,2)   NOT NULL CHECK (precio >= 0),
    stock           INT             NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

-- Tabla: pedido
-- estado: 'pendiente', 'confirmado', 'enviado', 'entregado', 'cancelado'
CREATE TABLE pedido (
    id_pedido       SERIAL          PRIMARY KEY,
    id_cliente      INT             NOT NULL REFERENCES cliente(id_cliente),
    fecha_pedido    TIMESTAMP       NOT NULL DEFAULT NOW(),
    estado          VARCHAR(20)     NOT NULL DEFAULT 'pendiente'
                    CHECK (estado IN ('pendiente','confirmado','enviado','entregado','cancelado'))
);

-- Tabla intermedia N:M: detalle_pedido
-- PK compuesta: (id_pedido, id_producto) → un producto no se repite en el mismo pedido
-- precio_unitario: captura el precio al momento de la venta (precio histórico)
CREATE TABLE detalle_pedido (
    id_pedido       INT             NOT NULL REFERENCES pedido(id_pedido)    ON DELETE CASCADE,
    id_producto     INT             NOT NULL REFERENCES producto(id_producto) ON DELETE RESTRICT,
    cantidad        INT             NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2)   NOT NULL CHECK (precio_unitario >= 0),

    PRIMARY KEY (id_pedido, id_producto)  -- PK compuesta
);

-- Tabla: pago
-- metodo: 'efectivo', 'tarjeta_debito', 'tarjeta_credito', 'transferencia'
CREATE TABLE pago (
    id_pago         SERIAL          PRIMARY KEY,
    id_pedido       INT             NOT NULL UNIQUE REFERENCES pedido(id_pedido),  -- 1:1
    monto           NUMERIC(12,2)   NOT NULL CHECK (monto > 0),
    fecha_pago      TIMESTAMP       NOT NULL DEFAULT NOW(),
    metodo_pago     VARCHAR(30)     NOT NULL
                    CHECK (metodo_pago IN ('efectivo','tarjeta_debito','tarjeta_credito','transferencia'))
);

-- Índices en FK de alta consulta
CREATE INDEX idx_producto_categoria ON producto(id_categoria);
CREATE INDEX idx_pedido_cliente      ON pedido(id_cliente);
CREATE INDEX idx_detalle_producto    ON detalle_pedido(id_producto);


-- ============================================================
-- Datos de prueba
-- ============================================================
INSERT INTO categoria (nombre) VALUES
    ('Computación'), ('Audio'), ('Oficina'), ('Gaming');

INSERT INTO cliente (rut, nombre, email) VALUES
    ('12345678-9', 'Ana García',    'ana@mail.com'),
    ('11222333-4', 'Luis Torres',   'luis@mail.com'),
    ('14555666-7', 'María Soto',    'maria@mail.com');

INSERT INTO producto (id_categoria, nombre, precio, stock) VALUES
    (1, 'Laptop Dell 15"',          599990, 10),
    (2, 'Audífonos Sony WH-1000',   149990, 25),
    (1, 'Teclado Mecánico Redragon', 79990, 30),
    (3, 'Silla Ergonómica HM',      299990,  8),
    (4, 'Mouse Gaming Corsair',      59990, 20);

INSERT INTO pedido (id_cliente, estado) VALUES
    (1, 'confirmado'),
    (2, 'entregado'),
    (3, 'pendiente');

-- Detalle pedido 1: Laptop + Audífonos + Teclado
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
    (1, 1, 1, 599990),
    (1, 2, 1, 149990),
    (1, 3, 2,  79990);

-- Detalle pedido 2: Silla + Mouse
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
    (2, 4, 1, 299990),
    (2, 5, 2,  59990);

-- Detalle pedido 3: Laptop
INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
    (3, 1, 1, 599990);

INSERT INTO pago (id_pedido, monto, metodo_pago) VALUES
    (1, 909960, 'tarjeta_credito'),
    (2, 419970, 'transferencia');

-- Consulta: total de cada pedido
SELECT p.id_pedido, cl.nombre, p.fecha_pedido, p.estado,
       SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedido p
JOIN cliente        cl ON cl.id_cliente  = p.id_cliente
JOIN detalle_pedido dp ON dp.id_pedido   = p.id_pedido
GROUP BY p.id_pedido, cl.nombre, p.fecha_pedido, p.estado
ORDER BY p.id_pedido;
