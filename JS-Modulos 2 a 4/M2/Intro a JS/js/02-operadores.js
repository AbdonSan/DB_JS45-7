// ===========================
// OPERADORES
// ===========================

let a = 10;
let b = 3;

// --- Aritméticos ---
let suma = a + b;           // 13
let resta = a - b;          // 7
let multi = a * b;          // 30
let division = a / b;       // 3.333...
let modulo = a % b;         // 1 (residuo)

//alert('El resultado de la suma es: '+suma);


// --- Comparación ---
let mayor = a > b;          // true
let menor = a < b;          // false
let igual = a === b;        // false (igualdad estricta)
let diferente = a !== b;    // true

// --- == vs === ---
// IMPORTANTE: siempre usar === (estricto) para evitar bugs por conversión implícita
let igualFlojo = "10" == 10;    // true  (JS convierte el tipo automáticamente — peligroso)
let igualEstricto = "10" === 10; // false (compara valor Y tipo — seguro)

// --- Lógicos (para combinar condiciones) ---
let and = true && false;    // false — AND: ambos deben ser true
let or = true || false;     // true  — OR: al menos uno debe ser true
let not = !true;            // false — NOT: invierte el valor booleano

console.log("--- OPERADORES ---");
console.log("10 + 3 =", suma);
console.log("10 === 3:", igual);
console.log('"10" == 10:', igualFlojo);
console.log('"10" === 10:', igualEstricto);

// --- Mostrar en la página ---
document.getElementById("operadores").innerHTML =
    `<strong>Aritméticos:</strong> ${a} + ${b} = ${suma} | ${a} - ${b} = ${resta} | ${a} * ${b} = ${multi} | ${a} / ${b} = ${division.toFixed(2)} | ${a} % ${b} = ${modulo}<br>` +
    `<strong>Comparación:</strong> ${a} > ${b} → ${mayor} | ${a} === ${b} → ${igual}<br>` +
    `<strong>== vs ===:</strong> "10" == 10 → ${igualFlojo} | "10" === 10 → ${igualEstricto}<br>` +
    `<strong>Lógicos:</strong> true && false → ${and} | true || false → ${or} | !true → ${not}`;
