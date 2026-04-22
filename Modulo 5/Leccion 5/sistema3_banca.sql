-- ============================================================
-- MÓDULO 5 – LECCIÓN 5: Modelado ER y Normalización
-- SISTEMA 3: Administrador de Cuentas Bancarias
-- Archivo: sistema3_banca.sql
-- Motor: PostgreSQL
-- ============================================================
-- DIAGRAMA ER (texto):
--
--  tipo_cuenta ──1──< cuenta >──1── cliente
--                     │
--                     │ (origen/destino)
--                     ▼
--               transaccion ──N──1── tipo_transaccion
--
-- ENTIDADES:
--   cliente           → titular de una o más cuentas
--   tipo_cuenta       → 'Corriente', 'Vista', 'Ahorro' (catálogo)
--   cuenta            → cuenta bancaria de un cliente
--   tipo_transaccion  → 'Depósito', 'Retiro', 'Transferencia' (catálogo)
--   transaccion       → movimiento de dinero entre o sobre cuentas
--
-- RELACIONES Y CARDINALIDADES:
--   cliente          1:N  cuenta
--   tipo_cuenta      1:N  cuenta
--   tipo_transaccion 1:N  transaccion
--   cuenta           1:N  transaccion (como cuenta_origen)
--   cuenta           1:N  transaccion (como cuenta_destino, NULLABLE para retiros/depósitos)
--
-- CLAVE DE DISEÑO – cuenta_destino nullable:
--   Un retiro o depósito solo usa cuenta_origen.
--   Una transferencia usa cuenta_origen Y cuenta_destino.
--   Al ser nullable, el modelo cubre ambos casos sin tabla extra.
-- ============================================================
-- NORMALIZACIÓN:
--   1FN: nombre y apellido son campos separados (atributos atómicos).
--        fecha_nacimiento como DATE, no como texto.
--   2FN: Todos los atributos dependen del PK entero (PKs simples → trivial).
--   3FN: tipo_cuenta separado de cuenta (nombre del tipo NO depende
--        del número de cuenta → sin dependencia transitiva).
--        tipo_transaccion separado de transaccion por la misma razón.
-- ============================================================

DROP TABLE IF EXISTS transaccion      CASCADE;
DROP TABLE IF EXISTS tipo_transaccion CASCADE;
DROP TABLE IF EXISTS cuenta           CASCADE;
DROP TABLE IF EXISTS tipo_cuenta      CASCADE;
DROP TABLE IF EXISTS cliente          CASCADE;


-- Tabla catálogo: tipo_cuenta
-- 3FN: descripcion y tasa_interes dependen solo de id_tipo_cuenta
CREATE TABLE tipo_cuenta (
    id_tipo_cuenta  SERIAL          PRIMARY KEY,
    nombre          VARCHAR(50)     NOT NULL UNIQUE,  -- 'Corriente', 'Vista', 'Ahorro'
    descripcion     VARCHAR(255),
    tasa_interes    NUMERIC(5,4)    NOT NULL DEFAULT 0 CHECK (tasa_interes >= 0)
);

-- Tabla catálogo: tipo_transaccion
CREATE TABLE tipo_transaccion (
    id_tipo_tx      SERIAL          PRIMARY KEY,
    nombre          VARCHAR(50)     NOT NULL UNIQUE,  -- 'Depósito', 'Retiro', 'Transferencia'
    descripcion     VARCHAR(255),
    afecta_saldo    VARCHAR(10)     NOT NULL          -- 'positivo', 'negativo', 'neutro'
                    CHECK (afecta_saldo IN ('positivo','negativo','neutro'))
);

-- Tabla: cliente
-- nombre y apellido separados (1FN: atributos atómicos)
CREATE TABLE cliente (
    id_cliente      SERIAL          PRIMARY KEY,
    rut             VARCHAR(12)     NOT NULL UNIQUE,
    nombre          VARCHAR(100)    NOT NULL,
    apellido        VARCHAR(100)    NOT NULL,
    email           VARCHAR(120)    UNIQUE,
    telefono        VARCHAR(20),
    fecha_nacimiento DATE           CHECK (fecha_nacimiento < CURRENT_DATE)
);

-- Tabla: cuenta
-- numero_cuenta: código único legible (ej: '000-123-456789')
-- saldo no puede ser negativo (restricción bancaria básica)
-- activa: permite desactivar sin borrar (soft delete)
CREATE TABLE cuenta (
    id_cuenta       SERIAL          PRIMARY KEY,
    id_cliente      INT             NOT NULL REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
    id_tipo_cuenta  INT             NOT NULL REFERENCES tipo_cuenta(id_tipo_cuenta),
    numero_cuenta   VARCHAR(20)     NOT NULL UNIQUE,
    saldo           NUMERIC(14,2)   NOT NULL DEFAULT 0 CHECK (saldo >= 0),
    fecha_apertura  DATE            NOT NULL DEFAULT CURRENT_DATE,
    activa          BOOLEAN         NOT NULL DEFAULT TRUE
);

