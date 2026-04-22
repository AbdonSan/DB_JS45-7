# Módulo 5 – Lección 5: Modelado ER y Normalización

## Objetivo
Diseñar modelos Entidad-Relación, aplicar normalización hasta Tercera Forma Normal (3FN) e implementar los esquemas en SQL con restricciones de integridad.

---

## Archivos del proyecto

| Archivo | Sistema |
|---|---|
| `sistema1_envios.sql` | Envío de encomiendas |
| `sistema2_retail.sql` | Venta de productos retail |
| `sistema3_banca.sql` | Administrador de cuentas bancarias |

---

## Teoría: Normalización

La normalización elimina redundancia y anomalías de inserción/actualización/borrado.

### Primera Forma Normal (1FN)
> Cada celda contiene **un solo valor atómico** (indivisible).

```
❌ Sin 1FN                      ✓ Con 1FN
────────────────────────        ──────────────────────────────────
cliente | telefonos              cliente | telefono1 | telefono2
Ana     | 999-111, 999-222  →   Ana     | 999-111   | 999-222
                                 -- ó mejor: tabla teléfonos separada
```

### Segunda Forma Normal (2FN)
> Solo aplica a tablas con **PK compuesta**.
> Cada atributo no-clave depende de la **PK completa**, no de una parte.

```
❌ Sin 2FN (PK compuesta: id_pedido + id_producto)
id_pedido | id_producto | cantidad | nombre_producto ← depende solo de id_producto
1         | 5           | 2        | Laptop

✓ Con 2FN
detalle_pedido: id_pedido, id_producto, cantidad   ← dependen de AMBAS PKs
producto:       id_producto, nombre                ← depende solo de id_producto
```

### Tercera Forma Normal (3FN)
> Sin **dependencias transitivas**: ningún atributo no-clave depende de otro atributo no-clave.

```
❌ Sin 3FN
id_producto | id_categoria | nombre_categoria ← depende de id_categoria, no de id_producto

✓ Con 3FN
producto:   id_producto, id_categoria (FK)
categoria:  id_categoria, nombre_categoria
```

---

## Sistema 1 – Envío de Encomiendas

### Diagrama ER
```
┌──────────┐       ┌────────────────┐       ┌──────────┐
│  tarifa  │──1──<─│   encomienda   │─>──1──│ sucursal │
└──────────┘       │                │       └──────────┘
                   │ id_remitente   │──>──1──┐
                   │ id_destinatario│──>──1──┤ cliente
                   └────────────────┘        └──────────┘
                           │ 1
                           │
                           N
                  ┌─────────────────┐
                  │ historial_estado│──>──1──┐ estado
                  └─────────────────┘        └────────
```

### Tablas resultantes

| Tabla | PK | FK |
|---|---|---|
| `tarifa` | id_tarifa | — |
| `estado` | id_estado | — |
| `sucursal` | id_sucursal | — |
| `cliente` | id_cliente | — |
| `encomienda` | id_encomienda | id_remitente, id_destinatario, id_sucursal_origen, id_sucursal_destino, id_tarifa |
| `historial_estado` | id_historial | id_encomienda, id_estado |

### Decisiones de diseño
- **Dos FK a `cliente` en `encomienda`**: remitente y destinatario son roles del mismo tipo de entidad.
- **`historial_estado` separado**: permite ver el historial completo de estados (no solo el actual).
- **`tarifa` como catálogo**: precio_base y precio_por_kg son propios de la tarifa, no de la encomienda.

---

## Sistema 2 – Venta de Productos Retail

### Diagrama ER
```
┌──────────┐     ┌──────────┐     ┌────────────────┐     ┌────────┐
│ categoria│─1─<─│ producto │─N─<─│ detalle_pedido │─>─N─│ pedido │─>─1─┌ cliente
└──────────┘     └──────────┘     └────────────────┘     └────────┘     └────────
                                                               │ 1
                                                               │
                                                               1
                                                          ┌──────┐
                                                          │ pago │
                                                          └──────┘
```

### Tablas resultantes

