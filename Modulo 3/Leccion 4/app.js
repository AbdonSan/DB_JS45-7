// ============================================================
// LECCIÓN 4 – Adivina el Número (1–10)
// Mini-juego con validación de entrada y control de intentos
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - Math.random() / Math.floor()  → número aleatorio
//   - parseInt() / isNaN()          → convertir y validar entrada
//   - Array / includes()            → detectar números repetidos
//   - Funciones                     → yaUsado()
//   - Ciclo while                   → controlar los 3 intentos
//   - Condicionales if/else         → comparar y dar pistas
//   - DOM: getElementById()         → mostrar historial en la página
// ============================================================


// ----------------------------------------------------------
// PASO 1: Generar el número secreto (1–10)
// ----------------------------------------------------------
// Math.random()       → decimal entre 0 (incluido) y 1 (excluido)
// Math.random() * 10  → decimal entre 0 y 9.999...
// Math.floor(...)     → lo redondea hacia abajo → 0 a 9
// + 1                 → lo lleva al rango 1 a 10

const secreto = Math.floor(Math.random() * 10) + 1;

// Solo para desarrollo: descomenta la siguiente línea para ver el número en consola
// console.log("Número secreto (debug):", secreto);


// ----------------------------------------------------------
// PASO 2: Función para detectar números repetidos
// ----------------------------------------------------------
// Recibe el número ingresado y el arreglo de intentos previos.
// Retorna true si el número YA está en la lista, false si es nuevo.
// Array.includes() busca si un valor existe dentro del arreglo.

function yaUsado(numero, lista) {
    return lista.includes(numero);
}


// ----------------------------------------------------------
// PASO 3: Variables del juego
// ----------------------------------------------------------

const MAX_INTENTOS = 3;         // límite de intentos efectivos
let intentosRestantes = MAX_INTENTOS;
let usados = [];                // arreglo para guardar intentos válidos
let gano = false;               // bandera: ¿el usuario adivinó?


// ----------------------------------------------------------
// PASO 4: Ciclo principal del juego
// ----------------------------------------------------------
// El ciclo while continúa mientras queden intentos y no haya acierto.

while (intentosRestantes > 0 && !gano) {

    // --- 4a. Pedir el número al usuario ---
    // Se usa un bucle interno para forzar una entrada válida (1–10)
    // y no repetida, SIN gastar el intento si la entrada es inválida.

    let entrada;    // texto que escribe el usuario
    let numero;     // número convertido

    while (true) {  // se rompe con break cuando la entrada es válida

        entrada = prompt(
            "Ingresa un número del 1 al 10.\n" +
            "Intentos restantes: " + intentosRestantes + "\n" +
            (usados.length > 0 ? "Ya usaste: " + usados.join(", ") : "")
        );

        // Si el usuario cancela el prompt, entrada llega como null
        if (entrada === null) {
            alert("Juego cancelado. ¡Hasta la próxima!");
            intentosRestantes = 0;  // forzar salida del ciclo externo
            break;
        }

        // Convertir el texto a número entero
        numero = parseInt(entrada);

        // --- 4b. Validar rango (1 al 10) ---
        // isNaN() retorna true si el valor NO es un número
        if (isNaN(numero) || numero < 1 || numero > 10) {
            alert("⚠️ Entrada inválida. Debes ingresar un número entre 1 y 10.");
            continue;   // volver a pedir sin gastar intento
        }

        // --- 4c. Validar que no sea un número ya usado ---
        if (yaUsado(numero, usados)) {
            alert("⚠️ Ya usaste el número " + numero + ". Elige otro.");
            continue;   // volver a pedir sin gastar intento
        }

        // Si llegó aquí, la entrada es válida → salimos del while interno
        break;
    }

    // Si el usuario canceló, salimos también del ciclo externo
    if (intentosRestantes === 0) break;

    // --- 4d. Registrar el intento válido ---
    usados.push(numero);
    intentosRestantes--;

    console.log("Intento:", numero, "| Secreto:", secreto, "| Restantes:", intentosRestantes);

    // --- 4e. Actualizar historial en la página ---
    document.getElementById("historial").innerHTML =
        "Intentos usados: <strong>" + usados.join(", ") + "</strong>" +
        " | Intentos restantes: <strong>" + intentosRestantes + "</strong>";

    // --- 4f. Comparar con el número secreto ---
    if (numero === secreto) {
        gano = true;    // marcamos que ganó → el while externo termina
    } else if (intentosRestantes > 0) {
        // Pista: indicar si el secreto es mayor o menor
        let pista = numero < secreto ? "El número secreto es MAYOR." : "El número secreto es MENOR.";
        alert("❌ Incorrecto. " + pista + "\nTe quedan " + intentosRestantes + " intento(s).");
    }
}


// ----------------------------------------------------------
// PASO 5: Mensaje final y resultado en la página
// ----------------------------------------------------------

let mensajeFinal;
let colorFondo;

if (gano) {
    mensajeFinal = "🎉 ¡Adivinaste! El número secreto era " + secreto + ". ¡Felicitaciones!";
    colorFondo = "#f0faf0";
    alert(mensajeFinal);
} else if (intentosRestantes === 0 && !gano) {
    mensajeFinal = "😔 Se acabaron los intentos. El número secreto era: " + secreto;
    colorFondo = "#fdf0f0";
    alert(mensajeFinal);
}

// Mostrar resultado final en la página
if (mensajeFinal) {
    const divResultado = document.getElementById("resultado");
    divResultado.innerHTML = mensajeFinal;
    divResultado.style.backgroundColor = colorFondo;
    divResultado.style.borderLeftColor = gano ? "#2ecc71" : "#e74c3c";
}
