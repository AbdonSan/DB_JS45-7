# Lección 3 – Identificación del Mayor y Menor con Ordenamiento Burbuja

## Objetivo
Desarrollar un programa en JavaScript que lea tres valores ingresados por el usuario, los ordene usando el algoritmo de burbuja (Bubble Sort) y determine el número mayor y el menor. También se maneja el caso especial en que los tres valores sean iguales.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página HTML con un `<div>` para mostrar el resultado |
| `app.js` | Lógica del ordenamiento y la identificación de mayor/menor |

---

## ¿Qué hace el programa?
1. Pide al usuario **3 números** con `prompt()`.
2. Los almacena en un **array**.
3. Los ordena de menor a mayor usando el **algoritmo de burbuja**.
4. Muestra el **número mayor** (último del array) y el **número menor** (primero del array).
5. Si los tres números son iguales, muestra un mensaje especial.

---

## Pasos para entender el ejercicio

### Paso 1 – Solicitar los 3 números
```js
let numero1 = parseFloat(prompt("Ingresa el primer número:"));
let numero2 = parseFloat(prompt("Ingresa el segundo número:"));
let numero3 = parseFloat(prompt("Ingresa el tercer número:"));
```
- `prompt()` captura texto del usuario.
- `parseFloat()` convierte ese texto a un **número decimal**. A diferencia de la conversión automática de JavaScript, `parseFloat()` es explícita y más segura.

### Paso 2 – Guardar en un array con `push()`
```js
let numeros = [];
numeros.push(numero1);
numeros.push(numero2);
numeros.push(numero3);
```
- `[]` crea un **array vacío**.
- `.push()` agrega un elemento al **final** del array.
- Resultado: `numeros = [numero1, numero2, numero3]`

### Paso 3 – Ordenamiento Burbuja (Bubble Sort)
El algoritmo compara pares de elementos consecutivos y los intercambia si están en el orden incorrecto. Repite este proceso hasta que no haya ningún intercambio necesario.

```js
let huboIntercambio;

do {
    huboIntercambio = false;

    for (let i = 0; i < numeros.length - 1; i++) {
        if (numeros[i] > numeros[i + 1]) {
            let temporal = numeros[i];
            numeros[i] = numeros[i + 1];
            numeros[i + 1] = temporal;
            huboIntercambio = true;
        }
    }

} while (huboIntercambio);
```

**Ejemplo visual con [5, 1, 3]:**
```
Pasada 1:
  Compara 5 y 1 → 5 > 1 → intercambia → [1, 5, 3]
  Compara 5 y 3 → 5 > 3 → intercambia → [1, 3, 5]

Pasada 2:
  Compara 1 y 3 → 1 < 3 → no intercambia
  Compara 3 y 5 → 3 < 5 → no intercambia
  huboIntercambio = false → el do-while termina

Resultado: [1, 3, 5]
```

**Técnica del swap (intercambio):**
```js
let temporal = numeros[i];       // guarda el valor antes de sobreescribirlo
numeros[i] = numeros[i + 1];     // sobreescribe la posición actual
numeros[i + 1] = temporal;       // coloca el valor guardado en la siguiente posición
```
Sin la variable `temporal`, perderíamos uno de los valores.

### Paso 4 – Identificar mayor y menor
```js
let menor = numeros[0];                    // primer elemento (más pequeño)
let mayor = numeros[numeros.length - 1];   // último elemento (más grande)
```
Tras el ordenamiento, el array siempre queda de menor a mayor.

### Paso 5 – Caso especial: números iguales
```js
if (mayor === menor) {
    mensaje = "Los tres números ingresados son idénticos: " + mayor;
} else {
    mensaje = "Número MAYOR: " + mayor + " | Número MENOR: " + menor;
}
```

### Paso 6 – Mostrar resultados
```js
window.alert(mensaje);
document.getElementById("resultado").innerHTML = ...;
```

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `parseFloat()` | Convierte texto a número decimal |
| `Array` + `push()` | Crear y rellenar un arreglo de valores |
| Ciclo `do-while` | Ejecuta al menos una vez y repite mientras la condición sea verdadera |
| Ciclo `for` | Recorre el array para comparar pares consecutivos |
| Variable `temporal` | Técnica clásica para intercambiar dos valores sin perderlos |
| `array[0]` | Accede al primer elemento del array |
| `array[array.length - 1]` | Accede al último elemento del array |
| `===` | Comparación estricta (valor Y tipo) |

---

## Diferencia entre `do-while` y `while`

| `while` | `do-while` |
|---|---|
| Evalúa la condición **antes** de ejecutar | Ejecuta **al menos una vez** antes de evaluar |
| Puede no ejecutarse nunca | Siempre se ejecuta al menos una vez |

En el ordenamiento burbuja usamos `do-while` porque necesitamos hacer al menos una pasada antes de saber si hay intercambios.
