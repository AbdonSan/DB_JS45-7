// ============================================================
// MÓDULO 4 – LECCIÓN 4: Funciones Callback en JavaScript
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - Callback          → función pasada como argumento a otra función
//   - isNaN()           → detectar si un valor NO es un número
//   - setTimeout()      → ejecutar código después de N milisegundos
//   - Arrow functions   → sintaxis compacta: (param) => expresión
//   - Bucles for        → calcular sumatorias
//   - Condicionales     → elegir qué callback ejecutar
// ============================================================
//
// ¿Qué es un Callback?
// ---------------------
// Un callback es simplemente una función que se pasa como
// argumento a otra función para que sea llamada después,
// generalmente cuando termina algún proceso o según el resultado.
//
// Ejemplo básico:
//   function saludar(nombre, callback) {
//       let mensaje = "Hola, " + nombre;
//       callback(mensaje);   ← llama a la función que recibió
//   }
//   saludar("Ana", function(m) { console.log(m); });
//   → imprime "Hola, Ana"
// ============================================================


// ============================================================
// FUNCIÓN AUXILIAR: mostrarSalida(id, mensaje, tipo)
// ============================================================
// Muestra un mensaje con estilo visual (ok / error / info / espera)
// en el <div> con el id indicado.

function mostrarSalida(id, mensaje, tipo) {
    const div = document.getElementById(id);
    div.innerHTML  = mensaje;
    div.className  = `salida ${tipo}`;  // aplica la clase de color
    div.style.display = "block";        // lo hace visible
}


// ============================================================
// EJERCICIO 1 – validar_numero(callback)
// ============================================================
// Muestra un prompt y valida si lo ingresado es un número.
// Llama al callback con el resultado (éxito o error).
//
// Parámetro:
//   callback → función que recibe (esValido, dato, mensaje)

function validar_numero(callback) {

    // prompt() solicita un dato al usuario (siempre devuelve string o null)
    let dato = prompt("Ingrese un número:");

    // Si el usuario presionó Cancelar → dato llega como null
    if (dato === null) {
        callback(false, dato, "El usuario canceló la entrada.");
        return;
    }

    // isNaN("") devuelve true para strings vacíos, los tratamos como error
    if (dato.trim() === "") {
        callback(false, dato, "No ingresaste ningún valor.");
        return;
    }

    // !isNaN(dato) → true si dato SÍ es un número válido
    if (!isNaN(dato)) {
        callback(true, dato, `El número ${dato} es válido. ✓`);
    } else {
        callback(false, dato, `Usted ingresó caracteres incorrectos: "${dato}"`);
    }
}

// Función que ejecuta el ejercicio 1 desde el botón del HTML
function ejecutarValidar() {

    // Definimos el callback como función anónima
    validar_numero(function(esValido, dato, mensaje) {

        console.log("Ejercicio 1 →", mensaje);

        if (esValido) {
            mostrarSalida("salida-validar", mensaje, "ok");
        } else {
            mostrarSalida("salida-validar", mensaje, "error");
        }
    });
}


// ============================================================
// EJERCICIO 2 – calcular_y_avisar_despues(numero, callback)
// ============================================================
// Calcula la sumatoria de números IMPARES entre 1 y numero.
// Espera 5 segundos y luego ejecuta el callback con el resultado.
//
// Parámetros:
//   numero   → límite superior del rango
//   callback → función que recibe el resultado después de 5 s

function calcular_y_avisar_despues(numero, callback) {

    // --- Calcular sumatoria de impares ---
    let sumatoria = 0;
    for (let i = 1; i <= numero; i++) {
        // i % 2 !== 0 → true cuando i es impar
        if (i % 2 !== 0) {
            sumatoria += i;
        }
    }

    console.log(`Ejercicio 2 → sumatoria impares hasta ${numero}: ${sumatoria}. Esperando 5 s...`);

    // --- setTimeout: ejecuta el callback después de 5000 ms (5 s) ---
    // La función flecha (arrow function) () => {} se pasa como argumento
    // a setTimeout y se ejecuta una sola vez cuando termina el tiempo.
    setTimeout(() => {
        callback(sumatoria, numero);
    }, 5000);
}