| Tabla | PK | FK | Nota |
|---|---|---|---|
| `categoria` | id_categoria | — | Catálogo |
| `cliente` | id_cliente | — | |
| `producto` | id_producto | id_categoria | |
| `pedido` | id_pedido | id_cliente | |
| `detalle_pedido` | (id_pedido, id_producto) | id_pedido, id_producto | **PK compuesta** |
| `pago` | id_pago | id_pedido UNIQUE | 1:1 con pedido |

### Decisiones de diseño clave

**`precio_unitario` en `detalle_pedido`:**
```
Si solo guardaras el FK al producto, al cambiar el precio del producto
el total histórico de todas las facturas pasadas cambiaría.
Guardarlo en detalle_pedido = precio histórico = valor correcto.
```

**PK compuesta en `detalle_pedido`:**
```sql
PRIMARY KEY (id_pedido, id_producto)
-- Un mismo producto no puede aparecer dos veces en el mismo pedido.
-- Si necesitas más de 1 unidad, usas la columna "cantidad".
```

### Consulta de totales
```sql
SELECT p.id_pedido, cl.nombre,
       SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedido p
JOIN cliente        cl ON cl.id_cliente = p.id_cliente
JOIN detalle_pedido dp ON dp.id_pedido  = p.id_pedido
GROUP BY p.id_pedido, cl.nombre;
```

---

## Sistema 3 – Cuentas Bancarias

### Diagrama ER
```
┌────────────┐     ┌─────────┐     ┌────────┐
│ tipo_cuenta│─1─<─│  cuenta │─>─1─│cliente │
└────────────┘     └─────────┘     └────────┘
                        │ 1 (origen)
                        │ 1 (destino, nullable)
                        ▼ N
                  ┌─────────────┐     ┌──────────────────┐
                  │ transaccion │─>─1─│ tipo_transaccion  │
                  └─────────────┘     └──────────────────┘
```

### Tablas resultantes

| Tabla | PK | FK | Nota |
|---|---|---|---|
| `tipo_cuenta` | id_tipo_cuenta | — | Catálogo |
| `tipo_transaccion` | id_tipo_tx | — | Catálogo |
| `cliente` | id_cliente | — | |
| `cuenta` | id_cuenta | id_cliente, id_tipo_cuenta | |
| `transaccion` | id_transaccion | id_tipo_tx, id_cuenta_origen, id_cuenta_destino (nullable) | |

### Decisiones de diseño clave

**`id_cuenta_destino` nullable:**
```
Depósito/Retiro:     cuenta_origen ✓  |  cuenta_destino NULL
Transferencia:       cuenta_origen ✓  |  cuenta_destino ✓
Un solo modelo cubre ambos casos.
```

**Restricción CHECK contra auto-transferencia:**
```sql
CONSTRAINT chk_cuentas_distintas
    CHECK (id_cuenta_origen <> id_cuenta_destino OR id_cuenta_destino IS NULL)
```

**`saldo >= 0` como CHECK:**
```sql
saldo NUMERIC(14,2) NOT NULL CHECK (saldo >= 0)
```
Impide que el saldo llegue a negativo en la BD (la lógica de negocio debería validar antes).

---

## Comparativa de los 3 sistemas

| Característica | Envíos | Retail | Banca |
|---|---|---|---|
| Tabla N:M | — | `detalle_pedido` | — |
| FK nullable | — | — | `cuenta_destino` en transaccion |
| PK compuesta | — | (id_pedido, id_producto) | — |
| Historial/log | `historial_estado` | — | `transaccion` |
| Catálogos | tarifa, estado | categoria | tipo_cuenta, tipo_tx |
| Soft delete | — | — | `activa` en cuenta |

---

## Guía de verificación: ¿el diseño cumple las 3FN?

**Checklist antes de crear tablas:**
- [ ] Cada atributo contiene un solo valor (1FN)
- [ ] Si la PK es compuesta, todos los atributos dependen de ella completa (2FN)
- [ ] Ningún atributo no-clave depende de otro atributo no-clave (3FN)
- [ ] Relaciones N:M tienen tabla intermedia propia
- [ ] Los catálogos (tipos, estados) son tablas separadas
- [ ] `SERIAL` o equivalente para PKs auto-generadas
- [ ] `NOT NULL` en columnas obligatorias
- [ ] `CHECK` en rangos y enumeraciones
- [ ] `ON DELETE CASCADE/RESTRICT` según la lógica de negocio
