# Módulo 5 – Lección 3: SQL Llaves, DDL/DML y Agregación con JOIN

## Objetivo
Crear tablas con restricciones de integridad (`PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `CASCADE`), manejar datos con `UPDATE` y `DELETE`, y escribir consultas avanzadas que combinen dos tablas con `JOIN`, `GROUP BY` y `HAVING`.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `setup.sql` | DDL (tablas + secuencias) + DML (inserts, UPDATE, DELETE) |
| `consultas.sql` | Consultas Q3 a Q7 con resultados esperados y explicaciones |

---

## Estructura de las tablas

```
Clientes (tabla PADRE)          Cuentas (tabla HIJA)
───────────────────────         ───────────────────────────────
id_cliente  PK                  id_cuenta  PK
nombre      NOT NULL            id_cliente FK → Clientes.id_cliente
edad        CHECK 18–85         saldo      CHECK -5000 a 100000
```

**Relación:** un cliente puede tener **múltiples** cuentas (1:N).

---

## Conceptos DDL nuevos

### PRIMARY KEY
```sql
id_cliente INT PRIMARY KEY
```
- Identifica de forma **única** cada fila.
- No puede ser `NULL`.
- Cada tabla solo puede tener una PK.

### FOREIGN KEY
```sql
CONSTRAINT fk_cliente
    FOREIGN KEY (id_cliente)
    REFERENCES Clientes(id_cliente)
    ON DELETE CASCADE
    ON UPDATE CASCADE
```
- Garantiza que `id_cliente` en `Cuentas` **siempre exista** en `Clientes`.
- Impide insertar una cuenta con un `id_cliente` que no exista.

### CASCADE
| Tipo | Qué pasa |
|---|---|
| `ON DELETE CASCADE` | Si se borra un cliente, sus cuentas se borran automáticamente |
| `ON UPDATE CASCADE` | Si cambia el `id_cliente` del padre, se actualiza en las cuentas |

### CHECK
```sql
edad INT CHECK (edad BETWEEN 18 AND 85)
saldo NUMERIC(10,2) CHECK (saldo BETWEEN -5000.00 AND 100000.00)
```
Si se intenta insertar un valor fuera del rango, PostgreSQL devuelve error.

### SEQUENCE
```sql
CREATE SEQUENCE seq_cliente_id START WITH 1 INCREMENT BY 1;
-- Uso: nextval('seq_cliente_id') → 1, luego 2, luego 3...
```
Alternativa moderna en PostgreSQL: `GENERATED ALWAYS AS IDENTITY`.

---

## Estado de los datos tras el DML

### UPDATE: cuenta 402 de Carlos +500
```sql
UPDATE Cuentas SET saldo = saldo + 500.00 WHERE id_cuenta = 402;
-- 2000.00 + 500.00 = 2500.00
```

### DELETE: eliminar cuenta 503 de Elena (900.00)
```sql
DELETE FROM Cuentas WHERE id_cuenta = 503;
```

### Tabla final (14 cuentas)

| id_cuenta | Cliente | Saldo |
|---|---|---|
| 101 | Ana García | 50.000,00 |
| 102 | Ana García | -1.200,50 |
| 103 | Ana García | 100,00 |
| 201 | Luis Pérez | 850,75 |
| 202 | Luis Pérez | -500,00 |
| 301 | Maria Soto | 15.000,00 |
| 302 | Maria Soto | 200,00 |
| 303 | Maria Soto | -4.999,99 |
| 304 | Maria Soto | 75.000,00 |
| 401 | Carlos Ruiz | 1.000,00 |
| 402 | Carlos Ruiz | **2.500,00** ← actualizado |
| 403 | Carlos Ruiz | 3.000,00 |
| 501 | Elena Torres | 50,00 |
| 502 | Elena Torres | 120,00 |
| ~~503~~ | ~~Elena Torres~~ | ~~900,00~~ ← eliminado |

---

## Las 5 Consultas (Q3–Q7)

### Q3 – Cuentas del cliente de mayor edad
```sql
SELECT cu.id_cuenta, cl.nombre, cu.saldo
FROM Cuentas cu
JOIN Clientes cl ON cu.id_cliente = cl.id_cliente
WHERE cl.edad = (SELECT MAX(edad) FROM Clientes)
ORDER BY cu.id_cuenta;
```
**Resultado:** Carlos Ruiz (80 años) → cuentas 401 ($1.000), 402 ($2.500), 403 ($3.000)

**Cómo funciona el JOIN:**
```
Clientes              Cuentas
──────────            ───────────────────────
id=4, Carlos, 80  ←─  id_cuenta=401, id_cliente=4, saldo=1000
                  ←─  id_cuenta=402, id_cliente=4, saldo=2500
                  ←─  id_cuenta=403, id_cliente=4, saldo=3000
```

---

### Q4 – Promedio de edad de clientes con saldo negativo
```sql
SELECT ROUND(AVG(cl.edad), 2) AS "Promedio edad"
FROM Clientes cl
WHERE cl.id_cliente IN (
    SELECT DISTINCT id_cliente FROM Cuentas WHERE saldo < 0
);
```
**Clientes con saldo negativo:** Ana(78), Luis(25), Maria(40)

**Cálculo:** (78 + 25 + 40) / 3 = **47.67**

`DISTINCT` en la subconsulta evita que Maria (que tiene 2 cuentas negativas) se cuente dos veces.

---

### Q5 – Nombre y cantidad de cuentas (más de una)
```sql
SELECT cl.nombre, COUNT(cu.id_cuenta) AS cantidad_cuentas
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY cantidad_cuentas DESC;
```
**Resultado:** Maria(4), Ana(3), Carlos(3), Luis(2), Elena(2)

**`WHERE` vs `HAVING`:**
| | `WHERE` | `HAVING` |
|---|---|---|
| Filtra | Filas individuales | Grupos (después del GROUP BY) |
| Cuándo | Antes de agrupar | Después de agrupar |
| Puede usar | Columnas | Funciones de agregación |

---

### Q6 – Saldo combinado por cliente (más de una cuenta)
```sql
SELECT cl.nombre, SUM(cu.saldo) AS saldo_combinado
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING COUNT(cu.id_cuenta) > 1
ORDER BY saldo_combinado DESC;
```
**Cálculos:**
| Cliente | Sumas | Total |
|---|---|---|
| Maria | 15000 + 200 + (-4999.99) + 75000 | **85.200,01** |
| Ana | 50000 + (-1200.50) + 100 | **48.899,50** |
| Carlos | 1000 + 2500 + 3000 | **6.500,00** |
| Luis | 850.75 + (-500) | **350,75** |
| Elena | 50 + 120 | **170,00** |

---

### Q7 – Clientes con al menos una cuenta negativa + saldo total
```sql
SELECT cl.nombre, SUM(cu.saldo) AS saldo_combinado
FROM Clientes cl
JOIN Cuentas cu ON cl.id_cliente = cu.id_cliente
GROUP BY cl.id_cliente, cl.nombre
HAVING MIN(cu.saldo) < 0
ORDER BY saldo_combinado DESC;
```
**Por qué `HAVING MIN(saldo) < 0`:** si el saldo mínimo de un cliente es negativo, significa que tiene al menos una cuenta negativa. Carlos y Elena quedan excluidos porque todos sus saldos son positivos.

**Resultado:**
| Cliente | Saldo combinado |
|---|---|
| Maria Soto | 85.200,01 |
| Ana García | 48.899,50 |
| Luis Pérez | 350,75 |

---

## Resumen de conceptos nuevos

| Concepto | Sintaxis | Qué hace |
|---|---|---|
| `PRIMARY KEY` | `id INT PRIMARY KEY` | Identifica filas únicas, no admite NULL |
| `FOREIGN KEY` | `FOREIGN KEY (col) REFERENCES Tabla(pk)` | Garantiza integridad referencial |
| `CHECK` | `CHECK (col BETWEEN a AND b)` | Restringe los valores aceptados |
| `ON DELETE CASCADE` | En la FK | Borra hijos al borrar el padre |
| `CREATE SEQUENCE` | `START WITH 1 INCREMENT BY 1` | Genera IDs automáticos |
| `JOIN ... ON` | `JOIN Tabla ON t1.col = t2.col` | Combina filas de dos tablas |
| `GROUP BY` | `GROUP BY col` | Agrupa filas con el mismo valor |
| `HAVING` | `HAVING COUNT(*) > 1` | Filtra grupos por condición |
| `COUNT(col)` | En SELECT + GROUP BY | Cuenta filas del grupo |
| `MIN(col)` | En SELECT o HAVING | Valor mínimo del grupo |

---

## Error clásico: diferencia entre WHERE y HAVING

```sql
-- ✗ INCORRECTO: WHERE no puede usar COUNT()
SELECT nombre, COUNT(*) FROM Clientes
JOIN Cuentas ... GROUP BY nombre
WHERE COUNT(*) > 1;     -- ERROR de sintaxis

-- ✓ CORRECTO: HAVING filtra después de agrupar
SELECT nombre, COUNT(*) FROM Clientes
JOIN Cuentas ... GROUP BY nombre
HAVING COUNT(*) > 1;    -- funciona correctamente
```
