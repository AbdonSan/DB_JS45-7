# Módulo 4 – Lección 3: Manipulación del DOM

## Objetivo
Aprender a interactuar con el DOM (Document Object Model) usando JavaScript: leer valores de inputs, modificar contenido de elementos y cambiar estilos desde el código.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página con los 4 formularios de ejercicio |
| `app.js` | Las 4 funciones: `repetir()`, `aplicarColor()`, `calcular()`, `invertir()` |

---

## ¿Qué es el DOM?
El DOM (Document Object Model) es la representación en memoria de todos los elementos HTML de una página. JavaScript puede acceder a ellos, leerlos y modificarlos en tiempo real sin recargar la página.

```
HTML en disco               DOM en memoria (árbol)
─────────────               ──────────────────────
<body>                      document
  <div id="salida">           └── body
  </div>                          └── div#salida
</body>
```

---

## Ejercicio 1 – REPETIR

### ¿Qué hace?
Lee una palabra y un número de repeticiones, y muestra la palabra repetida esa cantidad de veces.

### Código clave
```js
const palabra = document.getElementById("palabra").value;
const veces   = parseInt(document.getElementById("veces").value);
const resultado = (palabra + " ").repeat(veces).trim();
document.getElementById("salida-repetir").innerHTML = resultado;
```

### Métodos usados
| Método | Qué hace |
|---|---|
| `getElementById("id")` | Busca y devuelve el elemento HTML con ese `id` |
| `.value` | Lee el texto actual de un `<input>` |
| `String.repeat(n)` | Repite un string `n` veces: `"ab".repeat(3)` → `"ababab"` |
| `.trim()` | Elimina espacios al inicio y al final del string |
| `.innerHTML` | Escribe contenido HTML dentro de un elemento |

### Ejemplo
```
Entrada:  palabra = "Hola"  |  veces = 4
Proceso:  ("Hola ").repeat(4).trim()
Salida:   "Hola Hola Hola Hola"
```

---

## Ejercicio 2 – APLICAR COLOR

### ¿Qué hace?
Toma el color elegido en un `<input type="color">` y lo aplica como fondo del párrafo.

### Código clave
```js
const color = document.getElementById("color").value;
document.getElementById("parrafo-color").style.backgroundColor = color;
```

### Métodos usados
| Método/Propiedad | Qué hace |
|---|---|
| `input type="color"` | Abre el selector de color del navegador. Devuelve un valor hexadecimal como `"#00ff00"` |
| `.style.backgroundColor` | Cambia el color de fondo del elemento desde JavaScript |

### Relación CSS → JavaScript
Cuando accedes a estilos desde JS, los nombres en CSS con guión se escriben en **camelCase**:

| CSS | JavaScript |
|---|---|
| `background-color` | `.style.backgroundColor` |
| `font-size` | `.style.fontSize` |
| `border-radius` | `.style.borderRadius` |

---

## Ejercicio 3 – CALCULAR

### ¿Qué hace?
Lee dos números y muestra las 4 operaciones básicas más la suma de todos los resultados.

### Código clave
```js
const n1 = parseFloat(document.getElementById("num1").value);
const n2 = parseFloat(document.getElementById("num2").value);

const suma  = n1 + n2;
const resta = n1 - n2;
const multi = n1 * n2;
const divi  = n2 !== 0 ? n1 / n2 : "indefinida";

const total = suma + resta + multi + divi;

document.getElementById("salida-calcular").innerHTML = `
    <p>${n1} + ${n2} = ${suma}</p>
    <p>${n1} - ${n2} = ${resta}</p>
    ...
`;
```

### Métodos usados
| Método | Qué hace |
|---|---|
| `parseFloat()` | Convierte texto a número decimal |
| `isNaN()` | Devuelve `true` si el valor no es un número |
| Template literals `` ` `` | Permite incrustar variables con `${...}` dentro de strings |
| Operador ternario `? :` | Forma compacta de `if/else`: `condición ? siTrue : siFalse` |

### Ejemplo con 5 y 10
```
5 + 10 = 15
5 - 10 = -5
5 * 10 = 50
5 / 10 = 0.5
──────────────
Total  = 60.5
```

---

## Ejercicio 4 – INVERTIR

### ¿Qué hace?
Lee una cadena de texto y muestra cada carácter en orden inverso.

### Código clave
```js
const texto     = document.getElementById("texto-invertir").value;
const invertido = texto.split("").reverse().join("");
document.getElementById("salida-invertir").innerHTML = invertido;
```

### Los 3 métodos encadenados
```
"Holanda que talca"
      ↓ split("")
["H","o","l","a","n","d","a"," ","q","u","e"," ","t","a","l","c","a"]
      ↓ reverse()
["a","c","l","a","t"," ","e","u","q"," ","a","d","n","a","l","o","H"]
      ↓ join("")
"aclat euq adnaloH"
```

| Método | Qué hace |
|---|---|
| `split("")` | Convierte el string en array de caracteres individuales |
| `reverse()` | Invierte el orden del array (modifica el array original) |
| `join("")` | Une todos los elementos del array de vuelta en un string |

### Encadenamiento de métodos
Estos tres métodos se pueden escribir en una sola línea porque cada uno devuelve un valor que el siguiente puede usar:
```js
texto.split("").reverse().join("")
//     ↑ array   ↑ array inv.  ↑ string
```

---

## Conceptos clave del DOM

| Concepto | Sintaxis | Qué hace |
|---|---|---|
| Seleccionar elemento | `document.getElementById("id")` | Encuentra el elemento con ese `id` |
| Leer input | `elemento.value` | Lee el texto del campo |
| Escribir HTML | `elemento.innerHTML = "..."` | Inserta contenido HTML en el elemento |
| Cambiar estilo | `elemento.style.propiedad = "valor"` | Modifica un estilo CSS directamente |

---

## Ejercicio propuesto para practicar
Agrega un quinto ejercicio llamado **CONTAR** que:
1. Tenga un `<input>` de texto donde el usuario escribe una frase.
2. Al hacer clic en el botón, muestre:
   - Cuántos caracteres tiene la frase (incluidos espacios)
   - Cuántas palabras tiene
   - Cuántas vocales tiene

**Pistas:**
- `texto.length` → número de caracteres
- `texto.split(" ").length` → número de palabras
- Reutiliza la lógica de conteo de vocales de la Lección 5 del Módulo 3
