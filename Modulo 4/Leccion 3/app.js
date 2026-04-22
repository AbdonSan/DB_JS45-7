// ============================================================
// MÓDULO 4 – LECCIÓN 3: Manipulación del DOM
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - getElementById()    → acceder a un elemento por su id
//   - .value              → leer el valor de un input
//   - .innerHTML          → escribir contenido HTML en un elemento
//   - .style.backgroundColor → cambiar estilos desde JS
//   - parseInt() / parseFloat() → convertir texto a número
//   - String.repeat()     → repetir un string N veces
//   - Array / split() / reverse() / join() → invertir un string
//   - Template literals   → strings con ${expresiones}
// ============================================================


// ============================================================
// EJERCICIO 1 – REPETIR
// ============================================================
// Lee la palabra y la cantidad de veces del formulario.
// Repite la palabra usando String.repeat() y la muestra en la página.

function repetir() {

    // .value lee el contenido actual del campo de texto
    const palabra = document.getElementById("palabra").value;
    const veces   = parseInt(document.getElementById("veces").value);

    // Validar que "veces" sea un número positivo
    if (isNaN(veces) || veces <= 0) {
        document.getElementById("salida-repetir").innerHTML =
            "<em>Por favor ingresa un número válido mayor a 0.</em>";
        return;
    }

    // String.repeat(n) devuelve el string repetido n veces.
    // Ejemplo: "Hola ".repeat(3) → "Hola Hola Hola "
    const resultado = (palabra + " ").repeat(veces).trim();

    // .innerHTML escribe el resultado dentro del <div id="salida-repetir">
    document.getElementById("salida-repetir").innerHTML = resultado;

    console.log(`Repetir: "${palabra}" × ${veces} → ${resultado}`);
}


// ============================================================
// EJERCICIO 2 – APLICAR COLOR DE FONDO
// ============================================================
// Lee el color elegido en el <input type="color"> y lo aplica
// como color de fondo del párrafo usando .style.backgroundColor.

function aplicarColor() {

    // El input type="color" devuelve un valor hexadecimal, ej: "#00ff00"
    const color = document.getElementById("color").value;

    // .style.backgroundColor cambia el estilo CSS del elemento directamente
    document.getElementById("parrafo-color").style.backgroundColor = color;

    console.log(`Color aplicado: ${color}`);
}


// ============================================================
// EJERCICIO 3 – CALCULAR OPERACIONES
// ============================================================
// Lee dos números, realiza las 4 operaciones básicas y muestra
// cada resultado junto con la suma total de todos ellos.

function calcular() {

    const n1 = parseFloat(document.getElementById("num1").value);
    const n2 = parseFloat(document.getElementById("num2").value);

    // Validar que ambos campos sean números
    if (isNaN(n1) || isNaN(n2)) {
        document.getElementById("salida-calcular").innerHTML =
            "<em>Por favor ingresa dos números válidos.</em>";
        return;
    }

    // Calcular las 4 operaciones básicas
    const suma  = n1 + n2;
    const resta = n1 - n2;
    const multi = n1 * n2;
    // Proteger la división por cero
    const divi  = n2 !== 0 ? n1 / n2 : "indefinida (división por cero)";

    // Sumar los resultados numéricos para el total
    // Si la división fue válida la incluimos, si no, solo las otras 3
    const total = n2 !== 0
        ? suma + resta + multi + divi
        : suma + resta + multi;

    // Construir el HTML de resultados usando template literals
    document.getElementById("salida-calcular").innerHTML = `
        <p>${n1} + ${n2} = ${suma}</p>
        <p>${n1} - ${n2} = ${resta}</p>
        <p>${n1} * ${n2} = ${multi}</p>
        <p>${n1} / ${n2} = ${divi}</p>
        <p><strong>La suma de los resultados es ${total}</strong></p>
    `;

    console.log(`Calcular: ${n1} y ${n2} → suma total: ${total}`);
}


// ============================================================
// EJERCICIO 4 – INVERTIR TEXTO
// ============================================================
// Lee la cadena ingresada y la invierte carácter por carácter.
//
// Técnica: split → reverse → join
//   "Hola"
//   → split("")    → ["H","o","l","a"]
//   → reverse()    → ["a","l","o","H"]
//   → join("")     → "aloH"

function invertir() {

    const texto = document.getElementById("texto-invertir").value;

    // split("")  → convierte el string en array de caracteres
    // reverse()  → invierte el orden del array (modifica el original)
    // join("")   → une el array de nuevo en un string
    const invertido = texto.split("").reverse().join("");

    document.getElementById("salida-invertir").innerHTML = invertido;

    console.log(`Invertir: "${texto}" → "${invertido}"`);
}
