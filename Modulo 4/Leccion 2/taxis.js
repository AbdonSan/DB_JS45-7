// ============================================================
// ESCENARIO 1 – Taxis Urbanos
// Jerarquía de clases con herencia (extends / super)
// ============================================================
// Árbol de herencia:
//
//   Taxi  (clase base / padre)
//   ├── TaxiTradicional   (techo amarillo, licencia A1)
//   ├── TaxiParticular    (auto particular, licencia B)
//   │   ├── TaxiExpress   (autos típicos)
//   │   └── TaxiPremium   (autos de mayor categoría)
//   └── TaxiCargo         (transporta carga, no personas)
//
// Conceptos nuevos:
//   - extends  → la clase hija hereda atributos y métodos del padre
//   - super()  → llama al constructor del padre desde la clase hija
// ============================================================


// ----------------------------------------------------------
// CLASE BASE: Taxi
// ----------------------------------------------------------
// Contiene los atributos comunes a todo tipo de taxi.
// Las clases hijas heredarán estos atributos y podrán agregar más.

class Taxi {
    constructor(placa, marca, modelo, conductor) {
        this.placa     = placa;
        this.marca     = marca;
        this.modelo    = modelo;
        this.conductor = conductor;
    }

    // Método compartido por todas las subclases
    mostrarInfo() {
        console.log(`Placa: ${this.placa} | Marca: ${this.marca} ${this.modelo} | Conductor: ${this.conductor}`);
    }

    // Devuelve un string con la info básica (usado en la página)
    infoBasica() {
        return `
            <p><span class="etiqueta">Placa:</span>     ${this.placa}</p>
            <p><span class="etiqueta">Vehículo:</span>  ${this.marca} ${this.modelo}</p>
            <p><span class="etiqueta">Conductor:</span> ${this.conductor}</p>
        `;
    }
}


// ----------------------------------------------------------
// SUBCLASE: TaxiTradicional
// ----------------------------------------------------------
// "extends Taxi" significa que hereda todo lo que tiene Taxi.
// "super()" llama al constructor de Taxi para inicializar
// los atributos heredados (placa, marca, modelo, conductor).

class TaxiTradicional extends Taxi {
    constructor(placa, marca, modelo, conductor) {
        super(placa, marca, modelo, conductor);  // inicializa atributos del padre
        this.techo   = "Amarillo";               // atributo propio de esta subclase
        this.licencia = "A1";
    }

    mostrarInfo() {
        super.mostrarInfo();    // llama al mostrarInfo() del padre
        console.log(`  Tipo: Taxi Tradicional | Techo: ${this.techo} | Licencia: ${this.licencia}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: TaxiParticular
// ----------------------------------------------------------
// Clase intermedia: hereda de Taxi y es padre de Express y Premium.

class TaxiParticular extends Taxi {
    constructor(placa, marca, modelo, conductor) {
        super(placa, marca, modelo, conductor);
        this.licencia = "B";
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  Tipo: Taxi Particular | Licencia: ${this.licencia}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: TaxiExpress (hereda de TaxiParticular)
// ----------------------------------------------------------

class TaxiExpress extends TaxiParticular {
    constructor(placa, marca, modelo, conductor, tarifa) {
        super(placa, marca, modelo, conductor);
        this.categoria = "Express";
        this.tarifa    = tarifa;    // tarifa por km en pesos
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  Categoría: ${this.categoria} | Tarifa: $${this.tarifa}/km`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: TaxiPremium (hereda de TaxiParticular)
// ----------------------------------------------------------

class TaxiPremium extends TaxiParticular {
    constructor(placa, marca, modelo, conductor, tarifa, extras) {
        super(placa, marca, modelo, conductor);
        this.categoria = "Premium";
        this.tarifa    = tarifa;
        this.extras    = extras;    // array con comodidades extra
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  Categoría: ${this.categoria} | Tarifa: $${this.tarifa}/km | Extras: ${this.extras.join(", ")}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: TaxiCargo (hereda de Taxi)
// ----------------------------------------------------------

class TaxiCargo extends Taxi {
    constructor(placa, marca, modelo, conductor, capacidadKg) {
        super(placa, marca, modelo, conductor);
        this.tipo        = "Cargo";
        this.capacidadKg = capacidadKg;
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  Tipo: Taxi Cargo | Capacidad: ${this.capacidadKg} kg`);
    }
}


// ----------------------------------------------------------
// INSTANCIAS – crear un objeto de cada tipo
// ----------------------------------------------------------

const taxi1  = new TaxiTradicional("BCDF-21", "Toyota",  "Corolla",   "Pedro Rojas");
const taxi2  = new TaxiExpress    ("XKJL-45", "Hyundai", "Accent",    "Laura Muñoz", 950);
const taxi3  = new TaxiPremium    ("MNOP-88", "BMW",     "Serie 3",   "Carlos Vega", 2500, ["Agua fría", "Wi-Fi", "Asiento calefaccionado"]);
const taxi4  = new TaxiCargo      ("QRST-12", "Ford",    "Transit",   "Ana Torres",  800);

console.log("=== TAXIS URBANOS ===");
taxi1.mostrarInfo();
taxi2.mostrarInfo();
taxi3.mostrarInfo();
taxi4.mostrarInfo();


// ----------------------------------------------------------
// Mostrar en la página
// ----------------------------------------------------------

function tarjetaTaxi(tipo, objeto, extras) {
    return `
        <div class="tarjeta">
            <span class="tipo">${tipo}</span>
            ${objeto.infoBasica()}
            ${extras}
        </div>
    `;
}

document.getElementById("taxis-contenedor").innerHTML =
    tarjetaTaxi("Taxi Tradicional", taxi1,
        `<p><span class="etiqueta">Techo:</span> ${taxi1.techo} | <span class="etiqueta">Licencia:</span> ${taxi1.licencia}</p>`) +

    tarjetaTaxi("Taxi Express", taxi2,
        `<p><span class="etiqueta">Licencia:</span> ${taxi2.licencia} | <span class="etiqueta">Tarifa:</span> $${taxi2.tarifa}/km</p>`) +

    tarjetaTaxi("Taxi Premium", taxi3,
        `<p><span class="etiqueta">Licencia:</span> ${taxi3.licencia} | <span class="etiqueta">Tarifa:</span> $${taxi3.tarifa}/km</p>
         <p><span class="etiqueta">Extras:</span> ${taxi3.extras.join(", ")}</p>`) +

    tarjetaTaxi("Taxi Cargo", taxi4,
        `<p><span class="etiqueta">Capacidad:</span> ${taxi4.capacidadKg} kg</p>`);
