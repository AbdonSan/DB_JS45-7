// ============================================================
// LECCIÓN 3 – Identificación del Mayor y Menor
// Algoritmo: Ordenamiento Burbuja (Bubble Sort)
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - prompt()        → capturar datos del usuario
//   - parseFloat()    → convertir texto a número decimal
//   - Array / push()  → almacenar valores en un arreglo
//   - Ciclo do-while  → repetir mientras se cumpla una condición
//   - Ciclo for       → recorrer el arreglo para comparar pares
//   - Condicionales   → manejar el caso de números iguales
// ============================================================


// ----------------------------------------------------------
// PASO 1: Solicitar los 3 números al usuario
// ----------------------------------------------------------
// prompt() siempre devuelve texto (string), por eso usamos
// parseFloat() para convertirlo a número decimal.

let numero1 = parseFloat(prompt("Ingresa el primer número:"));
let numero2 = parseFloat(prompt("Ingresa el segundo número:"));
let numero3 = parseFloat(prompt("Ingresa el tercer número:"));


// ----------------------------------------------------------
// PASO 2: Guardar los números en un array
// ----------------------------------------------------------
// Creamos un arreglo vacío y agregamos cada número con push().
// push() añade un elemento al final del arreglo.

let numeros = [];
numeros.push(numero1);
numeros.push(numero2);
numeros.push(numero3);

console.log("Números ingresados:", numeros);


// ----------------------------------------------------------
// PASO 3: Ordenamiento Burbuja (Bubble Sort)
// ----------------------------------------------------------
// Idea del algoritmo:
//   Recorre el arreglo comparando dos elementos consecutivos.
//   Si el de la izquierda es MAYOR que el de la derecha,
//   los intercambia (swap). Repite esto hasta que no haya
//   ningún intercambio necesario → el arreglo está ordenado.
//
// Ejemplo visual con [5, 1, 3]:
//   Pasada 1: compara 5 y 1 → intercambia → [1, 5, 3]
//             compara 5 y 3 → intercambia → [1, 3, 5]
//   Pasada 2: compara 1 y 3 → no intercambia
//             compara 3 y 5 → no intercambia
//   Resultado ordenado: [1, 3, 5]

let huboIntercambio;  // bandera que indica si se hizo algún swap

do {
    huboIntercambio = false;  // suponemos que ya está ordenado

    // Recorremos pares consecutivos: (0,1) y (1,2)
    for (let i = 0; i < numeros.length - 1; i++) {

        // Si el elemento actual es mayor que el siguiente → swap
        if (numeros[i] > numeros[i + 1]) {

            // Guardamos el valor temporalmente para no perderlo
            let temporal = numeros[i];
            numeros[i] = numeros[i + 1];
            numeros[i + 1] = temporal;

            // Marcamos que hubo al menos un intercambio
            huboIntercambio = true;
        }
    }

// El do-while sigue mientras haya intercambios pendientes
} while (huboIntercambio);

console.log("Números ordenados:", numeros);


// ----------------------------------------------------------
// PASO 4: Identificar el mayor y el menor
// ----------------------------------------------------------
// Después del ordenamiento burbuja:
//   - El MENOR queda en la posición 0 (inicio del arreglo)
//   - El MAYOR queda en la última posición (length - 1)

let menor = numeros[0];
let mayor = numeros[numeros.length - 1];


// ----------------------------------------------------------
// PASO 5: Preparar el mensaje de resultado
// ----------------------------------------------------------
// Caso especial: si mayor === menor, los tres son iguales.

let mensaje;

if (mayor === menor) {
    mensaje = "⚠️ Los tres números ingresados son idénticos: " + mayor;
} else {
    mensaje = "✅ Número MAYOR: " + mayor + "\n✅ Número MENOR: " + menor;
}

console.log(mensaje);


// ----------------------------------------------------------
// PASO 6: Mostrar el resultado al usuario
// ----------------------------------------------------------
// Mostramos el resultado en una alerta emergente...
window.alert(mensaje);

// ...y también lo escribimos en la página web dentro del <div id="resultado">
document.getElementById("resultado").innerHTML =
    "<strong>Números ingresados:</strong> " + [numero1, numero2, numero3].join(", ") +
    "<br><strong>Números ordenados:</strong> " + numeros.join(", ") +
    "<br><br>" + mensaje.replace(/\n/g, "<br>");
