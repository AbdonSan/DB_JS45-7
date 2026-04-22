// ============================================================
// ESCENARIO 2 – Catálogo Sony Chile
// Jerarquía de productos usando herencia
// ============================================================
// Árbol de herencia:
//
//   ProductoSony  (clase base)
//   ├── Televisor
//   ├── Camara
//   ├── Audio
//   ├── Consola
//   └── Accesorio
// ============================================================


// ----------------------------------------------------------
// CLASE BASE: ProductoSony
// ----------------------------------------------------------
// Atributos y métodos comunes a todos los productos Sony.

class ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses) {
        this.nombre         = nombre;
        this.modelo         = modelo;
        this.precio         = precio;           // precio en pesos chilenos
        this.garantiaMeses  = garantiaMeses;
    }

    // Método heredado por todas las subclases
    mostrarInfo() {
        console.log(`[${this.constructor.name}] ${this.nombre} (${this.modelo}) - $${this.precio.toLocaleString("es-CL")} | Garantía: ${this.garantiaMeses} meses`);
    }

    // Formatea el precio con separadores de miles
    precioFormateado() {
        return `$${this.precio.toLocaleString("es-CL")}`;
    }

    // HTML de atributos comunes (usado en la página)
    htmlBase() {
        return `
            <p><span class="etiqueta">Nombre:</span>   ${this.nombre}</p>
            <p><span class="etiqueta">Modelo:</span>   ${this.modelo}</p>
            <p><span class="etiqueta">Precio:</span>   ${this.precioFormateado()}</p>
            <p><span class="etiqueta">Garantía:</span> ${this.garantiaMeses} meses</p>
        `;
    }
}


// ----------------------------------------------------------
// SUBCLASE: Televisor
// ----------------------------------------------------------

class Televisor extends ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses, pulgadas, resolucion, smartTv) {
        super(nombre, modelo, precio, garantiaMeses);
        this.pulgadas    = pulgadas;
        this.resolucion  = resolucion;  // ej: "4K", "8K", "Full HD"
        this.smartTv     = smartTv;     // true / false
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  → ${this.pulgadas}" | ${this.resolucion} | Smart TV: ${this.smartTv ? "Sí" : "No"}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: Camara
// ----------------------------------------------------------

class Camara extends ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses, megapixeles, tipo) {
        super(nombre, modelo, precio, garantiaMeses);
        this.megapixeles = megapixeles;
        this.tipo        = tipo;    // ej: "Mirrorless", "Compacta", "DSLR"
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  → ${this.megapixeles} MP | Tipo: ${this.tipo}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: Audio
// ----------------------------------------------------------

class Audio extends ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses, tipo, inalambrico) {
        super(nombre, modelo, precio, garantiaMeses);
        this.tipo        = tipo;            // ej: "Audífonos", "Parlante", "Soundbar"
        this.inalambrico = inalambrico;     // true / false
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  → Tipo: ${this.tipo} | Inalámbrico: ${this.inalambrico ? "Sí" : "No"}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: Consola
// ----------------------------------------------------------

class Consola extends ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses, almacenamientoGB, version) {
        super(nombre, modelo, precio, garantiaMeses);
        this.almacenamientoGB = almacenamientoGB;
        this.version          = version;    // ej: "Digital", "Standard"
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  → ${this.almacenamientoGB} GB | Versión: ${this.version}`);
    }
}


// ----------------------------------------------------------
// SUBCLASE: Accesorio
// ----------------------------------------------------------

class Accesorio extends ProductoSony {
    constructor(nombre, modelo, precio, garantiaMeses, compatibleCon) {
        super(nombre, modelo, precio, garantiaMeses);
        this.compatibleCon = compatibleCon; // array con productos compatibles
    }

    mostrarInfo() {
        super.mostrarInfo();
        console.log(`  → Compatible con: ${this.compatibleCon.join(", ")}`);
    }
}


// ----------------------------------------------------------
// INSTANCIAS – productos del catálogo Sony Chile
// ----------------------------------------------------------

const tv1      = new Televisor("BRAVIA XR A80L", "XR-65A80L",  1599990, 12, 65, "4K OLED",  true);
const camara1  = new Camara   ("Alpha 7 IV",     "ILCE-7M4",   1899990, 12, 33, "Mirrorless");
const audio1   = new Audio    ("WH-1000XM5",     "WH1000XM5",  349990,  12, "Audífonos", true);
const consola1 = new Consola  ("PlayStation 5",  "CFI-1200A",  549990,  12, 825, "Standard");
const acceso1  = new Accesorio("DualSense",       "CFI-ZCT1W",  79990,   6,  ["PS5"]);

const catalogo = [tv1, camara1, audio1, consola1, acceso1];

console.log("=== CATÁLOGO SONY CHILE ===");
catalogo.forEach(producto => producto.mostrarInfo());


// ----------------------------------------------------------
// Mostrar en la página
// ----------------------------------------------------------

// Mapa de tipo de clase → etiqueta de color y datos extra
function extrasSony(producto) {
    if (producto instanceof Televisor) {
        return `<p><span class="etiqueta">Pantalla:</span> ${producto.pulgadas}" | ${producto.resolucion} | Smart TV: ${producto.smartTv ? "Sí" : "No"}</p>`;
    }
    if (producto instanceof Camara) {
        return `<p><span class="etiqueta">Sensor:</span> ${producto.megapixeles} MP | Tipo: ${producto.tipo}</p>`;
    }
    if (producto instanceof Audio) {
        return `<p><span class="etiqueta">Tipo:</span> ${producto.tipo} | Inalámbrico: ${producto.inalambrico ? "Sí" : "No"}</p>`;
    }
    if (producto instanceof Consola) {
        return `<p><span class="etiqueta">Almacenamiento:</span> ${producto.almacenamientoGB} GB | Versión: ${producto.version}</p>`;
    }
    if (producto instanceof Accesorio) {
        return `<p><span class="etiqueta">Compatible con:</span> ${producto.compatibleCon.join(", ")}</p>`;
    }
    return "";
}

const htmlSony = catalogo.map(producto => `
    <div class="tarjeta">
        <span class="tipo">${producto.constructor.name}</span>
        ${producto.htmlBase()}
        ${extrasSony(producto)}
    </div>
`).join("");

document.getElementById("sony-contenedor").innerHTML = htmlSony;
