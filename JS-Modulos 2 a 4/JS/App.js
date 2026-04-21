// Creación de variables
let Name = "Jennifer";
let LastName = "Céspedes Aragón";
let Country = "Perú";
let Active = true;

//Las variables imaginalo elementos que almacenan información de manera temporal, 
// por que manera temporal por que esta activo mientras esta en ejecución en pantalla
//let Name

//por otro lado lo que agregas a continuacion que es el texto entre comillas "Texto" eso recien es lo que se muetra 
//en pantalla


// Imprimir las variables, 
// Se pueden imprimir por consola cosole.log pero recuerda que esto solo se ve en la terminal de tu navegador con F12
console.log(Name);
console.log(LastName);
console.log(Country);
console.log(Active);

//es otra forma de imprimir por pantalla pero este es visual te muestra con un poopup el mensaje
alert(Name);
alert(LastName);
alert(Country);
alert(Active);

// Nota: Las variables `numero1` y `numero2` deben estar definidas previamente para evitar errores.
let numero1 = 10; // Ejemplo de valores de prueba
let numero2 = 5;

// Operaciones matemáticas
let resSuma = numero1 + numero2;
let resResta = numero1 - numero2;
let resMulti = numero1 * numero2;

console.log("Resultado de la suma: ", resSuma);
console.log("Resultado de la resta: ", resResta);
console.log("Resultado de la resta: ", resMulti);

// Crear un arreglo
let personas = ["Pedro", "Juan", "Maria"];

// Imprimir arreglo
console.log(personas);

// --- Mostrar en la página ---
document.getElementById("Tarea").innerHTML = `
    <strong>Nombre:</strong> ${Name}<br>
    <strong>Apellido:</strong> ${LastName}<br>
    <strong>País:</strong> ${Country}<br>
    <strong>Activo:</strong> ${Active}`;