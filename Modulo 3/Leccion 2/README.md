# Lección 2 – Cálculo del Área de un Círculo

## Objetivo
Desarrollar una aplicación web que calcule el área de un círculo a partir del diámetro ingresado por el usuario, practicando `prompt()`, el objeto `Math`, `console.log()`, `alert()` y manipulación básica del DOM.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página HTML con un `<div>` para mostrar el resultado |
| `app.js` | Lógica del cálculo del área |

---

## ¿Qué hace el programa?
1. Pide al usuario el **diámetro** del círculo.
2. Calcula el **radio** (diámetro / 2).
3. Calcula el **área** con la fórmula: `Área = π × radio²`
4. Muestra el resultado en **tres lugares**: consola, alerta emergente y la página web.

---

## Fórmula matemática

```
Área = π × radio²
```

Donde `radio = diámetro / 2`.

---

## Pasos para entender el ejercicio

### Paso 1 – Solicitar el diámetro con `prompt()`
```js
let diametro = prompt("Ingresa el diámetro del círculo:");
```
`prompt()` abre un cuadro de texto donde el usuario puede escribir. Siempre devuelve el valor como **texto (string)**, pero JavaScript convierte automáticamente el texto a número cuando se usa en operaciones matemáticas.

### Paso 2 – Calcular el radio
```js
let radio = diametro / 2;
```
Dividimos el diámetro entre 2. JavaScript realiza la conversión de texto a número de forma automática aquí.

### Paso 3 – Calcular el área con el objeto `Math`
```js
let area = Math.PI * Math.pow(radio, 2);
```
- `Math.PI` → devuelve el valor de π (aproximadamente 3.14159...).
- `Math.pow(radio, 2)` → eleva el radio a la potencia 2 (radio²).

### Paso 4 – Mostrar en consola
```js
console.log("El área del círculo es: " + area);
```
`console.log()` escribe el resultado en la **consola del navegador** (accesible con F12 → pestaña Console). Útil para depuración.

### Paso 5 – Mostrar en alerta emergente
```js
window.alert("El área del círculo es: " + area);
```
Muestra el resultado en un cuadro de diálogo emergente.

### Paso 6 – Mostrar en la página web
```js
document.getElementById("resultado").innerHTML =
    "El área del círculo con diámetro " + diametro + " es: " + area.toFixed(2);
```
- `document.getElementById("resultado")` → busca el elemento HTML con `id="resultado"`.
- `.innerHTML` → escribe contenido HTML dentro de ese elemento.
- `.toFixed(2)` → redondea el número a 2 decimales.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `prompt()` | Abre un cuadro de texto para capturar datos del usuario |
| `Math.PI` | Constante matemática π (3.14159...) |
| `Math.pow(base, exponente)` | Eleva un número a una potencia |
| `console.log()` | Escribe mensajes en la consola del navegador |
| `window.alert()` | Muestra un cuadro de alerta emergente |
| `document.getElementById()` | Accede a un elemento HTML por su `id` |
| `.innerHTML` | Permite leer o escribir contenido HTML dentro de un elemento |
| `.toFixed(n)` | Formatea un número con `n` decimales |

---

## Ejemplo de resultado
Si el usuario ingresa diámetro = `10`:
- Radio = `5`
- Área = `π × 5² = 78.54`

La página mostrará:
> El área del círculo con diámetro 10 es: 78.54
