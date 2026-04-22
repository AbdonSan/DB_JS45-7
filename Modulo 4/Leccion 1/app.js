// ============================================================
// MÓDULO 4 – LECCIÓN 1: Clases y Objetos
// Programación Orientada a Objetos (POO) en JavaScript
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - class             → define un molde/plantilla para objetos
//   - constructor()     → método especial que inicializa los atributos
//   - this              → referencia al objeto actual
//   - Métodos           → funciones dentro de una clase
//   - new               → crea una instancia (objeto) de una clase
//   - Template literals → strings con expresiones: `Hola ${nombre}`
//   - Arrays en objetos → atributos que son listas de valores
// ============================================================


// ============================================================
// CLASE 1: Alumno
// ============================================================
// Una clase es un molde. A partir de ese molde puedes crear
// tantos objetos (instancias) como necesites, cada uno con
// sus propios valores en los atributos.

class Alumno {

    // El constructor se ejecuta automáticamente cuando usas "new".
    // Recibe los datos iniciales y los guarda en "this" (el objeto).
    constructor(nombre, edad, carrera, promedio) {
        this.nombre   = nombre;
        this.edad     = edad;
        this.carrera  = carrera;
        this.promedio = promedio;
    }

    // Método: función que pertenece a la clase.
    // Muestra todos los atributos en la consola.
    mostrarInfo() {
        console.log("=== Alumno ===");
        console.log(`Nombre:   ${this.nombre}`);
        console.log(`Edad:     ${this.edad} años`);
        console.log(`Carrera:  ${this.carrera}`);
        console.log(`Promedio: ${this.promedio}`);
    }

    // Método: muestra el resultado en la página web.
    mostrarEnPagina() {
        document.getElementById("alumno").innerHTML = `
            <p><span class="etiqueta">Nombre:</span>   ${this.nombre}</p>
            <p><span class="etiqueta">Edad:</span>     ${this.edad} años</p>
            <p><span class="etiqueta">Carrera:</span>  ${this.carrera}</p>
            <p><span class="etiqueta">Promedio:</span> ${this.promedio}</p>
        `;
    }
}

// ----------------------------------------------------------
// Crear una instancia (objeto) de la clase Alumno
// ----------------------------------------------------------
// "new Alumno(...)" llama al constructor con los valores indicados
// y devuelve un objeto con todos los atributos y métodos definidos.

const alumno1 = new Alumno("María González", 22, "Ingeniería Informática", 6.2);

// Llamar a los métodos del objeto
alumno1.mostrarInfo();          // imprime en consola
alumno1.mostrarEnPagina();      // muestra en la página


// ============================================================
// CLASE 2: Banda Musical
// ============================================================

class BandaMusical {

    constructor(nombre, genero, integrantes, discos) {
        this.nombre       = nombre;
        this.genero       = genero;
        this.integrantes  = integrantes;    // número de integrantes
        this.discos       = discos;         // array con nombres de discos
    }

    // Muestra toda la información de la banda en consola
    mostrarInfo() {
        console.log("=== Banda Musical ===");
        console.log(`Banda:        ${this.nombre}`);
        console.log(`Género:       ${this.genero}`);
        console.log(`Integrantes:  ${this.integrantes}`);
        // join(", ") convierte el array en un texto separado por comas
        console.log(`Discos:       ${this.discos.join(", ")}`);
    }

    // Muestra solo la lista de discos publicados
    listarDiscos() {
        console.log(`Discografía de ${this.nombre}:`);
        // forEach recorre cada elemento del array
        this.discos.forEach(function(disco, indice) {
            console.log(`  ${indice + 1}. ${disco}`);
        });
    }

    // Muestra en la página web
    mostrarEnPagina() {
        // Construimos la lista de discos como ítems HTML
        let listaDiscos = this.discos
            .map(function(disco, i) {
                return `<li>${i + 1}. ${disco}</li>`;
            })
            .join("");

        document.getElementById("banda").innerHTML = `
            <p><span class="etiqueta">Banda:</span>       ${this.nombre}</p>
            <p><span class="etiqueta">Género:</span>      ${this.genero}</p>
            <p><span class="etiqueta">Integrantes:</span> ${this.integrantes}</p>
            <div class="discos">
                <span class="etiqueta">Discografía:</span>
                <ul>${listaDiscos}</ul>
            </div>
        `;
    }
}

// ----------------------------------------------------------
// Instancia de BandaMusical – Los Beatles
// ----------------------------------------------------------

const banda1 = new BandaMusical(
    "The Beatles",
    "Rock / Pop",
    4,
    ["Please Please Me", "With the Beatles", "A Hard Day's Night",
     "Help!", "Rubber Soul", "Revolver", "Sgt. Pepper's Lonely Hearts Club Band",
     "Abbey Road", "Let It Be"]
);

banda1.mostrarInfo();       // info completa en consola
banda1.listarDiscos();      // solo discos en consola
banda1.mostrarEnPagina();   // en la página web


// ============================================================
// CLASE 3: Perro
// ============================================================

class Perro {

    constructor(nombre, raza, edad, color) {
        this.nombre = nombre;
        this.raza   = raza;
        this.edad   = edad;
        this.color  = color;
    }

    // Muestra todos los atributos del perro en consola
    mostrarInfo() {
        console.log("=== Perro ===");
        console.log(`Nombre: ${this.nombre}`);
        console.log(`Raza:   ${this.raza}`);
        console.log(`Edad:   ${this.edad} años`);
        console.log(`Color:  ${this.color}`);
    }

    // Método que simula el ladrido del perro
    ladrar() {
        console.log(`${this.nombre} dice: ¡Guau guau! 🐾`);
    }

    // Muestra en la página web
    mostrarEnPagina() {
        document.getElementById("perro").innerHTML = `
            <p><span class="etiqueta">Nombre:</span> ${this.nombre}</p>
            <p><span class="etiqueta">Raza:</span>   ${this.raza}</p>
            <p><span class="etiqueta">Edad:</span>   ${this.edad} años</p>
            <p><span class="etiqueta">Color:</span>  ${this.color}</p>
            <p><span class="etiqueta">Sonido:</span> ¡Guau guau!</p>
        `;
    }
}

// ----------------------------------------------------------
// Instancia de Perro – Laika (perro famoso)
// ----------------------------------------------------------

const perro1 = new Perro("Laika", "Mestiza", 3, "Marrón y negro");

perro1.mostrarInfo();       // en consola
perro1.ladrar();            // simula el ladrido en consola
perro1.mostrarEnPagina();   // en la página web


// ============================================================
// BONUS: Crear múltiples instancias del mismo molde
// ============================================================
// Aquí se muestra que una misma clase puede generar muchos objetos
// distintos. Cada uno tiene sus propios valores pero comparte
// los mismos métodos definidos en la clase.

const alumno2 = new Alumno("Carlos Pérez", 25, "Diseño Gráfico", 5.8);
const alumno3 = new Alumno("Ana Torres", 20, "Administración", 6.7);

console.log("--- Otros alumnos ---");
alumno2.mostrarInfo();
alumno3.mostrarInfo();