-- Tabla: transaccion
-- cuenta_destino es NULL en retiros y depósitos (solo aplica a transferencias)
-- monto siempre positivo; la dirección la da el tipo_transaccion
CREATE TABLE transaccion (
    id_transaccion  SERIAL          PRIMARY KEY,
    id_tipo_tx      INT             NOT NULL REFERENCES tipo_transaccion(id_tipo_tx),
    id_cuenta_origen  INT           NOT NULL REFERENCES cuenta(id_cuenta),
    id_cuenta_destino INT                    REFERENCES cuenta(id_cuenta),  -- NULL en retiros/depósitos
    monto           NUMERIC(14,2)   NOT NULL CHECK (monto > 0),
    fecha           TIMESTAMP       NOT NULL DEFAULT NOW(),
    descripcion     VARCHAR(255),

    -- Restricción: en transferencia, origen ≠ destino
    CONSTRAINT chk_cuentas_distintas
        CHECK (id_cuenta_origen <> id_cuenta_destino OR id_cuenta_destino IS NULL)
);

-- Índices clave
CREATE INDEX idx_cuenta_cliente      ON cuenta(id_cliente);
CREATE INDEX idx_tx_cuenta_origen    ON transaccion(id_cuenta_origen);
CREATE INDEX idx_tx_cuenta_destino   ON transaccion(id_cuenta_destino);
CREATE INDEX idx_tx_fecha            ON transaccion(fecha);


-- ============================================================
-- Datos de prueba
-- ============================================================
INSERT INTO tipo_cuenta (nombre, descripcion, tasa_interes) VALUES
    ('Vista',      'Cuenta vista sin interés',           0.0000),
    ('Corriente',  'Cuenta corriente con línea de crédito', 0.0000),
    ('Ahorro',     'Cuenta de ahorro con interés mensual',  0.0025);

INSERT INTO tipo_transaccion (nombre, descripcion, afecta_saldo) VALUES
    ('Depósito',      'Ingreso de dinero a una cuenta',         'positivo'),
    ('Retiro',        'Extracción de dinero de una cuenta',     'negativo'),
    ('Transferencia', 'Traspaso entre cuentas',                 'neutro');

INSERT INTO cliente (rut, nombre, apellido, email, fecha_nacimiento) VALUES
    ('12345678-9', 'Ana',    'García',  'ana@banco.cl',   '1985-03-15'),
    ('98765432-1', 'Luis',   'Pérez',   'luis@banco.cl',  '1990-07-22'),
    ('11222333-4', 'María',  'Soto',    'maria@banco.cl', '1978-11-05');

INSERT INTO cuenta (id_cliente, id_tipo_cuenta, numero_cuenta, saldo) VALUES
    (1, 1, '000-001-000001', 500000.00),   -- Ana, Vista
    (1, 3, '000-003-000002', 1200000.00),  -- Ana, Ahorro
    (2, 2, '000-002-000003', 350000.00),   -- Luis, Corriente
    (3, 1, '000-001-000004', 80000.00);    -- María, Vista

-- Depósito en cuenta de Ana (Vista)
INSERT INTO transaccion (id_tipo_tx, id_cuenta_origen, id_cuenta_destino, monto, descripcion)
VALUES (1, 1, NULL, 200000, 'Depósito en efectivo');

-- Retiro de cuenta de Luis
INSERT INTO transaccion (id_tipo_tx, id_cuenta_origen, id_cuenta_destino, monto, descripcion)
VALUES (2, 3, NULL, 50000, 'Retiro cajero automático');

-- Transferencia de Ana (Vista) → María (Vista)
INSERT INTO transaccion (id_tipo_tx, id_cuenta_origen, id_cuenta_destino, monto, descripcion)
VALUES (3, 1, 4, 100000, 'Pago arriendo');

-- Consulta: movimientos de la cuenta 1 (Ana Vista)
SELECT tx.id_transaccion, tt.nombre AS tipo,
       co.numero_cuenta AS origen, cd.numero_cuenta AS destino,
       tx.monto, tx.fecha, tx.descripcion
FROM transaccion tx
JOIN tipo_transaccion tt ON tt.id_tipo_tx = tx.id_tipo_tx
JOIN cuenta co           ON co.id_cuenta  = tx.id_cuenta_origen
LEFT JOIN cuenta cd      ON cd.id_cuenta  = tx.id_cuenta_destino
WHERE tx.id_cuenta_origen = 1
   OR tx.id_cuenta_destino = 1
ORDER BY tx.fecha;

-- Resumen de saldos por cliente
SELECT cl.nombre, cl.apellido, tc.nombre AS tipo_cuenta,
       cu.numero_cuenta, cu.saldo
FROM cuenta cu
JOIN cliente      cl ON cl.id_cliente     = cu.id_cliente
JOIN tipo_cuenta  tc ON tc.id_tipo_cuenta = cu.id_tipo_cuenta
ORDER BY cl.nombre, tc.nombre;
