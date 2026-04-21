// ===========================
// FUNCIONES
// ===========================

// --- Función declarativa (function declaration) ---
// Se puede llamar antes de ser definida gracias al "hoisting"
function saludar(nombre) {
    return "Hola, " + nombre + "!";
}

// --- Función con varios parámetros ---
function sumar(a, b) {
    return a + b;
}

// --- Función con valor por defecto ---
function bienvenida(nombre, curso) {
    curso = curso || "JavaScript";
    return `Bienvenido ${nombre} al curso de ${curso}`;
}

// --- Arrow function (función flecha, sintaxis moderna ES6+) ---
// Más corta, ideal para funciones simples de una línea
// Si tiene una sola expresión, el return es implícito
let multiplicar = (a, b) => a * b;

let doble = (n) => n * 2;

// --- Usar las funciones ---
let saludo = saludar("Angel");
let total = sumar(5, 3);
let bienvenido = bienvenida("Carlos");
let producto = multiplicar(4, 5);
let elDoble = doble(7);

console.log("--- FUNCIONES ---");
console.log(saludo);
console.log("5 + 3 =", total);
console.log(bienvenido);
console.log("4 * 5 =", producto);
console.log("Doble de 7:", elDoble);

// --- Mostrar en la página ---
document.getElementById("funciones").innerHTML =
    `<strong>saludar("Angel"):</strong> ${saludo}<br>` +
    `<strong>sumar(5, 3):</strong> ${total}<br>` +
    `<strong>bienvenida("Carlos"):</strong> ${bienvenido}<br>` +
    `<strong>multiplicar(4, 5):</strong> ${producto}<br>` +
    `<strong>doble(7):</strong> ${elDoble}`;
