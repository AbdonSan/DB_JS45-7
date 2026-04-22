-- ============================================================
-- MÓDULO 5 – LECCIÓN 4: Consultas y Borrado Final
-- Archivo: consultas.sql  →  ejecutar DESPUÉS de setup.sql (P10-P12)
-- ============================================================
-- Estado actual de la BD:
--   10 productos, 10 existencias (sin pesoKg), 5 facturas (con fecha),
--   19 líneas de detalle en total.
--
-- Factura 1 (ejemplo): Laptop(599990), Mouse(24990),
--                       Teclado(79990), Monitor(199990)
--   Total factura 1 = 904.960 pesos
-- ============================================================


-- ============================================================
-- P10: Consultar factura 1 con su detalle, nombre y precio
-- ============================================================
-- Se combinan 3 tablas con JOIN:
--   detalle_facturas → facturas    (por id_factura)
--   detalle_facturas → productos   (por id_producto)
--   productos        → existencias (por id = id_producto)
--
-- Cambia el número de factura en el WHERE para ver otras facturas.

SELECT
    f.id                    AS "Nº Factura",
    f.fecha,
    f.rut_comprador,
    f.rut_vendedor,
    p.nombre                AS "Producto",
    p.descripcion,
    e.precio                AS "Precio unitario"
FROM facturas f
JOIN detalle_facturas df ON df.id_factura  = f.id
JOIN productos        p  ON p.id           = df.id_producto
JOIN existencias      e  ON e.id_producto  = p.id
WHERE f.id = 1                              -- ← cambiar para otras facturas
ORDER BY p.nombre;


-- ============================================================
-- P11: Consultar el valor final de la factura 1
-- ============================================================
-- El total se obtiene sumando el precio de cada producto del detalle.
-- (El diagrama no incluye cantidad en detalle_facturas,
--  por lo tanto se asume 1 unidad por línea de detalle.)
--
-- Cálculo Factura 1:
--   Laptop:   599.990
--   Mouse:     24.990
--   Teclado:   79.990
--   Monitor:  199.990
--   ───────────────────
--   TOTAL:    904.960

SELECT
    f.id            AS "Nº Factura",
    f.fecha,
    f.rut_comprador,
    COUNT(df.id)    AS "Cantidad ítems",
    SUM(e.precio)   AS "Valor total"
FROM facturas f
JOIN detalle_facturas df ON df.id_factura  = f.id
JOIN productos        p  ON p.id           = df.id_producto
JOIN existencias      e  ON e.id_producto  = p.id
WHERE f.id = 1
GROUP BY f.id, f.fecha, f.rut_comprador;


-- ============================================================
-- BONUS P11b: Valor total de TODAS las facturas
-- ============================================================
-- Quitar el WHERE y agrupar por factura para ver el resumen general.

SELECT
    f.id            AS "Nº Factura",
    f.fecha,
    f.rut_comprador,
    COUNT(df.id)    AS "Cantidad ítems",
    SUM(e.precio)   AS "Valor total"
FROM facturas f
JOIN detalle_facturas df ON df.id_factura  = f.id
JOIN productos        p  ON p.id           = df.id_producto
JOIN existencias      e  ON e.id_producto  = p.id
GROUP BY f.id, f.fecha, f.rut_comprador
ORDER BY f.id;


-- ============================================================
-- P12: Eliminar todos los productos
-- ============================================================
-- DELETE FROM productos sin WHERE → borra TODAS las filas.
-- Gracias a ON DELETE CASCADE definido en setup.sql:
--   → Se borran automáticamente todas las existencias (FK → productos)
--   → Se borran automáticamente todos los detalle_facturas (FK → productos)
--
-- Las facturas NO se borran porque no dependen de productos directamente.

DELETE FROM productos;

-- Verificar que las tablas quedaron vacías por CASCADE
SELECT 'productos'        AS tabla, COUNT(*) AS filas FROM productos
UNION ALL
SELECT 'existencias',              COUNT(*)            FROM existencias
UNION ALL
SELECT 'detalle_facturas',         COUNT(*)            FROM detalle_facturas
UNION ALL
SELECT 'facturas (intacta)',        COUNT(*)            FROM facturas;
