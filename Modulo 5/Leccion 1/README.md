# Módulo 5 – Lección 1: Consultas SQL con Filtros y Patrones

## Objetivo
Practicar consultas SQL usando `WHERE`, operadores de comparación, patrones con `LIKE`/`ILIKE`, operadores lógicos (`AND`, `OR`, `NOT`) y rangos con `BETWEEN`.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `setup.sql` | Crea la tabla `clientes` e inserta datos de prueba |
| `consultas.sql` | Las 8 consultas requeridas (R1 a R8) más ejercicios bonus |

---

## Cómo ejecutar

### Opción A – pgAdmin (interfaz gráfica)
1. Abre pgAdmin y conéctate a tu servidor PostgreSQL.
2. Clic derecho en tu base de datos → **Query Tool**.
3. Abre `setup.sql` → clic en **▶ Execute** (F5).
4. Abre `consultas.sql` → selecciona cada consulta y presiona **F5**.

### Opción B – psql (terminal)
```bash
# Conectarse a la base de datos
psql -U postgres -d nombre_base_de_datos

# Ejecutar el archivo de setup
\i /ruta/completa/setup.sql

# Ejecutar las consultas
\i /ruta/completa/consultas.sql
```

### Opción C – ejecutar por partes en psql
```sql
-- Pegar y ejecutar cada bloque manualmente en la consola
```

---

## Tabla utilizada: `clientes`

| Columna | Tipo | Restricción | Descripción |
|---|---|---|---|
| `rut` | `VARCHAR(12)` | PRIMARY KEY | Identificador único, formato chileno |
| `nombre` | `VARCHAR(20)` | NOT NULL | Nombre del cliente |
| `edad` | `INTEGER` | NOT NULL | Edad en años |

### Datos de prueba insertados

| rut | nombre | edad |
|---|---|---|
| 13133133-3 | Mario | 30 |
| 13456789-0 | Pato | 45 |
| 13987654-1 | Pedro | 22 |
| 14111222-3 | Patricia | 38 |
| 14333444-5 | Diego | 27 |
| 15555666-7 | Ana | 19 |
| 15777888-9 | Paula | 50 |
| 16999000-1 | Pepa | 65 |
| 21111222-3 | Mario | 55 |
| 21333444-5 | Carlos | 42 |
| 22555666-7 | Rosa | 33 |
| 22777888-9 | Laura | 29 |

---

## Las 8 Consultas

### R1 – Filtro exacto por rut
```sql
SELECT * FROM clientes
WHERE rut = '13133133-3';
```
**Resultado esperado:** 1 fila → Mario, 30 años.

**Concepto:** El operador `=` compara valores exactos. En ruts (VARCHAR) el valor debe ir entre comillas simples `'...'`.

---

### R2 – Clientes mayores de 25 años
```sql
SELECT * FROM clientes
WHERE edad > 25
ORDER BY edad;
```
**Resultado esperado:** Todos excepto Pedro (22) y Ana (19).

**Operadores de comparación:**
| Operador | Significado |
|---|---|
| `>` | Mayor que (excluye el valor) |
| `>=` | Mayor o igual que (incluye el valor) |
| `<` | Menor que |
| `<=` | Menor o igual que |
| `=` | Igual |
| `<>` o `!=` | Distinto |

---

### R3 – Clientes que NO se llamen Mario
```sql
SELECT * FROM clientes
WHERE nombre NOT ILIKE 'mario';
```
**Resultado esperado:** Todos excepto los dos Mario (ID 13133133-3 y 21111222-3).

**`ILIKE` vs `LIKE` en PostgreSQL:**
| Operador | Sensible a mayúsculas |
|---|---|
| `LIKE` | Sí → `'mario'` ≠ `'Mario'` |
| `ILIKE` | No → `'mario'` = `'Mario'` = `'MARIO'` |

`NOT ILIKE` es la negación: excluye las filas que coincidan con el patrón.

---

### R4 – Rut que empieza en '13'
```sql
SELECT * FROM clientes
WHERE rut LIKE '13%';
```
**Resultado esperado:** Mario (13133133-3), Pato (13456789-0), Pedro (13987654-1).

**Comodines de `LIKE`:**
| Patrón | Significado | Ejemplo |
|---|---|---|
| `'13%'` | Empieza con `13` | `13456789-0` ✓ |
| `'%1'` | Termina con `1` | `13987654-1` ✓ |
| `'%ar%'` | Contiene `ar` | `Carlos` ✓ |
| `'_a%'` | Segundo carácter es `a` | `Laura` ✓ |

