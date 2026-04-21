// ===========================
// VARIABLES Y TIPOS DE DATOS
// ===========================

// -----------------------------------------------
// REGLAS PARA NOMBRAR VARIABLES EN JAVASCRIPT
// -----------------------------------------------
// 1. Pueden contener letras, números, _ (guión bajo) y $ (signo de dólar)
// 2. NO pueden empezar con un número         → 1nombre ✗ | nombre1 ✓
// 3. NO pueden usar palabras reservadas       → let, const, function, return, etc.
// 4. Son case-sensitive                       → nombre ≠ Nombre ≠ NOMBRE
// 5. Usar camelCase por convención            → miNombreCompleto ✓
//    - La primera palabra en minúscula, las siguientes empiezan con mayúscula
// 6. Las constantes globales van en UPPER_SNAKE_CASE → const API_URL = "..."
// 7. Usar nombres descriptivos               → edad ✓ | x ✗
//
// Ejemplos válidos:   nombre, _privado, $precio, miEdad, totalItems
// Ejemplos inválidos: 1dato, mi-nombre (el guión no es válido), class, return
// -----------------------------------------------

// --- let: variable que se puede reasignar ---
// Usar let cuando el valor va a cambiar durante la ejecución

let nombre = "Angel";
let edad = 25;
let direccion;

nombre = "Pedro";  // se puede reasignar sin problema
edad = 30;
direccion="Santiago de Chile";

// --- const: constante, NO se puede reasignar ---
// Usar const siempre que el valor no necesite cambiar (es la opción preferida)
const PAIS = "México";
// pais = "España";  // TypeError: Assignment to constant variable

// NOTA: var también existe pero está en desuso.
// Tiene problemas de alcance (scope) y puede causar bugs. Usar let o const.

// --- Tipos de datos ---
let texto = "Hola mundo";       // String
let numero = 42;                // Number
let decimal = 3.14;             // Number
let activo = true;              // Boolean
let vacio = null;               // Null
let sinDefinir;                 // Undefined

// --- typeof: operador que devuelve el tipo de dato como string ---
// OJO: typeof null devuelve "object" — es un bug histórico de JS
console.log('HOLAAAAAAAA');

console.log("--- VARIABLES ---");
console.log("nombre:", nombre, "→", typeof nombre);
console.log("edad:", edad, "→", typeof edad);
console.log("activo:", activo, "→", typeof activo);
console.log("vacio:", vacio, "→", typeof 2);
console.log("sinDefinir:", sinDefinir, "→", typeof sinDefinir);

// --- Mostrar en la página ---
document.getElementById("variables").innerHTML =
    `<strong>nombre</strong> = "${nombre}" <br>` +
    `<strong>edad</strong> = ${edad} <br>` +
    `<strong>pais</strong> = "${PAIS}" (${typeof PAIS})<br>` +
    `<strong>activo</strong> = ${activo} (${typeof activo})<br>` +
    `<strong>vacio</strong> = ${vacio} (${typeof vacio})<br>` +
    `<strong>sinDefinir</strong> = ${sinDefinir} (${typeof sinDefinir})`;
