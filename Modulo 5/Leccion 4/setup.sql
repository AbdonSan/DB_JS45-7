-- ============================================================
-- MÓDULO 5 – LECCIÓN 4: SQL DDL/DML
-- Sistema de Facturas: productos, existencias, facturas, detalle
-- Archivo: setup.sql  →  ejecutar PRIMERO (P1 a P9)
-- Motor: PostgreSQL
-- ============================================================
-- Conceptos nuevos (DDL avanzado):
--   SERIAL          → entero auto-incremental (PK automático)
--   ALTER TABLE ADD COLUMN  → agregar columna a tabla existente
--   ALTER TABLE DROP COLUMN → eliminar columna de tabla existente
--   ON DELETE CASCADE       → propaga el borrado a tablas hijas
-- ============================================================


-- ============================================================
-- LIMPIEZA PREVIA (para poder reejecutar el script)
-- ============================================================
DROP TABLE IF EXISTS detalle_facturas CASCADE;
DROP TABLE IF EXISTS existencias       CASCADE;
DROP TABLE IF EXISTS facturas          CASCADE;
DROP TABLE IF EXISTS productos         CASCADE;


-- ============================================================
-- P1: Crear las tablas del diagrama
-- ============================================================
-- Orden de creación: primero las tablas PADRE (sin FK),
-- luego las tablas HIJA (que referencian a las padres).
-- Árbol de dependencias:
--   productos (raíz)
--     ├── existencias    (FK → productos)
--     ├── detalle_facturas (FK → productos)
--     └── facturas (raíz)
--           └── detalle_facturas (FK → facturas)

-- Tabla 1: productos (sin dependencias, se crea primero)
CREATE TABLE productos (
    id          SERIAL        PRIMARY KEY,
    nombre      VARCHAR(255)  NOT NULL,
    descripcion VARCHAR(255)
);

-- Tabla 2: existencias (depende de productos)
-- pesoKg se eliminará en P9 con ALTER TABLE DROP COLUMN
CREATE TABLE existencias (
    id          SERIAL   PRIMARY KEY,
    id_producto INTEGER  NOT NULL,
    cantidad    INTEGER  NOT NULL DEFAULT 0,
    precio      INTEGER  NOT NULL,
    pesoKg      INTEGER,

    CONSTRAINT fk_exist_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id)
        ON DELETE CASCADE   -- si se borra un producto, su existencia se borra
        ON UPDATE CASCADE
);

-- Tabla 3: facturas (sin dependencias externas, se crea antes de detalle)
CREATE TABLE facturas (
    id              SERIAL       PRIMARY KEY,
    rut_comprador   VARCHAR(12)  NOT NULL,
    rut_vendedor    VARCHAR(12)  NOT NULL
    -- La columna "fecha" se agregará en P7 con ALTER TABLE
);

-- Tabla 4: detalle_facturas (depende de facturas Y de productos)
CREATE TABLE detalle_facturas (
    id          SERIAL   PRIMARY KEY,
    id_producto INTEGER  NOT NULL,
    id_factura  INTEGER  NOT NULL,

    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto)
        REFERENCES productos(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_detalle_factura
        FOREIGN KEY (id_factura)
        REFERENCES facturas(id)
        ON DELETE CASCADE
);

-- Verificar creación
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;


-- ============================================================
-- P2: Insertar 10 productos
-- ============================================================

INSERT INTO productos (nombre, descripcion) VALUES
    ('Laptop Dell Inspiron 15',  'Computador portátil Intel i7, 16GB RAM, 512GB SSD'),
    ('Mouse Logitech MX Master', 'Ratón inalámbrico ergonómico, 4000 DPI'),
    ('Teclado Mecánico Redragon','Teclado con switches Red, retroiluminación RGB'),
    ('Monitor Samsung 27" FHD',  'Pantalla IPS Full HD 1920x1080, 75Hz'),
    ('Audífonos Sony WH-1000XM5','Audífonos inalámbricos con cancelación de ruido activa'),
    ('Webcam Logitech C920',     'Cámara web 1080p con micrófono estéreo integrado'),
    ('SSD Kingston 1TB NVMe',    'Disco de estado sólido M.2 PCIe Gen4, 3500MB/s'),
    ('Memoria RAM 16GB DDR4',    'Módulo DIMM 3200MHz compatible Intel/AMD'),
    ('Silla Ergonómica HM Chair','Silla de oficina con soporte lumbar ajustable'),
    ('Alfombrilla Gaming XL',    'Alfombrilla 90x40cm superficie suave, base antideslizante');

SELECT * FROM productos;


-- ============================================================
-- P3: Insertar existencias para todos los productos (1 por producto)
-- ============================================================
-- Cada producto tiene su registro de existencia con precio y pesoKg.
-- Los id_producto deben coincidir con los IDs generados en P2.

