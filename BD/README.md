# 🗄️ Guía de Carga de Base de Datos (Script SQL)

En esta carpeta encontrarás el script SQL (`BD_Clientes.sql` o similar) necesario para inicializar la base de datos de nuestro ejercicio práctico. Este archivo contiene las instrucciones para:
1. Eliminar la tabla `clientes` si ya existe (para evitar errores).
2. Crear la estructura de la tabla `clientes`.
3. Insertar **1000 registros** de prueba de forma automática.

A continuación, te explicamos paso a paso cómo ejecutar este script en **PostgreSQL** usando **pgAdmin 4** (la herramienta gráfica más común) o la terminal.

---

## 🚀 Método 1: Usando pgAdmin 4 (Recomendado)

Sigue estos pasos si estás utilizando la interfaz gráfica pgAdmin 4:

### Paso 1: Crear una nueva base de datos (Opcional pero recomendado)
Para mantener el orden, es ideal crear una base de datos exclusiva para este ejercicio.
1. Abre **pgAdmin 4** y conéctate a tu servidor local (usualmente `PostgreSQL 15` o `16`).
2. Haz clic derecho sobre **Databases** > **Create** > **Database...**
3. En el campo *Database*, escribe un nombre (por ejemplo: `ejercicio_clientes`) y haz clic en **Save**.

### Paso 2: Abrir el Query Tool (Herramienta de Consultas)
1. En el panel izquierdo, despliega **Databases** y haz clic sobre la base de datos que acabas de crear (o la que vayas a usar).
2. Ve al menú superior y haz clic en el ícono de **Query Tool** (o haz clic derecho sobre la base de datos y selecciona *Query Tool*). Se abrirá una ventana en blanco a la derecha.

### Paso 3: Cargar el Script SQL
Tienes dos formas de hacer esto:
* **Opción A (Copiar y Pegar):** Abre el archivo `.sql` desde tu editor de código (como VS Code), copia todo el contenido (`Ctrl+C` / `Cmd+C`) y pégalo en la ventana del Query Tool en pgAdmin (`Ctrl+V` / `Cmd+V`).
* **Opción B (Abrir archivo):** En el menú superior del Query Tool, haz clic en el ícono de la carpeta (**Open File**), busca el archivo SQL en tu computadora y ábrelo.

### Paso 4: Ejecutar el Script
1. Con el código ya visible en la pantalla, haz clic en el botón de **Play (▶️)** en el menú superior del Query Tool, o presiona `F5` en tu teclado.
2. En la pestaña inferior (*Messages*), deberías ver un mensaje que dice algo como: `INSERT 0 1000` y `Query returned successfully`. ¡Esto significa que los datos se cargaron correctamente!

### Paso 5: Verificar la carga
Borra el código que tienes en el Query Tool, escribe la siguiente consulta y vuelve a darle a Play (▶️):

```sql
SELECT * FROM clientes;