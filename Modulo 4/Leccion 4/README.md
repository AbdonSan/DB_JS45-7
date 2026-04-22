# Módulo 4 – Lección 4: Funciones Callback en JavaScript

## Objetivo
Comprender qué es un callback, cómo se pasa una función como argumento a otra función y cómo se usa para manejar resultados exitosos, errores y ejecución diferida en el tiempo.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página con los 3 ejercicios e interfaz visual |
| `app.js` | Las 3 funciones con sus callbacks documentadas |

---

## ¿Qué es un Callback?

Un **callback** es una función que se pasa como argumento a otra función, para que sea ejecutada en un momento específico: cuando termina un proceso, cuando ocurre un error, o después de cierto tiempo.

```js
// Función que recibe un callback
function saludar(nombre, callback) {
    let mensaje = "Hola, " + nombre;
    callback(mensaje);          // llama a la función que recibió
}

// Pasar una función como argumento
saludar("Ana", function(m) {
    console.log(m);             // → "Hola, Ana"
});
```

**El callback se escribe como una función anónima** directamente donde se llama a la función principal.

---

## Ejercicio 1 – `validar_numero(callback)`

### ¿Qué hace?
Solicita un número con `prompt()` y llama al callback con el resultado de la validación.

### Código clave
```js
function validar_numero(callback) {
    let dato = prompt("Ingrese un número:");

    if (!isNaN(dato) && dato.trim() !== "") {
        callback(true, dato, `El número ${dato} es válido.`);
    } else {
        callback(false, dato, `Usted ingresó caracteres incorrectos: "${dato}"`);
    }
}

// Uso: pasar el callback como argumento
validar_numero(function(esValido, dato, mensaje) {
    if (esValido) {
        console.log("ÉXITO:", mensaje);
    } else {
        console.log("ERROR:", mensaje);
    }
});
```

### Flujo del callback
```
validar_numero( fn_callback )
       ↓
   prompt() → usuario escribe
       ↓
   ¿isNaN(dato)?
   ├── NO (es número) → callback(true,  dato, "válido")
   └── SÍ (no número) → callback(false, dato, "error")
                              ↓
                    fn_callback se ejecuta aquí
```

### `isNaN()` explicado
| Entrada | `isNaN()` | Significa |
|---|---|---|
| `"42"` | `false` | Es un número válido |
| `"abc"` | `true` | No es un número |
| `""` | `false` | String vacío (se trata como 0) |
| `"3.14"` | `false` | Decimal válido |

Por eso se combina con `.trim() !== ""` para rechazar entradas vacías.

---

## Ejercicio 2 – `calcular_y_avisar_despues(numero, callback)`

### ¿Qué hace?
Calcula la sumatoria de **números impares** entre 1 y `numero`, espera 5 segundos y luego llama al callback con el resultado.

### Código clave
```js
function calcular_y_avisar_despues(numero, callback) {
    let sumatoria = 0;
    for (let i = 1; i <= numero; i++) {
        if (i % 2 !== 0) {      // i % 2 !== 0 → es impar
            sumatoria += i;
        }
    }

    setTimeout(() => {           // esperar 5 segundos
        callback(sumatoria);
    }, 5000);
}
```

### `setTimeout()` explicado
```js
setTimeout(función, milisegundos)
```
- Ejecuta `función` una sola vez después de `milisegundos` ms.
- 5000 ms = 5 segundos.
- El código **no se detiene** mientras espera — el resto del programa sigue corriendo.

### Arrow function `() => {}`
```js
// Función anónima tradicional
setTimeout(function() { callback(resultado); }, 5000);

// Arrow function (equivalente, más compacta)
setTimeout(() => { callback(resultado); }, 5000);
```
Las arrow functions son una forma más corta de escribir funciones anónimas. No tienen su propio `this`.

### Ejemplo con numero = 10
```
Impares entre 1 y 10: 1, 3, 5, 7, 9
Sumatoria: 1 + 3 + 5 + 7 + 9 = 25
→ Después de 5 s: "El valor de la sumatoria es 25. Este resultado se obtuvo hace 5 segundos."
```

---

## Ejercicio 3 – `calcular_y_avisar_dependiendo(numero, callback, callback_error)`

### ¿Qué hace?
Calcula las **sumatorias sucesivas** de 1 a `numero`. Si el total es menor a 1000 llama a `callback`; si es 1000 o más llama a `callback_error`.

### Sumatorias sucesivas explicadas (numero = 5)
```
i=1: 1              = 1
i=2: 1 + 2          = 3
i=3: 1 + 2 + 3      = 6
i=4: 1 + 2 + 3 + 4  = 10
i=5: 1 + 2 + 3 + 4 + 5 = 15
                     ───
Total               = 35
```

### Código clave
```js
function calcular_y_avisar_dependiendo(numero, callback, callback_error) {
    let total = 0;

    for (let i = 1; i <= numero; i++) {
        let parcial = 0;
        for (let j = 1; j <= i; j++) {
            parcial += j;           // sumatoria interna
        }
        total += parcial;           // acumular en el total
    }

    if (total < 1000) {
        callback(numero, total);            // éxito
    } else {
        callback_error(numero, total);      // límite superado
    }
}

// Uso: pasar DOS callbacks
calcular_y_avisar_dependiendo(
    5,
    function(n, total) {
        console.log(`Las sumatorias sucesivas de ${n} es ${total}`);
    },
    function(n, total) {
        console.log(`El número ${n} sobrepasa el objetivo. Resultado: ${total}`);
    }
);
```

### ¿Cuándo se activa `callback_error`?
Hay que encontrar el `numero` a partir del cual el total llega a 1000+:

| numero | Total |
|---|---|
| 5 | 35 |
| 10 | 220 |
| 13 | 637 |
| 14 | 840 |
| 15 | 1080 ← supera 1000 |

Desde `numero = 15` en adelante se activa `callback_error`.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| Callback | Función pasada como argumento para ejecutarse después |
| `isNaN(valor)` | Devuelve `true` si el valor no es un número |
| `setTimeout(fn, ms)` | Ejecuta `fn` una vez después de `ms` milisegundos |
| Arrow function `() => {}` | Sintaxis compacta para funciones anónimas |
| `i % 2 !== 0` | Detecta si `i` es impar (residuo distinto de 0) |
| Bucle anidado | Un `for` dentro de otro para calcular sumatorias sucesivas |
| Dos callbacks | Pasar `callback` y `callback_error` para manejar éxito y fallo |

---

## Comparación: función normal vs callback

```
Sin callback                    Con callback
────────────────────────────    ──────────────────────────────────
function calcular(n) {          function calcular(n, callback) {
    let r = n * 2;                  let r = n * 2;
    console.log(r);                 callback(r);    ← flexible
}                               }

calcular(5);                    calcular(5, function(r) {
→ siempre hace lo mismo             console.log(r);    // o lo que sea
                                });
```

El callback hace la función más **flexible**: quien la llama decide qué hacer con el resultado.

---

## Ejercicio propuesto para practicar
Crea una función `esperar_y_saludar(nombre, segundos, callback)` que:
1. Espere `segundos` segundos con `setTimeout`.
2. Llame al callback con el mensaje `"¡Hola, nombre! Han pasado X segundos."`.

Agrega un input de nombre, un input de segundos, un botón y un `<div>` donde aparezca el mensaje cuando termine el tiempo.
