# Lección 4 – Adivina el Número (1–10)

## Objetivo
Desarrollar un mini-juego en JavaScript donde el computador elige un número aleatorio del 1 al 10 y el usuario tiene 3 intentos para adivinarlo. Se practica el uso de funciones, validación de entrada, arrays, `Math.random()`, ciclos anidados y manipulación del DOM.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página HTML con los `<div>` para historial y resultado final |
| `app.js` | Lógica completa del juego |

---

## Reglas del juego
- El computador elige un número secreto entre 1 y 10.
- El usuario tiene **3 intentos** para adivinarlo.
- Solo se aceptan valores entre **1 y 10** (enteros).
- No se puede **repetir** un número ya usado.
- Las entradas inválidas o repetidas **no gastan** un intento.
- Si no adivina en 3 intentos, se revela el número secreto.

---

## Pasos para entender el ejercicio

### Paso 1 – Generar el número secreto con `Math.random()`
```js
const secreto = Math.floor(Math.random() * 10) + 1;
```
| Expresión | Resultado |
|---|---|
| `Math.random()` | Decimal entre 0.0 y 0.999... |
| `Math.random() * 10` | Decimal entre 0.0 y 9.999... |
| `Math.floor(...)` | Entero entre 0 y 9 |
| `... + 1` | Entero entre **1 y 10** |

Se usa `const` porque el número secreto no cambia durante el juego.

### Paso 2 – Función `yaUsado()`
```js
function yaUsado(numero, lista) {
    return lista.includes(numero);
}
```
- Recibe un número y el array de intentos anteriores.
- `Array.includes()` devuelve `true` si el número ya está en la lista.
- Separar esta lógica en una función hace el código más **legible y reutilizable**.

### Paso 3 – Variables del juego
```js
const MAX_INTENTOS = 3;
let intentosRestantes = MAX_INTENTOS;
let usados = [];
let gano = false;
```
- `MAX_INTENTOS` → constante que define el límite de intentos.
- `usados` → array que acumula los números ya ingresados.
- `gano` → bandera booleana que indica si el usuario acertó.

### Paso 4 – Ciclo principal (`while` externo)
```js
while (intentosRestantes > 0 && !gano) {
    // ...
}
```
El juego continúa mientras queden intentos Y el usuario no haya ganado. Usar `&&` asegura que ambas condiciones se cumplan.

### Paso 5 – Ciclo de validación (`while` interno)
```js
while (true) {
    entrada = prompt(...);

    if (entrada === null) { /* usuario canceló */ break; }

    numero = parseInt(entrada);

    if (isNaN(numero) || numero < 1 || numero > 10) {
        alert("Entrada inválida...");
        continue;   // volver a pedir SIN gastar intento
    }

    if (yaUsado(numero, usados)) {
        alert("Ya usaste ese número...");
        continue;   // volver a pedir SIN gastar intento
    }

    break;  // entrada válida y nueva → salir del while interno
}
```
El `while(true)` crea un bucle infinito que solo termina con `break`. Esto permite **forzar una entrada válida** sin gastar un intento cuando la entrada es incorrecta.

**Palabras clave del ciclo:**
| Palabra | Efecto |
|---|---|
| `break` | Sale del ciclo inmediatamente |
| `continue` | Salta al siguiente ciclo sin ejecutar el resto |

### Paso 6 – Registrar y comparar el intento
```js
usados.push(numero);
intentosRestantes--;

if (numero === secreto) {
    gano = true;
} else if (intentosRestantes > 0) {
    let pista = numero < secreto ? "El número secreto es MAYOR." : "El número secreto es MENOR.";
    alert("Incorrecto. " + pista);
}
```
- `push()` agrega el número al historial.
- `intentosRestantes--` reduce el contador en 1 (equivale a `intentosRestantes = intentosRestantes - 1`).
- El **operador ternario** `condición ? valorSiTrue : valorSiFalse` da una pista al usuario.

### Paso 7 – Actualizar el historial en la página
```js
document.getElementById("historial").innerHTML =
    "Intentos usados: " + usados.join(", ") +
    " | Intentos restantes: " + intentosRestantes;
```
- `Array.join(", ")` convierte el array en un texto separado por comas: `[3, 7]` → `"3, 7"`.

### Paso 8 – Mensaje final
```js
if (gano) {
    alert("¡Adivinaste! El número era " + secreto);
} else {
    alert("Se acabaron los intentos. El número era: " + secreto);
}
```

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `Math.random()` + `Math.floor()` | Generar un número entero aleatorio en un rango |
| `const` vs `let` | `const` para valores que no cambian, `let` para los que sí |
| `parseInt()` + `isNaN()` | Convertir texto a entero y detectar si no es un número |
| `Array.includes()` | Verificar si un valor ya existe en el array |
| Funciones | Bloques de código reutilizables con nombre |
| `while(true)` + `break` | Bucle infinito controlado, útil para forzar entradas válidas |
| `continue` | Saltar la iteración actual y volver al inicio del bucle |
| Bandera booleana | Variable (`gano`) que guarda un estado verdadero/falso |
| Operador ternario `? :` | Forma compacta de escribir un `if/else` simple |
| `Array.join()` | Convierte un array en un string con un separador |

---

## Flujo del juego

```
Generar número secreto (1–10)
         ↓
┌─ while: intentos > 0 && !ganó ──────────────────────────┐
│   ┌─ while(true): forzar entrada válida ─────────────┐  │
│   │  prompt() → parseInt()                           │  │
│   │  ¿nulo?        → cancelar juego                  │  │
│   │  ¿fuera rango? → alert + continue                │  │
│   │  ¿ya usado?    → alert + continue                │  │
│   │  válido        → break                           │  │
│   └───────────────────────────────────────────────────┘  │
│   push() → intentosRestantes--                           │
│   ¿acierto? → gano = true → rompe while externo          │
│   Si no    → pista (mayor/menor)                         │
└──────────────────────────────────────────────────────────┘
         ↓
  Mensaje final + resultado en página
```
