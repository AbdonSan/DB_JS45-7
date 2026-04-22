# Módulo 5 – Lección 2.2: Catálogo Netflix con SQL

## Objetivo
Practicar `INSERT` masivo, funciones de agregación (`MIN`, `MAX`, `AVG`, `ROUND`), filtros con `IN`/`NOT IN`, `DELETE`, `BETWEEN`, patrones `ILIKE` y operaciones aritméticas entre columnas dentro del `WHERE`.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `setup.sql` | Crea la tabla `serie_netflix` con el registro inicial (Black Mirror) |
| `consultas.sql` | Las 14 consultas comentadas con resultados esperados |

---

## Estructura de la tabla

```sql
CREATE TABLE serie_netflix (
    nombre       VARCHAR   PRIMARY KEY,  -- nombre de la serie
    temporadas   INTEGER,                -- número de temporadas
    genero       VARCHAR(50),            -- género principal
    anio_estreno INTEGER                 -- año de estreno
);
```

### Datos completos tras Q1 (10 series)

| nombre | temporadas | genero | anio_estreno |
|---|---|---|---|
| Friends | 10 | Comedia | 1994 |
| Breaking Bad | 5 | Drama/Crimen | 2008 |
| Black Mirror | 5 | Ciencia ficción | 2011 |
| Narcos | 3 | Crimen/Drama | 2015 |
| Stranger Things | 4 | Terror/Ciencia ficción | 2016 |
| The Crown | 6 | Drama histórico | 2016 |
| Dark | 3 | Ciencia ficción/Misterio | 2017 |
| Money Heist | 5 | Acción/Crimen | 2017 |
| Ozark | 4 | Drama/Crimen | 2017 |
| Squid Game | 2 | Terror/Drama | 2021 |

---

## Las 14 Consultas

### Q1 – Insertar 9 series adicionales
```sql
INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Breaking Bad', 5, 'Drama/Crimen', 2008);
-- (repetir para cada serie)
```
Alternativa compacta (multi-fila):
```sql
INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno) VALUES
    ('Breaking Bad', 5, 'Drama/Crimen', 2008),
    ('Stranger Things', 4, 'Terror/Ciencia ficción', 2016),
    ...;
```

---

### Q2 – Más de 3 temporadas, orden descendente por año
```sql
SELECT nombre, temporadas, anio_estreno
FROM serie_netflix
WHERE temporadas > 3
ORDER BY anio_estreno DESC;
```
**Resultado:** Ozark, Money Heist (2017), The Crown, Stranger Things (2016), Black Mirror (2011), Breaking Bad (2008), Friends (1994).

`ORDER BY col DESC` ordena de **mayor a menor** (más reciente primero).

---

### Q3 y Q4 – Serie más antigua / más nueva
```sql
SELECT MIN(anio_estreno) AS "Año más antiguo" FROM serie_netflix;  -- 1994
SELECT MAX(anio_estreno) AS "Año más nuevo"   FROM serie_netflix;  -- 2021
```

| Función | Qué devuelve |
|---|---|
| `MIN(col)` | El valor más bajo de la columna |
| `MAX(col)` | El valor más alto de la columna |

---

### Q5 – Promedio del año de estreno
```sql
SELECT ROUND(AVG(anio_estreno), 0) AS "Promedio año estreno"
FROM serie_netflix;
```
**Cálculo:** (2011+2008+2016+2015+2016+2017+2017+2021+1994+2017) / 10 = **2013**

`ROUND(número, decimales)` redondea al número de decimales indicado.

---

### Q6 – Promedio de temporadas
```sql
SELECT ROUND(AVG(temporadas), 1) AS "Promedio temporadas"
FROM serie_netflix;
```
**Cálculo:** (5+5+4+3+6+3+5+2+10+4) / 10 = **4.7**

---

### Q7 – Series con IN (lista de valores)
```sql
SELECT nombre, temporadas
FROM serie_netflix
WHERE temporadas IN (1, 2, 4, 5, 7)
ORDER BY temporadas;
```
**Resultado:** Squid Game(2), Stranger Things(4), Ozark(4), Black Mirror(5), Breaking Bad(5), Money Heist(5).

`IN (lista)` es equivalente a múltiples `OR`:
```sql
-- Estas dos consultas son idénticas:
WHERE temporadas IN (1, 2, 4, 5, 7)
WHERE temporadas = 1 OR temporadas = 2 OR temporadas = 4 OR temporadas = 5 OR temporadas = 7
```

---

### Q8 – Series con NOT IN
```sql
SELECT nombre, temporadas
FROM serie_netflix
WHERE temporadas NOT IN (1, 2, 4, 5, 7)
ORDER BY temporadas;
```
**Resultado:** Narcos(3), Dark(3), The Crown(6), Friends(10).

---

### Q9 – DELETE con condición
```sql
DELETE FROM serie_netflix
WHERE anio_estreno > 2010;
```

