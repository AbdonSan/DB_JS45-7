// Solicitar el diámetro al usuario
let diametro = prompt("Ingresa el diámetro del círculo:");

// Calcular el radio
let radio = diametro / 2;

// Calcular el área usando Math.PI y Math.pow
let area = Math.PI * Math.pow(radio, 2);

// Mostrar el resultado en consola
console.log("El área del círculo es: " + area);

// Mostrar el resultado en una ventana emergente
window.alert("El área del círculo es: " + area);

// Mostrar el resultado en la página web
document.getElementById("resultado").innerHTML = "El área del círculo con diámetro " + diametro + " es: " + area.toFixed(2);
