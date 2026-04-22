# Lección 1 – Uso de Archivos JavaScript Externos

## Objetivo
Aprender a separar el código JavaScript en un archivo independiente y vincularlo a un documento HTML mediante la etiqueta `<script src="">`.

---

## Archivos del proyecto

| Archivo | Descripción |
|---|---|
| `EP2.html` | Página HTML que carga el script externo |
| `app.js` | Archivo JavaScript con la lógica del programa |

---

## ¿Qué hace el programa?
Al abrir `EP2.html` en el navegador, se ejecuta automáticamente el código de `app.js`, que muestra un cuadro de alerta con el mensaje:

> ¡Hola mundo!

---

## Pasos para entender el ejercicio

### Paso 1 – Crear el archivo HTML
El archivo `EP2.html` contiene la estructura mínima de una página web. Lo más importante es la etiqueta al final del `<body>`:

```html
<script src="app.js"></script>
```

El atributo `src` le dice al navegador que cargue y ejecute el archivo `app.js` que está en la misma carpeta.

### Paso 2 – Crear el archivo JavaScript
El archivo `app.js` contiene dos líneas:

```js
// Este es un método para devolver un cuadro de alerta
window.alert("¡Hola mundo!");
```

- La primera línea es un **comentario** (el navegador la ignora, es solo para el programador).
- La segunda línea llama al método `window.alert()`, que abre un cuadro emergente con el mensaje indicado.

### Paso 3 – Probar en el navegador
1. Guarda ambos archivos en la misma carpeta.
2. Abre `EP2.html` en tu navegador.
3. Verás un cuadro de alerta con el mensaje `¡Hola mundo!`.

---

## Conceptos clave

| Concepto | Explicación |
|---|---|
| `<script src="...">` | Vincula un archivo `.js` externo al HTML |
| `window.alert()` | Muestra un cuadro de diálogo emergente en el navegador |
| Comentarios `//` | Líneas ignoradas por el navegador, útiles para documentar el código |
| Archivos externos | Un mismo `app.js` puede reutilizarse en múltiples páginas HTML |

---

## ¿Por qué usar archivos JavaScript externos?
- **Reutilización:** el mismo script puede usarse en varias páginas.
- **Organización:** separa el contenido (HTML) de la lógica (JS).
- **Rendimiento:** el navegador puede guardar en caché el archivo `.js`, reduciendo el tiempo de carga en visitas posteriores.
