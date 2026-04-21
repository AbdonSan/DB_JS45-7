// ===========================
// LOOPS (BUCLES)
// ===========================

// --- for clásico: cuando sabes cuántas veces iterar ---
let forResult = "";
for (let i = 1; i <= 5; i++) {
    forResult += i + " ";
}

// --- while: cuando NO sabes cuántas veces se repetirá ---
// CUIDADO: si la condición nunca es false, se crea un loop infinito
let whileResult = "";
let contador = 1;
while (contador <= 5) {
    whileResult += contador + " ";
    contador++;
}

// --- for...of: recorre los VALORES de un array (o cualquier iterable) ---
let colores = ["Rojo", "Verde", "Azul"];
let ofResult = "";
for (let color of colores) {
    ofResult += color + " ";
}

// --- for...in: recorre las CLAVES (propiedades) de un objeto ---
// NO usar for...in en arrays — usar for...of o forEach en su lugar
let carro = { marca: "Toyota", modelo: "Corolla", año: 2020 };
let inResult = "";
for (let propiedad in carro) {
    inResult += `${propiedad}: ${carro[propiedad]} | `;
}

console.log("--- LOOPS ---");
console.log("for:", forResult);
console.log("while:", whileResult);
console.log("for...of:", ofResult);
console.log("for...in:", inResult);

// --- Mostrar en la página ---
document.getElementById("loops").innerHTML =
    `<strong>for (1 a 5):</strong> ${forResult}<br>` +
    `<strong>while (1 a 5):</strong> ${whileResult}<br>` +
    `<strong>for...of [colores]:</strong> ${ofResult}<br>` +
    `<strong>for...in {carro}:</strong> ${inResult}`;
