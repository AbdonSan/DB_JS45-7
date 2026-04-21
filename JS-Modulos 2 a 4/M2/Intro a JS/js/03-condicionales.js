// ===========================
// CONDICIONALES
// ===========================

let valor=10;

if(valor>9){
   // alert("Verdad");
}else{
   // alert("Falso");
}


let edadUsuario = 18;
let resultado = "";

// --- if / else if / else ---
if (edadUsuario >= 18) {
    resultado = "Es mayor de edad ✓";
} else if (edadUsuario >= 13) {
    resultado = "Es adolescente";
} else {
    resultado = "Es menor de edad";
}
//alert(resultado);

// --- Operador ternario (forma corta de if/else) ---
// Sintaxis: condición ? valorSiTrue : valorSiFalse
// Útil para asignaciones simples, no abusar con lógica compleja
let acceso = edadUsuario >= 18 ? "Permitido" : "Denegado";
//alert(acceso);


// --- switch: útil cuando comparas una variable contra muchos valores fijos ---
// Cada case necesita break, si no se "cae" al siguiente caso
let dia = 7;
let nombreDia = "";

switch (dia) {
    case 1:
        nombreDia = "Lunes";
        break;
    case 2:
        nombreDia = "Martes";
        break;
    case 3:
        nombreDia = "Miércoles";
        break;
    case 4:
        nombreDia = "Jueves";
        break;
    case 5:
        nombreDia = "Viernes";
        break;
    case 6:
        nombreDia = "Sabado";
        break;
    case 7:
        nombreDia = "Domingo";
        break;
    default:
        nombreDia = "Numero de dia no valido";
}

alert(nombreDia);

console.log("--- CONDICIONALES ---");
console.log("Edad:", edadUsuario, "→", resultado);
console.log("Acceso:", acceso);
console.log("Día", dia, "→", nombreDia);

// --- Mostrar en la página ---
document.getElementById("condicionales").innerHTML =
    `<strong>if/else:</strong> edad = ${edadUsuario} → ${resultado}<br>` +
    `<strong>Ternario:</strong> acceso → ${acceso}<br>` +
    `<strong>switch:</strong> día ${dia} → ${nombreDia}`;
