// ============================================================
// MÓDULO 4 – LECCIÓN 5: Consumo de API REST
// Rick and Morty API – https://rickandmortyapi.com
// ============================================================
// Conceptos que practicas en este ejercicio:
//   - fetch()          → petición HTTP a una API externa
//   - Promesas / .then() → manejar respuestas asíncronas
//   - async / await    → sintaxis moderna para código asíncrono
//   - .json()          → convertir la respuesta en objeto JavaScript
//   - .map()           → transformar un array en otro
//   - .reduce()        → agrupar datos en un objeto
//   - .sort()          → ordenar arrays alfabéticamente
//   - Caché en memoria → evitar llamadas repetidas a la API
// ============================================================


// ============================================================
// CACHÉ LOCAL
// ============================================================
// Variable global donde se guardan los personajes la primera vez.
// Si ya tiene datos, no se vuelve a llamar a la API.

let cachePersonajes = null;     // null = aún no se ha cargado

const API_URL = "https://rickandmortyapi.com/api/character/1,2,3,4,5,6,7,8,9,10";


// ============================================================
// FUNCIÓN: cargarPersonajes()
// ============================================================
// Botón "Obtener personajes".
// Primera llamada → fetch() a la API → guarda en caché.
// Llamadas siguientes → usa los datos del caché local.

async function cargarPersonajes() {

    const btnCargar = document.getElementById("btn-cargar");
    const estado    = document.getElementById("estado");

    // ── Si ya tenemos los datos en caché, no llamamos a la API ──
    if (cachePersonajes !== null) {
        estado.textContent = "✓ Datos obtenidos desde el caché local (sin llamada a la API).";
        document.getElementById("badge-cache").style.display = "inline-block";
        renderLista(cachePersonajes);
        habilitarBotones();
        return;                 // salir de la función aquí
    }

    // ── Primera vez: hacer la petición HTTP ──
    try {
        estado.textContent = "⏳ Contactando la API de Rick & Morty...";
        btnCargar.disabled = true;

        // fetch() devuelve una Promesa con la respuesta HTTP
        const respuesta = await fetch(API_URL);

        // Si el servidor responde con error (ej: 404, 500)
        if (!respuesta.ok) {
            throw new Error(`Error HTTP: ${respuesta.status}`);
        }

        // .json() convierte el cuerpo de la respuesta en un array de objetos JS
        const datos = await respuesta.json();

        // Guardar en caché para no repetir la llamada
        cachePersonajes = datos;

        console.log("Datos recibidos de la API:", datos);

        estado.textContent = `✓ ${datos.length} personajes cargados desde la API. Las siguientes llamadas usarán el caché.`;
        document.getElementById("badge-cache").style.display = "none";

        renderLista(cachePersonajes);
        habilitarBotones();

    } catch (error) {
        estado.textContent = `❌ Error al conectar con la API: ${error.message}`;
        console.error("Error en fetch:", error);
        btnCargar.disabled = false;
    }
}


// ============================================================
// FUNCIÓN: renderLista(personajes)
// ============================================================
// Construye y muestra la lista de personajes en el <ul>.
// Al hacer clic en un personaje se muestra su ficha.

function renderLista(personajes) {

    const lista = document.getElementById("lista-personajes");

    // .map() transforma cada personaje en un <li> HTML
    lista.innerHTML = personajes.map(p => `
        <li onclick="mostrarFicha(${p.id})">
            <img src="${p.image}" alt="${p.name}" loading="lazy">
            <span class="id-badge">${p.id}</span>
            <span class="nombre">${p.name}</span>
            <span class="especie">${p.species}</span>
        </li>
    `).join("");   // join("") une el array de strings en uno solo

    console.log("Lista renderizada en la página.");
}


// ============================================================
// FUNCIÓN: mostrarGrupos()
// ============================================================
// Botón "Agrupar por especie".
// Usa .reduce() para agrupar los personajes según su especie
// y los muestra ordenados alfabéticamente.

function mostrarGrupos() {

    if (!cachePersonajes) return;

    // .reduce() recorre el array y construye un objeto agrupado:
    // {
    //   "Human": [ {id:1, name:"Rick"}, {id:2, name:"Morty"}, ... ],
    //   "Alien": [ {id:6, name:"Abadango..."} ]
    // }
    const grupos = cachePersonajes.reduce(function(acumulador, personaje) {

        const especie = personaje.species;

        // Si la especie aún no existe como clave, la creamos con array vacío
        if (!acumulador[especie]) {
            acumulador[especie] = [];
        }

        // Agregamos el personaje al grupo de su especie
        acumulador[especie].push(personaje);

        return acumulador;

    }, {});   // {} es el valor inicial del acumulador

    console.log("Grupos por especie:", grupos);

    // Ordenar las especies alfabéticamente con .sort()
    const especiesOrdenadas = Object.keys(grupos).sort();

    // Construir el HTML de cada grupo
    const html = especiesOrdenadas.map(especie => {

        // Lista de personajes dentro de esa especie
        const items = grupos[especie]
            .map(p => `<li>${p.name} <span>(ID: ${p.id})</span></li>`)
            .join("");

        return `
            <div class="grupo-especie">
                <h3>${especie} (${grupos[especie].length})</h3>
                <ul>${items}</ul>
            </div>
        `;
    }).join("");

    document.getElementById("grupos-especie").innerHTML = html;
}


// ============================================================
// FUNCIÓN: mostrarFicha(id)
// ============================================================
// Busca el personaje por id en el caché y muestra su ficha.
// También se puede llamar al hacer clic en un elemento de la lista.

function mostrarFicha(id) {

    if (!cachePersonajes) return;

    // .find() devuelve el primer elemento que cumple la condición
    const personaje = cachePersonajes.find(p => p.id === id);

    if (!personaje) return;

    // Sincronizar el <select> con el personaje seleccionado
    document.getElementById("select-personaje").value = id;

    const ficha = document.getElementById("ficha-personaje");

    ficha.style.display = "flex";
    ficha.innerHTML = `
        <img src="${personaje.image}" alt="${personaje.name}">
        <div class="ficha-datos">
            <p><span class="label">ID:</span>      ${personaje.id}</p>
            <p><span class="label">Nombre:</span>  ${personaje.name}</p>
            <p><span class="label">Especie:</span> ${personaje.species}</p>
            <p><span class="label">Estado:</span>  ${personaje.status}</p>
            <p><span class="label">Género:</span>  ${personaje.gender}</p>
            <p><span class="label">Origen:</span>  ${personaje.origin.name}</p>
        </div>
    `;

    console.log("Ficha mostrada:", personaje.name);
}


// ============================================================
// FUNCIÓN: mostrarFichaSeleccionada()
// ============================================================
// Lee el <select> y llama a mostrarFicha() con el id elegido.

function mostrarFichaSeleccionada() {
    const id = parseInt(document.getElementById("select-personaje").value);
    mostrarFicha(id);
}


// ============================================================
// FUNCIÓN: habilitarBotones()
// ============================================================
// Activa los botones de agrupación y ficha una vez que los
// datos están disponibles, y llena el <select> de personajes.

function habilitarBotones() {

    document.getElementById("btn-grupos").disabled = false;
    document.getElementById("btn-ficha").disabled  = false;

    const select = document.getElementById("select-personaje");
    select.disabled = false;

    // Llenar el <select> con los personajes cargados
    select.innerHTML = cachePersonajes.map(p =>
        `<option value="${p.id}">${p.id}. ${p.name}</option>`
    ).join("");
}
