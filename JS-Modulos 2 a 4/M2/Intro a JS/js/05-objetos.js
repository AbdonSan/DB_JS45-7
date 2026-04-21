// ===========================
// OBJETOS
// ===========================

// --- Crear un objeto ---
// Un objeto agrupa datos relacionados en pares clave: valor
let persona = {
    nombre: "Angel",
    edad: 25,
    pais: "México",
    activo: true
};

// --- Acceder a propiedades (2 formas) ---
let nom = persona.nombre;        // notación de punto — la más común
let ed = persona["edad"];        // notación de corchetes — útil cuando la clave es dinámica

// --- Modificar propiedades ---
persona.edad = 26;

// --- Agregar propiedades ---
persona.email = "angel@email.com";

// --- Objeto dentro de objeto ---
let curso = {
    titulo: "Intro a JavaScript",
    nivel: "Básico",
    profesor: {
        nombre: "Carlos",
        experiencia: 5
    }
};

let profNombre = curso.profesor.nombre; // "Carlos"

console.log("--- OBJETOS ---");
console.log("Persona:", persona);
console.log("Curso:", curso);
console.log("Profesor:", profNombre);

// --- Mostrar en la página ---
document.getElementById("objetos").innerHTML =
    `<strong>persona.nombre:</strong> ${persona.nombre}<br>` +
    `<strong>persona["edad"]:</strong> ${persona.edad}<br>` +
    `<strong>persona.email:</strong> ${persona.email}<br>` +
    `<strong>curso.profesor.nombre:</strong> ${profNombre}<br>` +
    `<strong>Objeto completo:</strong> ${JSON.stringify(persona)}`;
