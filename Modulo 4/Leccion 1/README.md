# Módulo 4 – Lección 1: Clases y Objetos

## Objetivo
Aprender los conceptos básicos de la Programación Orientada a Objetos (POO) en JavaScript: definir clases con atributos y métodos, e instanciar objetos a partir de ellas.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página HTML con tres secciones para mostrar cada clase |
| `app.js` | Definición de las tres clases y sus instancias |

---

## ¿Qué es la Programación Orientada a Objetos (POO)?
La POO es un paradigma (estilo) de programación que organiza el código en **clases** y **objetos**:

- **Clase** → es el molde o plantilla. Define qué atributos y comportamientos tendrá algo.
- **Objeto** → es una instancia concreta creada a partir de ese molde.

**Analogía:** La clase es como los planos de una casa. El objeto es la casa construida a partir de esos planos. Con los mismos planos puedes construir muchas casas distintas.

---

## Clases desarrolladas en este ejercicio

| Clase | Atributos | Métodos |
|---|---|---|
| `Alumno` | nombre, edad, carrera, promedio | `mostrarInfo()`, `mostrarEnPagina()` |
| `BandaMusical` | nombre, genero, integrantes, discos | `mostrarInfo()`, `listarDiscos()`, `mostrarEnPagina()` |
| `Perro` | nombre, raza, edad, color | `mostrarInfo()`, `ladrar()`, `mostrarEnPagina()` |

---

## Pasos para entender el ejercicio

### Paso 1 – Estructura de una clase
```js
class NombreDeLaClase {
    constructor(atributo1, atributo2) {
        this.atributo1 = atributo1;
        this.atributo2 = atributo2;
    }

    nombreDelMetodo() {
        // lógica del método
    }
}
```

| Parte | Explicación |
|---|---|
| `class` | Palabra clave que inicia la definición de una clase |
| `constructor()` | Método especial que se ejecuta automáticamente al crear un objeto con `new` |
| `this` | Hace referencia al objeto que se está creando en ese momento |
| Métodos | Funciones que pertenecen a la clase y describen sus comportamientos |

---

### Paso 2 – Crear un objeto con `new`
```js
const alumno1 = new Alumno("María González", 22, "Ingeniería Informática", 6.2);
```
- `new` le dice a JavaScript: "crea un nuevo objeto usando la clase `Alumno`".
- Los valores entre paréntesis son los argumentos que recibe el `constructor`.
- El objeto queda guardado en la variable `alumno1`.

**Representación interna del objeto creado:**
```js
alumno1 = {
    nombre:   "María González",
    edad:     22,
    carrera:  "Ingeniería Informática",
    promedio: 6.2
}
```

---

### Paso 3 – Llamar a un método del objeto
```js
alumno1.mostrarInfo();      // ejecuta el método en la consola
alumno1.mostrarEnPagina();  // ejecuta el método en la página
```
Los métodos se llaman con la notación punto: `objeto.metodo()`.

---

### Paso 4 – Clase con array como atributo (`BandaMusical`)
```js
const banda1 = new BandaMusical(
    "The Beatles",
    "Rock / Pop",
    4,
    ["Please Please Me", "Abbey Road", "Let It Be"]
);
```
El atributo `discos` es un **array**. Dentro de los métodos se accede a él con `this.discos` y se pueden usar métodos de array como:

```js
this.discos.join(", ")   // une todos los discos en un texto
this.discos.forEach(...)  // recorre cada disco del array
this.discos.map(...)      // transforma cada disco en otro valor
```

---

### Paso 5 – Template literals (backticks)
```js
console.log(`Nombre: ${this.nombre}, Edad: ${this.edad}`);
```
Los template literals (usando `` ` `` en vez de `""`) permiten **incrustar variables** directamente dentro de un string con `${}`. Son más legibles que la concatenación con `+`.

| Sin template literal | Con template literal |
|---|---|
| `"Hola " + nombre + ", tienes " + edad + " años"` | `` `Hola ${nombre}, tienes ${edad} años` `` |

---

### Paso 6 – Múltiples instancias del mismo molde
```js
const alumno1 = new Alumno("María González", 22, "Ingeniería Informática", 6.2);
const alumno2 = new Alumno("Carlos Pérez",   25, "Diseño Gráfico",         5.8);
const alumno3 = new Alumno("Ana Torres",     20, "Administración",          6.7);
```
Cada objeto es **independiente**: tiene sus propios valores en los atributos, pero todos comparten los mismos métodos definidos en la clase `Alumno`.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `class` | Define una clase (molde para crear objetos) |
| `constructor()` | Inicializa los atributos al crear el objeto |
| `this` | Referencia al objeto actual dentro de la clase |
| `new` | Crea una instancia (objeto) de una clase |
| Atributo | Variable que pertenece a un objeto (`this.nombre`) |
| Método | Función que pertenece a una clase |
| Instancia | Un objeto concreto creado a partir de una clase |
| Template literal | String con variables incrustadas usando `` ` `` y `${}` |
| `Array.join()` | Une los elementos de un array en un string |
| `Array.forEach()` | Recorre cada elemento de un array |
| `Array.map()` | Transforma cada elemento de un array y devuelve uno nuevo |

---

## Diagrama de la clase Alumno

```
┌──────────────────────────────┐
│          class Alumno        │
├──────────────────────────────┤
│ Atributos:                   │
│   - nombre                   │
│   - edad                     │
│   - carrera                  │
│   - promedio                 │
├──────────────────────────────┤
│ Métodos:                     │
│   + mostrarInfo()            │
│   + mostrarEnPagina()        │
└──────────────────────────────┘
         ↓ new Alumno(...)
┌──────────────────────────────┐
│   Objeto: alumno1            │
│   nombre:   "María González" │
│   edad:     22               │
│   carrera:  "Ing. Informát." │
│   promedio: 6.2              │
└──────────────────────────────┘
```

---

## Ejercicio propuesto para practicar
Crea una cuarta clase llamada `Vehiculo` con los atributos:
- `marca`, `modelo`, `año`, `color`

Y los métodos:
- `mostrarInfo()` → muestra todos los atributos en consola
- `arrancar()` → imprime `"El motor está encendido"`
- `apagar()` → imprime `"El motor está apagado"`

Instancia al menos 2 vehículos distintos y llama a sus métodos.
