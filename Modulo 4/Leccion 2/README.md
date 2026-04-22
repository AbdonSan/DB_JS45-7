# Módulo 4 – Lección 2: Modelado de Clases con POO

## Objetivo
Aplicar los principios de la POO en JavaScript mediante la creación de jerarquías de clases usando herencia (`extends` / `super`), modelando situaciones reales en tres escenarios distintos.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `index.html` | Página principal que carga los 3 scripts y muestra los resultados |
| `taxis.js` | Escenario 1: jerarquía de clases para taxis urbanos |
| `sony.js` | Escenario 2: catálogo de productos Sony Chile |
| `sumatoria.js` | Escenario 3: clase Sumatoria con botón interactivo |

---

## Concepto central: Herencia (`extends` / `super`)

La herencia permite que una clase **hija** reutilice los atributos y métodos de una clase **padre**, y además agregue los suyos propios.

```js
class Padre {
    constructor(atributo) {
        this.atributo = atributo;
    }
    metodo() {
        console.log(this.atributo);
    }
}

class Hija extends Padre {
    constructor(atributo, extra) {
        super(atributo);    // llama al constructor del padre
        this.extra = extra; // atributo propio de la clase hija
    }
}
```

| Palabra clave | Función |
|---|---|
| `extends` | Indica que la clase hija hereda de la clase padre |
| `super()` | Llama al constructor del padre para inicializar atributos heredados |
| `super.metodo()` | Llama a un método del padre desde la clase hija |

---

## Escenario 1 – Taxis Urbanos

### Árbol de herencia
```
Taxi  (clase base)
├── TaxiTradicional   → techo amarillo, licencia A1
├── TaxiParticular    → licencia B
│   ├── TaxiExpress   → autos típicos, tarifa por km
│   └── TaxiPremium   → alta categoría, extras de confort
└── TaxiCargo         → transporta carga, capacidad en kg
```

### Cómo funciona `extends` + `super` en este escenario
```js
class TaxiExpress extends TaxiParticular {
    constructor(placa, marca, modelo, conductor, tarifa) {
        // super() llama al constructor de TaxiParticular,
        // que a su vez llama al constructor de Taxi
        super(placa, marca, modelo, conductor);
        this.tarifa = tarifa;   // atributo nuevo de TaxiExpress
    }
}
```

Cuando se llama `super()` en TaxiExpress, la cadena de constructores es:
```
TaxiExpress → TaxiParticular → Taxi
```
Así los atributos de Taxi (placa, marca, modelo, conductor) y de TaxiParticular (licencia) quedan inicializados correctamente.

---

## Escenario 2 – Catálogo Sony Chile

### Árbol de herencia
```
ProductoSony  (clase base)
├── Televisor   → pulgadas, resolución, smartTv
├── Camara      → megapixeles, tipo
├── Audio       → tipo, inalambrico
├── Consola     → almacenamientoGB, version
└── Accesorio   → compatibleCon (array)
```

### Método heredado y sobrescrito (`mostrarInfo`)
Cada subclase **sobrescribe** el método `mostrarInfo()` para agregar sus propios datos, pero llama a `super.mostrarInfo()` para no repetir el código del padre:

```js
class Televisor extends ProductoSony {
    mostrarInfo() {
        super.mostrarInfo();   // imprime nombre, modelo, precio, garantía
        console.log(`→ ${this.pulgadas}" | ${this.resolucion}`);  // agrega lo suyo
    }
}
```

### `instanceof` – detectar el tipo de objeto
```js
if (producto instanceof Televisor) { ... }
```
`instanceof` devuelve `true` si el objeto fue creado con esa clase (o una clase hija de ella). Se usa para saber qué tipo de producto es y mostrar sus atributos específicos en la página.

---

## Escenario 3 – Clase Sumatoria

### ¿Cómo funciona?
```js
const miSumatoria = new Sumatoria(3);
// Constructor imprime: "Número base: 3 → Sumatoria inicial: 3"

miSumatoria.sumar();
// sumar() imprime: "sumar() ejecutado → 3 + 3 = 6"

miSumatoria.sumar();
// sumar() imprime: "sumar() ejecutado → 6 + 3 = 9"
```

Cada llamada a `sumar()` agrega el `base` al `acumulado`:
```
acumulado = acumulado + base
```

### Conexión del botón HTML con el método JavaScript
```html
<button onclick="ejecutarSumar()">Ejecutar sumar()</button>
```
```js
function ejecutarSumar() {
    miSumatoria.sumar();
}
```
El atributo `onclick` ejecuta la función `ejecutarSumar()` cada vez que el usuario hace clic. Esa función llama al método `sumar()` del objeto `miSumatoria`.

### Número base aleatorio
```js
const base = Math.floor(Math.random() * 10) + 1;
const miSumatoria = new Sumatoria(base);
```
Cada vez que se recarga la página, se genera un nuevo número base distinto.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `extends` | La clase hija hereda atributos y métodos de la clase padre |
| `super()` | Llama al constructor del padre desde la clase hija |
| `super.metodo()` | Ejecuta el método del padre desde la clase hija |
| Sobrescritura de métodos | Redefinir un método heredado para agregar o cambiar comportamiento |
| `instanceof` | Verifica si un objeto es instancia de una clase específica |
| `this.acumulado += this.base` | Suma y guarda el resultado en la misma variable |
| `onclick` | Atributo HTML que ejecuta una función JS al hacer clic |
| `constructor.name` | Propiedad que devuelve el nombre de la clase del objeto |

---

## Diferencia entre clase base y subclase

| | Clase base (`Taxi`) | Subclase (`TaxiExpress`) |
|---|---|---|
| Hereda de | Nada | `TaxiParticular` → `Taxi` |
| `super()` | No aplica | Obligatorio en el constructor |
| Atributos | Los comunes a todos | Los comunes + los propios |
| Métodos | Los generales | Puede heredar o sobrescribir |

---

## Ejercicio propuesto para practicar
Agrega al escenario de taxis una nueva subclase `TaxiEléctrico` que herede de `TaxiParticular` y agregue:
- `autonomiaKm` → autonomía de la batería en kilómetros
- `tiempoRecargaH` → tiempo de recarga en horas

Instancia un objeto y muestra su información en la página.
