# Módulo 5 – Lección 4: SQL DDL/DML – Sistema de Facturas

## Objetivo
Crear un esquema relacional de 4 tablas, cargar datos y aplicar modificaciones de esquema (`ALTER TABLE`) y de datos (`UPDATE`, `DELETE`). Consultar información combinando múltiples tablas con `JOIN` y calcular totales con `GROUP BY`.

---

## Archivos del proyecto

| Archivo | Contenido |
|---|---|
| `setup.sql` | P1 a P9: DDL (tablas) + DML (inserts, updates, alter, drop) |
| `consultas.sql` | P10 a P12: consultas con JOIN y borrado final |

---

## Diagrama de tablas (del PDF)

```
facturas                  detalle_facturas            productos           existencias
────────────────          ──────────────────────      ──────────────      ──────────────────
id         SERIAL PK      id         SERIAL PK        id    SERIAL PK     id         SERIAL PK
rut_comprador VARCHAR     id_producto INT FK ──────→  nombre VARCHAR       id_producto INT FK ──→ productos
rut_vendedor  VARCHAR     id_factura  INT FK ──→       descripcion          cantidad   INTEGER
fecha DATE (P7)           (facturas)                                        precio     INTEGER
                                                                            pesoKg     INTEGER ← se elimina en P9
```

**Relaciones:**
- Una factura puede tener **múltiples líneas** de detalle (1:N)
- Un producto puede aparecer en **múltiples detalles** (1:N)
- Un producto tiene **una existencia** (1:1)

---

## Los 12 Puntos

### P1 – Crear tablas con SERIAL y FK CASCADE
```sql
CREATE TABLE productos (
    id          SERIAL        PRIMARY KEY,
    nombre      VARCHAR(255)  NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE existencias (
    id          SERIAL   PRIMARY KEY,
    id_producto INTEGER  NOT NULL,
    cantidad    INTEGER  NOT NULL DEFAULT 0,
    precio      INTEGER  NOT NULL,
    pesoKg      INTEGER,
    CONSTRAINT fk_exist_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id)
        ON DELETE CASCADE
);
```

**`SERIAL` en PostgreSQL:**
- Equivale a `INTEGER` + secuencia automática.
- El motor asigna 1, 2, 3... automáticamente al insertar.
- No hace falta especificar el valor del ID en el `INSERT`.

---

### P2 y P3 – Insertar productos y existencias
```sql
-- Sin especificar "id" porque SERIAL lo genera solo
INSERT INTO productos (nombre, descripcion) VALUES ('Laptop Dell', '...');

-- Las existencias referencian el id del producto (1, 2, 3...)
INSERT INTO existencias (id_producto, cantidad, precio, pesoKg) VALUES (1, 5, 599990, 2);
```

---

### P4 y P5 – Facturas y detalle

Los datos de prueba insertan:

| Factura | Productos | Total aproximado |
|---|---|---|
| 1 | Laptop, Mouse, Teclado, Monitor | $904.960 |
| 2 | Mouse, Audífonos, Webcam | $224.970 |
| 3 | Laptop, Teclado, SSD, RAM, Silla | $1.129.950 |
| 4 | Monitor, Webcam, Alfombrilla | $269.970 |
| 5 | Mouse, Teclado, Audífonos, SSD | $344.960 |

---

### P6 – UPDATE masivo (sin WHERE)
```sql
UPDATE existencias SET cantidad = 10;
```
Sin `WHERE`, el `UPDATE` afecta **todas** las filas. Aquí es intencional: reponer stock a 10 para todos los productos.

---

### P7 y P8 – ALTER TABLE ADD COLUMN y UPDATE por fila
```sql
-- P7: agregar la columna (llega NULL en todas las filas existentes)
ALTER TABLE facturas ADD COLUMN fecha DATE;

-- P8: actualizar cada factura individualmente con su fecha
UPDATE facturas SET fecha = '2025-01-15' WHERE id = 1;
UPDATE facturas SET fecha = '2025-02-03' WHERE id = 2;
-- ...
```

**`ALTER TABLE` — operaciones comunes:**
| Operación | Sintaxis |
|---|---|
| Agregar columna | `ALTER TABLE t ADD COLUMN col TIPO` |
| Eliminar columna | `ALTER TABLE t DROP COLUMN col` |
| Cambiar tipo | `ALTER TABLE t ALTER COLUMN col TYPE nuevo_tipo` |
| Renombrar columna | `ALTER TABLE t RENAME COLUMN viejo TO nuevo` |

---

### P9 – ALTER TABLE DROP COLUMN
```sql
ALTER TABLE existencias DROP COLUMN pesoKg;
```
Esta operación **elimina la columna y todos sus datos**. Es irreversible.

---

### P10 – Consulta con 3 JOINs
```sql
SELECT f.id, f.fecha, f.rut_comprador,
       p.nombre, e.precio
FROM facturas f
JOIN detalle_facturas df ON df.id_factura  = f.id
JOIN productos        p  ON p.id           = df.id_producto
JOIN existencias      e  ON e.id_producto  = p.id
WHERE f.id = 1
ORDER BY p.nombre;
```

**Cadena de JOINs:**
```
facturas ──(id=id_factura)──→ detalle_facturas ──(id_producto=id)──→ productos
                                                                            │
                                              ←──(id=id_producto)── existencias
```

---

### P11 – Total de una factura con SUM + GROUP BY
```sql
SELECT f.id, f.fecha, COUNT(df.id) AS items, SUM(e.precio) AS total
FROM facturas f
JOIN detalle_facturas df ON df.id_factura = f.id
JOIN productos        p  ON p.id          = df.id_producto
JOIN existencias      e  ON e.id_producto = p.id
WHERE f.id = 1
GROUP BY f.id, f.fecha, f.rut_comprador;
```

**Cálculo Factura 1:**
```
Laptop Dell:      599.990
Mouse Logitech:    24.990
Teclado Mecánico:  79.990
Monitor Samsung:  199.990
──────────────────────────
TOTAL:            904.960
```

---

### P12 – DELETE con CASCADE en cadena
```sql
DELETE FROM productos;   -- borra las 10 filas
```
Gracias a `ON DELETE CASCADE`:
- → borra las 10 filas de `existencias` automáticamente
- → borra las 19 filas de `detalle_facturas` automáticamente
- `facturas` **no se borra** (no depende de productos)

**Sin CASCADE** el `DELETE` fallaría con error de FK constraint.

---

## Diferencia entre DDL y DML

| Categoría | Comandos | Qué modifica |
|---|---|---|
| **DDL** (Data Definition) | `CREATE`, `ALTER`, `DROP` | La **estructura** (tablas, columnas, tipos) |
| **DML** (Data Manipulation) | `INSERT`, `UPDATE`, `DELETE` | Los **datos** dentro de las tablas |
| **DQL** (Data Query) | `SELECT` | Solo **consulta**, no modifica nada |

---

## Errores frecuentes

| Error | Causa | Solución |
|---|---|---|
| `violates foreign key constraint` en INSERT | El `id_producto` no existe en `productos` | Insertar productos primero (P2 antes de P3/P5) |
| `violates foreign key constraint` en DELETE | Intentar borrar producto que tiene existencias sin CASCADE | Agregar `ON DELETE CASCADE` o borrar hijos primero |
| `column "pesokgg" of relation does not exist` | Nombre de columna incorrecto | Verificar con `\d existencias` en psql |
| `null value in column violates not-null constraint` | `INSERT` omite columna `NOT NULL` | Incluir todas las columnas `NOT NULL` en el INSERT |
