// ============================================================
// ESCENARIO 3 – Clase Sumatoria
// ============================================================
// La sumatoria acumulada funciona así:
//   Base = 3
//   Constructor imprime: "Base: 3 → Sumatoria inicial: 3"
//   sumar() → 3 + 3 = 6   → imprime "Sumatoria: 6"
//   sumar() → 6 + 3 = 9   → imprime "Sumatoria: 9"
//   sumar() → 9 + 3 = 12  → imprime "Sumatoria: 12"
//   ...y así cada vez que el usuario presiona el botón
// ============================================================


class Sumatoria {

    // El constructor recibe el número base (aleatorio 1–10)
    constructor(base) {
        this.base      = base;
        this.acumulado = base;  // el acumulado parte igual al base

        // El constructor genera la primera línea de salida
        const mensajeInicial = `Número base: ${this.base} → Sumatoria inicial: ${this.acumulado}`;
        console.log(mensajeInicial);
        this._agregarLinea(mensajeInicial);
    }

    // Método que suma el base al acumulado y muestra el nuevo total
    sumar() {
        this.acumulado += this.base;    // equivale a: this.acumulado = this.acumulado + this.base
        const mensaje = `sumar() ejecutado → ${this.acumulado - this.base} + ${this.base} = ${this.acumulado}`;
        console.log(mensaje);
        this._agregarLinea(mensaje);
    }

    // Método auxiliar: agrega una línea al <div> de salida en la página
    _agregarLinea(texto) {
        const div = document.getElementById("sumatoria-salida");
        div.textContent += texto + "\n";
    }
}


// ----------------------------------------------------------
// Crear el objeto con un número base aleatorio entre 1 y 10
// ----------------------------------------------------------
// El objeto se crea al cargar la página.
// El constructor imprime automáticamente la primera línea.

const base = Math.floor(Math.random() * 10) + 1;
const miSumatoria = new Sumatoria(base);

// Mostrar el número base elegido en la página
document.getElementById("info-base").textContent =
    `Objeto creado con número base aleatorio: ${base}. Presiona el botón para ejecutar sumar().`;


// ----------------------------------------------------------
// Función global llamada desde el botón en index.html
// ----------------------------------------------------------
// El botón tiene onclick="ejecutarSumar()" → llama a esta función.

function ejecutarSumar() {
    miSumatoria.sumar();
}