| | |
|---|---|
| Series eliminadas (8) | Black Mirror, Stranger Things, Narcos, The Crown, Dark, Money Heist, Squid Game, Ozark |
| Series que permanecen (2) | Breaking Bad (2008), Friends (1994) |

> **Regla crítica:** el `WHERE` en un `DELETE` es obligatorio. Sin él se borran **todas** las filas de la tabla.

---

### Q10 – Reinsertar los datos borrados
```sql
INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno) VALUES
    ('Black Mirror',    5, 'Ciencia ficción',          2011),
    ('Stranger Things', 4, 'Terror/Ciencia ficción',   2016),
    -- ... resto de las series
    ('Ozark',           4, 'Drama/Crimen',             2017);
```
Se puede usar la forma multi-fila para insertar varios registros en una sola instrucción `INSERT`.

---

### Q11 – INSERT de Doctor House
```sql
INSERT INTO serie_netflix (nombre, temporadas, genero, anio_estreno)
VALUES ('Doctor House', 8, 'Drama médico', 2004);
```
**¿Y si ya existiera?** Como `nombre` es la PRIMARY KEY, un `INSERT` con el mismo nombre daría error. En ese caso se usaría un nombre alternativo (`'House MD'`) o se borraría el registro anterior con `DELETE`.

---

### Q12 – BETWEEN (rango inclusivo)
```sql
SELECT nombre, anio_estreno
FROM serie_netflix
WHERE anio_estreno BETWEEN 2005 AND 2020
ORDER BY anio_estreno;
```
**Equivalente a:** `WHERE anio_estreno >= 2005 AND anio_estreno <= 2020`

**Excluidas:** Friends(1994), Doctor House(2004), Squid Game(2021).

---

### Q13 – ILIKE con OR (empieza en B o termina en e)
```sql
SELECT nombre
FROM serie_netflix
WHERE nombre ILIKE 'B%'
   OR nombre ILIKE '%e'
ORDER BY nombre;
```
**Resultado:**
| nombre | Razón |
|---|---|
| Black Mirror | Empieza en B |
| Breaking Bad | Empieza en B |
| Squid Game | Termina en e |

**Comodines de LIKE / ILIKE:**
| Patrón | Significado |
|---|---|
| `'B%'` | Empieza con B |
| `'%e'` | Termina con e |
| `'%mirror%'` | Contiene "mirror" en cualquier posición |
| `'_lack%'` | Un carácter cualquiera seguido de "lack..." |

---

### Q14 – Operación aritmética entre columnas en WHERE
```sql
SELECT nombre, anio_estreno, temporadas,
       (anio_estreno + temporadas) AS "Suma año+temporadas"
FROM serie_netflix
WHERE (anio_estreno + temporadas) > 2010
ORDER BY (anio_estreno + temporadas);
```

**Verificación completa:**
| Serie | Año | Temporadas | Suma | > 2010? |
|---|---|---|---|---|
| Friends | 1994 | 10 | 2004 | ✗ |
| Doctor House | 2004 | 8 | 2012 | ✓ |
| Breaking Bad | 2008 | 5 | 2013 | ✓ |
| Black Mirror | 2011 | 5 | 2016 | ✓ |
| Narcos | 2015 | 3 | 2018 | ✓ |
| Stranger Things | 2016 | 4 | 2020 | ✓ |
| The Crown | 2016 | 6 | 2022 | ✓ |
| Dark | 2017 | 3 | 2020 | ✓ |
| Money Heist | 2017 | 5 | 2022 | ✓ |
| Ozark | 2017 | 4 | 2021 | ✓ |
| Squid Game | 2021 | 2 | 2023 | ✓ |

Solo **Friends** queda excluida (2004 ≤ 2010).

---

## Resumen de comandos nuevos

| Comando | Qué hace |
|---|---|
| `MIN(col)` | Valor mínimo de la columna |
| `MAX(col)` | Valor máximo de la columna |
| `ROUND(val, n)` | Redondea a `n` decimales |
| `ORDER BY col DESC` | Ordena de mayor a menor |
| `IN (a, b, c)` | Igual a `col=a OR col=b OR col=c` |
| `NOT IN (a, b, c)` | Excluye los valores de la lista |
| `DELETE FROM ... WHERE` | Elimina filas que cumplen la condición |
| `BETWEEN a AND b` | Rango inclusivo (>= a y <= b) |
| `col1 + col2` en WHERE | Operación aritmética sobre columnas |

---

## Errores frecuentes

| Error | Causa | Solución |
|---|---|---|
| `duplicate key value` en Q11 | Ya existe una serie con ese nombre (PK) | Usar nombre distinto o borrar el anterior |
| `DELETE` borra toda la tabla | Olvidar el `WHERE` | Siempre escribir el `WHERE` antes de ejecutar |
| `BETWEEN 2020 AND 2005` | El menor debe ir primero | `BETWEEN 2005 AND 2020` |
| `LIKE 'b%'` no encuentra 'Black' | LIKE es sensible a mayúsculas | Usar `ILIKE` en PostgreSQL |
