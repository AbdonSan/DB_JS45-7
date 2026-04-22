# Lección 5 – Conteo de Vocales en Palabras

## Objetivo
Desarrollar un programa en JavaScript que solicite al usuario un conjunto de palabras, las almacene en un array y cuente el total de vocales presentes en todas ellas, usando una función expresiva y métodos de manipulación de cadenas y arreglos.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página HTML con dos `<div>`: uno para la lista de palabras y otro para el resultado |
| `app.js` | Lógica del conteo de vocales |

---

## ¿Qué hace el programa?
1. Pregunta al usuario **cuántas palabras** desea ingresar.
2. Solicita cada palabra con `prompt()` y las guarda en un array.
3. Une todas las palabras en una sola cadena con `join("")`.
4. Cuenta las vocales de esa cadena usando una **función expresiva**.
5. Muestra el resultado en consola, alerta y en la página web.

---

## Pasos para entender el ejercicio

### Paso 1 – Definir las vocales como referencia
```js
const vocales = ["a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"];
```
Guardamos las vocales en un array constante para poder buscar en él con `includes()`. Se incluyen vocales con tilde para que también sean contadas.

---

### Paso 2 – Función expresiva `contarVocales()`
```js
const contarVocales = function(palabra) {
    let contador = 0;
    let palabraMinuscula = palabra.toLowerCase();

    for (let caracter of palabraMinuscula) {
        if (vocales.includes(caracter)) {
            contador++;
        }
    }

    return contador;
};
```

**¿Qué es una función expresiva?**

Una función expresiva se asigna a una variable, a diferencia de una función declarativa:

| Tipo | Sintaxis |
|---|---|
| Declarativa | `function contarVocales(palabra) { ... }` |
| Expresiva | `const contarVocales = function(palabra) { ... }` |

La diferencia clave: las funciones declarativas pueden usarse **antes** de su definición en el código (hoisting). Las expresivas **no**.

**Métodos usados dentro de la función:**

| Método | Qué hace |
|---|---|
| `toLowerCase()` | Convierte el string a minúsculas: `"Hola"` → `"hola"` |
| `for...of` | Recorre cada carácter del string uno por uno |
| `includes()` | Devuelve `true` si el carácter está en el array de vocales |
| `contador++` | Suma 1 al contador (equivale a `contador = contador + 1`) |
| `return` | Devuelve el resultado de la función al lugar donde fue llamada |

**Ejemplo paso a paso con la palabra `"Hola"`:**
```
palabraMinuscula = "hola"

Iteración 1: caracter = "h" → vocales.includes("h") = false → no suma
Iteración 2: caracter = "o" → vocales.includes("o") = true  → contador = 1
Iteración 3: caracter = "l" → vocales.includes("l") = false → no suma
Iteración 4: caracter = "a" → vocales.includes("a") = true  → contador = 2

return 2
```

---

### Paso 3 – Solicitar cuántas palabras ingresará el usuario
```js
let cantidad = parseInt(prompt("¿Cuántas palabras deseas ingresar?"));
```
- `prompt()` devuelve texto → `parseInt()` lo convierte a número entero.
- Se valida que sea un número positivo con `isNaN()`.

---

### Paso 4 – Solicitar las palabras con un ciclo `for`
```js
let listaPalabras = [];

for (let i = 1; i <= cantidad; i++) {
    let palabra = prompt("Ingresa la palabra " + i + " de " + cantidad + ":");
    listaPalabras.push(palabra);
}
```
- El ciclo `for` se repite exactamente `cantidad` veces.
- Cada palabra se agrega al array con `push()`.

---

### Paso 5 – Unir las palabras con `join("")`
```js
let cadenaCompleta = listaPalabras.join("");
```
`join(separador)` convierte un array en un string. Con `""` como separador, las palabras quedan pegadas:

```
["hola", "mundo", "JavaScript"] → "holamundoJavaScript"
```

Así la función `contarVocales()` procesa todas las palabras de una sola vez.

---

### Paso 6 – Llamar a la función y obtener el total
```js
let totalVocales = contarVocales(cadenaCompleta);
```
Se pasa la cadena unificada a la función. El valor devuelto por `return` queda guardado en `totalVocales`.

---

### Paso 7 – Mostrar resultados
```js
console.log(mensaje);
window.alert(mensaje);
document.getElementById("palabras").innerHTML = "Palabras ingresadas: " + listaPalabras.join(", ");
document.getElementById("resultado").innerHTML = "Total de vocales: " + totalVocales;
```
Nótese que aquí `join(", ")` usa coma y espacio como separador para mostrar la lista legible al usuario.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| Función expresiva | Función asignada a una variable: `const fn = function() {}` |
| `toLowerCase()` | Convierte un string a minúsculas |
| `for...of` | Recorre cada carácter de un string o elemento de un array |
| `includes()` | Devuelve `true`/`false` si un valor existe en un array o string |
| `contador++` | Incrementa una variable en 1 |
| `return` | Devuelve un valor desde dentro de la función |
| `Array.join(sep)` | Une los elementos de un array en un string con un separador |
| `Array.push()` | Agrega un elemento al final del array |
| `parseInt()` | Convierte texto a número entero |
| `isNaN()` | Devuelve `true` si el valor no es un número |

---

## Ejemplo de ejecución

**Palabras ingresadas:** `["casa", "árbol", "luz"]`

**Cadena unificada:** `"casaárboluz"`

| Carácter | ¿Vocal? | Contador |
|---|---|---|
| c | No | 0 |
| a | Sí | 1 |
| s | No | 1 |
| a | Sí | 2 |
| á | Sí | 3 |
| r | No | 3 |
| b | No | 3 |
| o | Sí | 4 |
| l | No | 4 |
| u | Sí | 5 |
| z | No | 5 |

**Resultado:** 5 vocales en total.

---

## Diferencia entre `for`, `for...of` y `for...in`

| Tipo | Uso ideal |
|---|---|
| `for (let i = 0; i < n; i++)` | Cuando necesitas el índice numérico |
| `for...of` | Para recorrer los **valores** de un array o string |
| `for...in` | Para recorrer las **claves** de un objeto |

En este ejercicio se usa `for...of` porque nos interesan los **caracteres** del string, no su posición.