(`%` = cero o más caracteres, `_` = exactamente un carácter)

---

### R5 – Nombre finalizado en 'a'
```sql
SELECT * FROM clientes
WHERE nombre ILIKE '%a';
```
**Resultado esperado:** Ana, Patricia, Paula, Rosa, Laura.

**Nota:** Se usa `ILIKE` para que encuentre también nombres con 'A' mayúscula al final.

---

### R6 – Nombre empieza en 'P' Y edad > 34
```sql
SELECT * FROM clientes
WHERE nombre ILIKE 'P%'
  AND edad > 34;
```
**Resultado esperado:** Pato (45), Paula (50), Pepa (65).

**`AND` — tabla de verdad:**
| Condición 1 | Condición 2 | Resultado |
|---|---|---|
| TRUE | TRUE | **TRUE** (la fila aparece) |
| TRUE | FALSE | FALSE |
| FALSE | TRUE | FALSE |
| FALSE | FALSE | FALSE |

Ambas condiciones deben ser verdaderas para que la fila se incluya.

---

### R7 – Rut empieza en '1', nombre NO empieza en 'M', edad < 40
```sql
SELECT * FROM clientes
WHERE rut    LIKE '1%'
  AND nombre NOT ILIKE 'M%'
  AND edad < 40;
```
**Resultado esperado:** Pato (13, 45→excluido por edad), Pedro (22), Patricia (38), Diego (27), Ana (19→excluido por rut).

Verificando contra los datos:
- `14333444-5` Diego 27 → rut empieza en 1 ✓, no empieza en M ✓, edad 27 < 40 ✓ → aparece
- `14111222-3` Patricia 38 → ✓✓✓ → aparece
- `13987654-1` Pedro 22 → ✓✓✓ → aparece

---

### R8 – Condición compuesta con OR, IN y BETWEEN
```sql
SELECT * FROM clientes
WHERE (rut LIKE '13%' OR rut LIKE '%1')
  AND nombre IN ('Diego', 'Mario', 'Pato', 'Pepa')
  AND edad BETWEEN 20 AND 80;
```

**`IN (lista)`** — equivale a:
```sql
WHERE nombre = 'Diego' OR nombre = 'Mario' OR nombre = 'Pato' OR nombre = 'Pepa'
```

**`BETWEEN a AND b`** — equivale a:
```sql
WHERE edad >= 20 AND edad <= 80
```
Ambos extremos son **inclusivos**.

**Paréntesis para priorizar `OR`:**
Sin paréntesis, `AND` tiene mayor precedencia que `OR`, lo que cambiaría el resultado. Los paréntesis fuerzan que la condición del `rut` se evalúe primero como grupo.

---

## Resumen de operadores

| Operador | Tipo | Ejemplo |
|---|---|---|
| `=` | Igualdad | `WHERE rut = '13133133-3'` |
| `<>` / `!=` | Desigualdad | `WHERE nombre <> 'Mario'` |
| `>` `<` `>=` `<=` | Comparación numérica | `WHERE edad > 25` |
| `LIKE` | Patrón (sensible a mayúsculas) | `WHERE rut LIKE '13%'` |
| `ILIKE` | Patrón (insensible a mayúsculas) | `WHERE nombre ILIKE 'p%'` |
| `NOT ILIKE` | Negación de patrón | `WHERE nombre NOT ILIKE 'mario'` |
| `AND` | Todas las condiciones deben cumplirse | `WHERE edad > 25 AND nombre ILIKE 'P%'` |
| `OR` | Al menos una condición debe cumplirse | `WHERE rut LIKE '13%' OR rut LIKE '%1'` |
| `IN (...)` | El valor está en la lista | `WHERE nombre IN ('Diego','Pato')` |
| `BETWEEN a AND b` | Rango inclusivo | `WHERE edad BETWEEN 20 AND 80` |
| `ORDER BY col ASC/DESC` | Ordenar resultado | `ORDER BY edad DESC` |

---

## Errores frecuentes

| Error | Causa | Solución |
|---|---|---|
| `column "rut" does not exist` | La tabla no fue creada | Ejecutar `setup.sql` primero |
| No devuelve resultados esperados | Usar `LIKE` en vez de `ILIKE` | Cambiar a `ILIKE` para ignorar mayúsculas |
| Error de sintaxis en `BETWEEN` | Escribir `BETWEEN 80 AND 20` | El menor siempre va primero |
| El `OR` no funciona como se espera | Falta de paréntesis | Agrupar con `()` las condiciones con `OR` |
