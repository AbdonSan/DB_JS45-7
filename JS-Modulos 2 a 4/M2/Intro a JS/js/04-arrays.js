// ===========================
// ARRAYS (LISTAS)
// ===========================

// --- Crear un array ---
// Un array es una lista ordenada de elementos. Puede contener cualquier tipo de dato.
let frutas = ["Manzana", "Banana", "Naranja", "Fresa"];

// --- Acceder por índice (empieza en 0, no en 1) ---
let primera = frutas[0];   // "Manzana"
let segunda = frutas[1];   // "Banana"

// --- Largo del array ---
let total = frutas.length;  // 4

// --- Métodos principales para agregar y quitar ---
frutas.push("Mango");       // agrega al final del array
frutas.pop();                // quita y devuelve el último elemento
// También existen: unshift() agrega al inicio, shift() quita del inicio

// --- Recorrer con for ---
let listaTexto = "";
for (let i = 0; i < frutas.length; i++) {
    listaTexto += frutas[i] + ", ";
}

// --- Recorrer con forEach ---
let listaHTML = "";
frutas.forEach(function (fruta, indice) {
    listaHTML += `<li>${indice}: ${fruta}</li>`;
});

console.log("--- ARRAYS ---");
console.log("Frutas:", frutas);
console.log("Primera:", primera);
console.log("Total:", total);

// --- Mostrar en la página ---
document.getElementById("arrays").innerHTML =
    `<strong>Array:</strong> [${frutas.join(", ")}]<br>` +
    `<strong>Primero:</strong> frutas[0] → ${primera}<br>` +
    `<strong>Largo:</strong> frutas.length → ${frutas.length}<br>` +
    `<strong>forEach:</strong><ul>${listaHTML}</ul>`;
