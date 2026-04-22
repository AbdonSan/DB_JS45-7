# Módulo 4 – Lección 5: Consumo de API REST

## Objetivo
Aprender a obtener datos desde una API externa usando `fetch()`, manipular los resultados con métodos de array y mostrarlos en una interfaz. Además, implementar una estrategia de caché para evitar llamadas repetidas al servidor.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Interfaz visual con lista, grupos y ficha de personaje |
| `app.js` | Lógica de consumo de API, caché y renderizado |

---

## API utilizada
**Rick and Morty API** – `https://rickandmortyapi.com`

Endpoint usado:
```
GET https://rickandmortyapi.com/api/character/1,2,3,4,5,6,7,8,9,10
```
Devuelve un array de 10 objetos con información de cada personaje.

---

## ¿Qué es una API REST?

Una **API REST** es un servicio en internet que responde peticiones HTTP con datos en formato JSON. El flujo es:

```
Tu código          Internet           Servidor API
────────           ───────            ────────────
fetch(URL)  ──→  petición GET  ──→   procesa y responde
                              ←──   JSON con los datos
.then(res => res.json())  ←──  convierte a objeto JS
```

---

## Concepto central: `fetch()` + `async/await`

### Con `.then()` (Promesas encadenadas)
```js
fetch("https://rickandmortyapi.com/api/character/1")
    .then(res => res.json())        // convierte la respuesta
    .then(data => console.log(data))// usa los datos
    .catch(err => console.error(err));
```

### Con `async/await` (más legible)
```js
async function obtenerPersonaje() {
    try {
        const respuesta = await fetch("...");   // espera la respuesta
        const datos     = await respuesta.json(); // espera la conversión
        console.log(datos);
    } catch (error) {
        console.error(error);
    }
}
```

`await` pausa la ejecución de la función `async` hasta que la Promesa se resuelva, sin bloquear el resto del navegador.

---

## Caché en memoria

La optimización central de este ejercicio: guardar los datos en una variable global para no repetir llamadas a la API.

```js
let cachePersonajes = null;   // null = sin datos aún

async function cargarPersonajes() {

    // Si ya tenemos datos → usarlos directamente
    if (cachePersonajes !== null) {
        renderLista(cachePersonajes);
        return;                         // no hace el fetch
    }

    // Primera vez → llamar a la API
    const res   = await fetch(API_URL);
    const datos = await res.json();

    cachePersonajes = datos;            // guardar para las siguientes llamadas
    renderLista(cachePersonajes);
}
```

| Llamada | ¿Hace fetch? | Tiempo |
|---|---|---|
| 1ª | Sí, llama a la API | ~200–500 ms |
| 2ª, 3ª... | No, usa el caché | Instantáneo |

---

## Métodos de array utilizados

### `.map()` — transformar cada elemento
```js
// Convierte cada personaje en un <li> HTML
personajes.map(p => `<li>${p.name}</li>`).join("")
```

### `.reduce()` — agrupar datos
```js
// Agrupa los personajes por especie
const grupos = personajes.reduce((acum, p) => {
    if (!acum[p.species]) acum[p.species] = [];
    acum[p.species].push(p);
    return acum;
}, {});

// Resultado:
// {
//   "Human": [Rick, Morty, Summer, ...],
//   "Alien": [Abadango Cluster Princess]
// }
```

### `.find()` — buscar un elemento específico
```js
const rick = personajes.find(p => p.id === 1);
// → objeto con los datos de Rick Sanchez
```

### `.sort()` — ordenar alfabéticamente
```js
Object.keys(grupos).sort()
// → ["Alien", "Human"]  (orden alfabético)
```

---

## Estructura del objeto JSON que devuelve la API

```js
{
    id:       1,
    name:     "Rick Sanchez",
    status:   "Alive",
    species:  "Human",
    gender:   "Male",
    origin:   { name: "Earth (C-137)", url: "..." },
    location: { name: "Citadel of Ricks", url: "..." },
    image:    "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
    episode:  ["https://...", "https://...", ...],
    url:      "https://rickandmortyapi.com/api/character/1",
    created:  "2017-11-04T18:48:46.250Z"
}
```

Cada propiedad se accede con `personaje.nombre_propiedad`, por ejemplo `personaje.name` o `personaje.origin.name`.

---

## Manejo de errores con `try/catch`

```js
try {
    const respuesta = await fetch(URL);

    if (!respuesta.ok) {
        throw new Error(`Error HTTP: ${respuesta.status}`);
    }

    const datos = await respuesta.json();

} catch (error) {
    console.error("Error:", error.message);
}
```

| Tipo de error | Cuándo ocurre |
|---|---|
| `!respuesta.ok` | El servidor responde con código 4xx o 5xx |
| `catch(error)` | Sin conexión a internet o URL incorrecta |

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `fetch(url)` | Hace una petición HTTP GET al servidor |
| `async/await` | Espera el resultado de una Promesa sin bloquear el navegador |
| `res.json()` | Convierte el cuerpo de la respuesta de texto a objeto JS |
| Caché en memoria | Variable global para guardar datos y evitar llamadas repetidas |
| `.map()` | Transforma cada elemento de un array |
| `.reduce()` | Acumula valores para agrupar o totalizar |
| `.find()` | Devuelve el primer elemento que cumple una condición |
| `.sort()` | Ordena el array (alfabético por defecto) |
| `Object.keys()` | Devuelve un array con las claves de un objeto |
| `try/catch` | Captura y maneja errores en código asíncrono |

---

## Ejercicio propuesto para practicar

Agrega un botón **"Buscar por nombre"** que:
1. Tenga un `<input type="text">` donde el usuario escribe un nombre.
2. Filtre los personajes del caché con `.filter()`.
3. Muestre solo los personajes cuyo nombre contenga el texto buscado.

**Pista:**
```js
const resultado = cachePersonajes.filter(p =>
    p.name.toLowerCase().includes(texto.toLowerCase())
);
```