INSERT INTO existencias (id_producto, cantidad, precio, pesoKg) VALUES
    (1,  5,  599990, 2),   -- Laptop
    (2,  30,  24990, 1),   -- Mouse
    (3,  15,  79990, 1),   -- Teclado
    (4,   8, 199990, 4),   -- Monitor
    (5,  20, 149990, 1),   -- Audífonos
    (6,  25,  49990, 1),   -- Webcam
    (7,  40,  89990, 1),   -- SSD
    (8,  35,  59990, 1),   -- RAM
    (9,  10, 299990,12),   -- Silla
    (10, 50,  19990, 1);   -- Alfombrilla

SELECT e.id, p.nombre, e.cantidad, e.precio, e.pesoKg
FROM existencias e
JOIN productos p ON e.id_producto = p.id
ORDER BY e.id;


-- ============================================================
-- P4: Insertar 5 facturas
-- ============================================================
-- Solo rut_comprador y rut_vendedor (la fecha se agrega en P7).

INSERT INTO facturas (rut_comprador, rut_vendedor) VALUES
    ('12345678-9', '98765432-1'),
    ('11222333-4', '98765432-1'),
    ('14555666-7', '87654321-0'),
    ('16777888-9', '87654321-0'),
    ('19000111-2', '98765432-1');

SELECT * FROM facturas;


-- ============================================================
-- P5: Insertar detalle para todas las facturas (3-5 productos c/u)
-- ============================================================
-- Distribución: F1(4 prod), F2(3 prod), F3(5 prod), F4(3 prod), F5(4 prod)

-- Factura 1: Laptop, Mouse, Teclado, Monitor
INSERT INTO detalle_facturas (id_factura, id_producto) VALUES
    (1, 1), (1, 2), (1, 3), (1, 4);

-- Factura 2: Mouse, Audífonos, Webcam
INSERT INTO detalle_facturas (id_factura, id_producto) VALUES
    (2, 2), (2, 5), (2, 6);

-- Factura 3: Laptop, Teclado, SSD, RAM, Silla
INSERT INTO detalle_facturas (id_factura, id_producto) VALUES
    (3, 1), (3, 3), (3, 7), (3, 8), (3, 9);

-- Factura 4: Monitor, Webcam, Alfombrilla
INSERT INTO detalle_facturas (id_factura, id_producto) VALUES
    (4, 4), (4, 6), (4, 10);

-- Factura 5: Mouse, Teclado, Audífonos, SSD
INSERT INTO detalle_facturas (id_factura, id_producto) VALUES
    (5, 2), (5, 3), (5, 5), (5, 7);

SELECT * FROM detalle_facturas ORDER BY id_factura, id_producto;


-- ============================================================
-- P6: Actualizar TODAS las existencias con cantidad = 10
-- ============================================================
-- UPDATE sin WHERE afecta a TODAS las filas de la tabla.
-- En este caso es intencional: reponer stock a 10 unidades.

UPDATE existencias
SET cantidad = 10;

SELECT id_producto, cantidad FROM existencias ORDER BY id_producto;


-- ============================================================
-- P7: Agregar columna "fecha" a facturas
-- ============================================================
-- ALTER TABLE ADD COLUMN modifica la estructura de una tabla existente
-- sin borrarla ni perder sus datos.
-- DATE en PostgreSQL almacena solo fecha (sin hora): 'YYYY-MM-DD'

ALTER TABLE facturas
ADD COLUMN fecha DATE;

-- Verificar que la columna fue agregada (aparece como NULL inicialmente)
SELECT * FROM facturas;


-- ============================================================
-- P8: Actualizar fecha con diferentes valores para cada factura
-- ============================================================
-- Cada UPDATE aplica a una sola factura gracias al WHERE id = N.
-- La fecha se escribe entre comillas simples en formato ISO: 'AAAA-MM-DD'

UPDATE facturas SET fecha = '2025-01-15' WHERE id = 1;
UPDATE facturas SET fecha = '2025-02-03' WHERE id = 2;
UPDATE facturas SET fecha = '2025-03-22' WHERE id = 3;
UPDATE facturas SET fecha = '2025-04-10' WHERE id = 4;
UPDATE facturas SET fecha = '2025-05-07' WHERE id = 5;

SELECT * FROM facturas ORDER BY id;


-- ============================================================
-- P9: Eliminar la columna pesoKg de existencias
-- ============================================================
-- ALTER TABLE DROP COLUMN elimina una columna y todos sus datos.
-- Esta operación es IRREVERSIBLE (no hay ROLLBACK después del COMMIT).

ALTER TABLE existencias
DROP COLUMN pesoKg;

-- Verificar que la columna ya no existe
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'existencias'
ORDER BY ordinal_position;
