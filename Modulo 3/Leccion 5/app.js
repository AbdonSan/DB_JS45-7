// ============================================================
// LECCIÓN 5 – Conteo de Vocales en Palabras
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - Funciones expresivas       → const nombre = function() {}
//   - toLowerCase()              → convertir a minúsculas
//   - includes()                 → buscar un elemento en array/string
//   - Ciclo for...of             → recorrer caracteres de un string
//   - Array / push() / join()    → acumular y unir palabras
//   - parseInt()                 → convertir texto a número entero
//   - DOM: getElementById()      → mostrar resultados en la página
// ============================================================


// ----------------------------------------------------------
// PASO 1: Definir las vocales como referencia
// ----------------------------------------------------------
// Guardamos las vocales en un array para usar includes() después.
// Al incluir vocales con tilde, el programa también las cuenta.

const vocales = ["a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"];


// ----------------------------------------------------------
// PASO 2: Función expresiva – contarVocales(palabra)
// ----------------------------------------------------------
// Una función expresiva se asigna a una variable con const/let.
// A diferencia de una función declarativa (function nombre()),
// las funciones expresivas NO se pueden usar antes de declararlas.
//
// Lógica:
//   Recorre cada carácter de la palabra.
//   Si el carácter está en el array de vocales, suma 1 al contador.
//   Al final devuelve el total de vocales encontradas.

const contarVocales = function(palabra) {
    let contador = 0;

    // toLowerCase() convierte todo a minúsculas para comparar sin
    // importar si el usuario escribió "Hola" o "HOLA"
    let palabraMinuscula = palabra.toLowerCase();

    // for...of recorre cada carácter del string uno por uno
    for (let caracter of palabraMinuscula) {

        // includes() devuelve true si el carácter está en el array de vocales
        if (vocales.includes(caracter)) {
            contador++;     // equivale a contador = contador + 1
        }
    }

    return contador;    // devuelve el total de vocales de esa palabra
};


// ----------------------------------------------------------
// PASO 3: Solicitar cuántas palabras ingresará el usuario
// ----------------------------------------------------------

let cantidadTexto = prompt("¿Cuántas palabras deseas ingresar?");
let cantidad = parseInt(cantidadTexto);

// Validar que sea un número positivo
if (isNaN(cantidad) || cantidad <= 0) {
    alert("Debes ingresar un número válido mayor a 0.");
    cantidad = 0;   // no entra al ciclo de ingreso
}


// ----------------------------------------------------------
// PASO 4: Solicitar las palabras y guardarlas en un array
// ----------------------------------------------------------

let listaPalabras = [];     // array vacío donde se guardarán las palabras

for (let i = 1; i <= cantidad; i++) {
    let palabra = prompt("Ingresa la palabra " + i + " de " + cantidad + ":");

    // Si el usuario cancela o deja vacío, usamos cadena vacía
    if (palabra === null || palabra.trim() === "") {
        palabra = "";
    }

    listaPalabras.push(palabra);    // agrega la palabra al final del array
}

console.log("Palabras ingresadas:", listaPalabras);


// ----------------------------------------------------------
// PASO 5: Unir todas las palabras en una sola cadena
// ----------------------------------------------------------
// join("") une todos los elementos del array en un string,
// sin separador entre ellas, para contar vocales en total.
//
// Ejemplo: ["hola", "mundo"] → "holamundo"

let cadenaCompleta = listaPalabras.join("");

console.log("Cadena unificada:", cadenaCompleta);


// ----------------------------------------------------------
// PASO 6: Aplicar la función de conteo sobre la cadena total
// ----------------------------------------------------------

let totalVocales = contarVocales(cadenaCompleta);

console.log("Total de vocales:", totalVocales);


// ----------------------------------------------------------
// PASO 7: Mostrar resultados
// ----------------------------------------------------------

let mensaje = "Las palabras ingresadas contienen " + totalVocales + " vocal(es) en total.";

// En consola
console.log(mensaje);

// En alerta emergente
window.alert(mensaje);

// En la página web
document.getElementById("palabras").innerHTML =
    "<strong>Palabras ingresadas:</strong> " + listaPalabras.join(", ");

document.getElementById("resultado").innerHTML =
    "Total de vocales encontradas: <strong>" + totalVocales + "</strong>";