// Función que ejecuta el ejercicio 2 desde el botón del HTML
function ejecutarDespues() {

    const numero = parseInt(document.getElementById("num-despues").value);

    if (isNaN(numero) || numero < 1) {
        mostrarSalida("salida-despues", "Ingresa un número válido mayor a 0.", "error");
        return;
    }

    // Mensaje de espera visible mientras corre el setTimeout
    mostrarSalida("salida-despues",
        `⏳ Calculando sumatoria de impares hasta ${numero}... espera 5 segundos.`,
        "espera");

    // Llamamos a la función pasando el callback como argumento
    calcular_y_avisar_despues(numero, function(resultado, n) {

        // Esta función se ejecuta DESPUÉS de 5 segundos
        const mensaje = `El valor de la sumatoria de impares hasta ${n} es <strong>${resultado}</strong>. Este resultado se obtuvo hace 5 segundos.`;
        mostrarSalida("salida-despues", mensaje, "ok");
        console.log(`Ejercicio 2 → callback ejecutado: sumatoria = ${resultado}`);
    });
}


// ============================================================
// EJERCICIO 3 – calcular_y_avisar_dependiendo(numero, callback, callback_error)
// ============================================================
// Calcula las sumatorias SUCESIVAS desde 1 hasta numero:
//   i=1: 1
//   i=2: 1 + 2 = 3
//   i=3: 1 + 2 + 3 = 6
//   ...
//   El total final = suma de todos esos resultados parciales.
//
// Si total < 1000  → llama a callback (éxito)
// Si total >= 1000 → llama a callback_error (límite superado)
//
// Parámetros:
//   numero         → límite de las sumatorias
//   callback       → función de éxito
//   callback_error → función de error

function calcular_y_avisar_dependiendo(numero, callback, callback_error) {

    let total = 0;
    let lineas = [];    // para guardar cada fila de la sumatoria sucesiva

    // Bucle externo: cada iteración es una sumatoria parcial
    for (let i = 1; i <= numero; i++) {

        let parcial = 0;
        let terminos = [];

        // Bucle interno: acumula desde 1 hasta i
        for (let j = 1; j <= i; j++) {
            parcial  += j;
            terminos.push(j);  // guarda cada término para mostrar la ecuación
        }

        total += parcial;
        // Construye la línea "1 + 2 + 3 = 6"
        lineas.push(`${terminos.join(" + ")} = ${parcial}`);
    }

    console.log(`Ejercicio 3 → número: ${numero} | total: ${total}`);
    lineas.forEach(l => console.log("  ", l));

    // Decidir qué callback ejecutar según el resultado
    if (total < 1000) {
        callback(numero, total, lineas);
    } else {
        callback_error(numero, total, lineas);
    }
}

// Función que ejecuta el ejercicio 3 desde el botón del HTML
function ejecutarDependiendo() {

    const numero = parseInt(document.getElementById("num-depend").value);

    if (isNaN(numero) || numero < 1) {
        mostrarSalida("salida-depend", "Ingresa un número válido mayor a 0.", "error");
        return;
    }

    // Ocultar resultados anteriores
    document.getElementById("lista-sumatorias").style.display = "none";
    document.getElementById("salida-depend").style.display    = "none";

    // Llamamos con DOS callbacks: uno de éxito y uno de error
    calcular_y_avisar_dependiendo(
        numero,

        // callback (éxito): total < 1000
        function(n, total, lineas) {
            document.getElementById("lista-sumatorias").innerHTML = lineas.join("<br>");
            document.getElementById("lista-sumatorias").style.display = "block";

            mostrarSalida(
                "salida-depend",
                `Las sumatorias sucesivas de <strong>${n}</strong> dan un total de <strong>${total}</strong>.`,
                "ok"
            );
        },

        // callback_error (límite superado): total >= 1000
        function(n, total, lineas) {
            document.getElementById("lista-sumatorias").innerHTML = lineas.join("<br>");
            document.getElementById("lista-sumatorias").style.display = "block";

            mostrarSalida(
                "salida-depend",
                `⚠️ El número <strong>${n}</strong> sobrepasa el objetivo de la función (límite: 1000).<br>
                 El resultado obtenido fue <strong>${total}</strong>, que supera el límite permitido.`,
                "error"
            );
        }
    );
}
