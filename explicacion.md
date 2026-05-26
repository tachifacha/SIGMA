# Explicación de `ordenes-compra.js` para principiantes

Este archivo JavaScript maneja la lógica de un formulario para crear órdenes de compra. Permite a los usuarios:
1. Seleccionar materiales de una lista obtenida desde el servidor
2. Especificar cantidades para cada material
3. Ver automáticamente el subtotal por fila y el total general
4. Enviar la orden completa al servidor

## Conceptos clave explicados

### 1. Esperar a que la página cargue (`DOMContentLoaded`)
```javascript
document.addEventListener('DOMContentLoaded', function() {
  // Todo el código va aquí dentro
});
```
**¿Qué hace?**  
Esto asegura que el JavaScript no intente manipular elementos de la página antes de que el HTML haya terminado de cargarse. Es como esperar a que todos los ladrillos de una pared estén puestos antes de comenzar a pintar.

**¿Por qué es importante?**  
Si intentamos acceder a un elemento como `document.querySelector('#tablaOC')` antes de que exista en el DOM, obtendremos un error.

### 2. Obtener datos del servidor (Fetch API)
```javascript
fetch('../api/materiales.php')
  .then(res => res.json())
  .then(data => {
    // Procesamos los materiales recibidos
  })
  .catch(err => console.error('Error cargando materiales:', err));
```
**¿Qué hace?**  
Esta es una petición HTTP asincrónica al archivo `materiales.php` en el servidor. El servidor responde con una lista de materiales en formato JSON, y nosotros los procesamos.

**Conceptos importantes:**
- **Promesas**: `fetch()` devuelve una promesa que representa una operación que completará en el futuro
- **`.then()`**: Se ejecuta cuando la promesa se resuelve (éxito)
- **`.catch()`**: Se ejecuta si ocurre un error
- **JSON**: Formato estándar para intercambiar datos entre cliente y servidor

### 3. Organizar datos en memoria
```javascript
const materialesAgrupados = {};
// ...
data.forEach(mat => {
  const cat = mat.nombre_categoria || 'Sin categoría';
  if (!materialesAgrupados[cat]) {
    materialesAgrupados[cat] = [];
  }
  materialesAgrupados[cat].push({
    id: mat.id_material,
    nombre: mat.nombre,
    unidad: mat.unidad_medida,
    precio: parseFloat(mat.precio_compra) || 0
  });
});
```
**¿Qué hace?**  
Toma la lista plana de materiales recibida del servidor y la organiza por categoría en un objeto JavaScript. Esto facilita mostrar los materiales agrupados en desplegables.

**Ejemplo de estructura resultante:**
```javascript
{
  "Tornillos": [
    { id: 1, nombre: "Tornillo plano", unidad: "uds", precio: 10.5 },
    { id: 2, nombre: "Tornillo Phillips", unidad: "uds", precio: 12.0 }
  ],
  "Madera": [
    { id: 3, nombre: "Pino tratado", unidad: "mts", precio: 250.0 }
  ]
}
```

### 4. Manipulación del DOM (Crear elementos dinámicamente)
```javascript
function agregarFila() {
  const nuevaFila = templateFila.cloneNode(true);
  nuevaFila.classList.remove('template');
  nuevaFila.style.display = '';
  // ... configurar eventos ...
  tablaBody.insertBefore(nuevaFila, document.querySelector('.fila-agregar'));
}
```
**¿Qué hace?**  
Clona una fila oculta (plantilla) del HTML, la hace visible, la inserta en la tabla y le asigna comportamientos específicos.

**Conceptos clave:**
- **`cloneNode(true)`**: Crea una copia exacta de un elemento DOM incluyendo sus hijos
- **Manipulación de clases**: `.classList.remove()` para quitar la clase que ocultaba la plantilla
- **Inserción en el DOM**: `.insertBefore()` para colocar la nueva fila en posición específica

### 5. Manejo de eventos (Event Listeners)
```javascript
selectMaterial.addEventListener('change', function() {
  // Se ejecuta cuando el usuario selecciona un material
});

inputCantidad.addEventListener('input', function() {
  // Se ejecuta mientras el usuario escribe en el campo de cantidad
});

nuevaFila.querySelector('.btn-eliminar-fila').addEventListener('click', function() {
  // Se ejecuta al hacer clic en el botón de eliminar fila
});
```
**¿Qué hace?**  
Asigna funciones que se ejecutarán automáticamente cuando ocurran ciertas interacciones del usuario.

**Importante:**  
Estas funciones tienen acceso a las variables del scope exterior (como `materialesAgrupados`) gracias al concepto de **closures**.

### 6. Actualización de cálculos en tiempo real
```javascript
function recalcularFila(fila) {
  const precio = parseFloat(option?.dataset?.precio) || 0;
  const cant = parseInt(fila.querySelector('.cantidad-input').value) || 0;
  const subtotal = precio * cant;
  
  fila.querySelector('.subtotal-cell').textContent = 
    '$' + subtotal.toLocaleString('es-AR', { minimumFractionDigits: 2 });
  
  calcularTotal(); // Recalcula el total general
}
```
**¿Qué hace?**  
Cada vez que el usuario cambia un material o una cantidad:
1. Obtiene el precio del material seleccionado (almacenado en `data-precio` del option)
2. Obtiene la cantidad ingresada
3. Calcula el subtotal (precio × cantidad)
4. Actualiza la celda de subtotal en la fila
5. Llama a `calcularTotal()` para actualizar el total general

**Buenas prácticas observadas:**
- Uso de `?.` (optional chaining) para evitar errores si algún elemento no existe
- `parseFloat()` y `parseInt()` para convertir strings a números seguros
- `toLocaleString('es-AR')` para formatos de moneda argentino ($ y coma como separador decimal)

### 7. Envío del formulario
```javascript
document.getElementById('ocForm').addEventListener('submit', function(e) {
  const items = [];
  
  filas.forEach(fila => {
    // ... validar y construir objeto de ítem ...
    if (select.value && cantidad > 0) {
      items.push({
        id_material: parseInt(select.value),
        cantidad: cantidad,
        precio_compra: parseFloat(option.dataset.precio)
      });
    }
  });
  
  document.getElementById('materialesJson').value = JSON.stringify(items);
  
  if (items.length === 0) {
    e.preventDefault(); // Evita que se envíe el formulario
    alert('Debe agregar al menos un material con cantidad mayor a 0');
  }
});
```
**¿Qué hace?**  
Antes de enviar el formulario:
1. Recorre todas las filas de materiales
2. Construye un array de objetos con los datos válidos
3. Convierte ese array a JSON y lo pone en un campo oculto del formulario (`materialesJson`)
4. Valida que haya al menos un ítem con cantidad > 0
5. Si no es válido, cancela el envío y muestra una alerta

**Concepto importante:**  
`JSON.stringify()` convierte un objeto/array JavaScript a una cadena JSON que puede enviarse fácilmente al servidor mediante un formulario tradicional.

## Flujo general de funcionamiento

1. **Al cargar la página:**
   - Espera a que el DOM esté listo
   - Solicita la lista de materiales al servidor (`materiales.php`)
   - Los organiza por categoría en memoria
   - Prepara la primera fila vacía para ingresar datos

2. **Al agregar una fila:**
   - Clona la plantilla oculta
   - La llena con opciones de materiales agrupadas por categoría
   - Asigna eventos para:
     * Actualizar precio/unidad al cambiar material
     * Recalcular subtotal al cambiar cantidad
     * Eliminar la fila (si hay más de una)

3. **Al interactuar con los campos:**
   - Cambiar material → actualiza precio y unidad mostrados
   - Cambiar cantidad → recalcula subtotal de esa fila
   - Cualquier cambio → recalcula el total general

4. **Al enviar el formulario:**
   - Valida que haya materiales con cantidades válidas
   - Prepara los datos en formato JSON para enviar al servidor
   - Envía el formulario normalmente (los datos van en el campo oculto)

## Buenas prácticas para principiantes que puedes notar

1. **Separación de responsabilidades:** Funciones pequeñas y con un propósito claro (`agregarFila`, `recalcularFila`, `calcularTotal`, etc.)
2. **Manejo de errores:** Uso de `.catch()` en fetch y validaciones antes de enviar
3. **Evitar repetición:** Lógica de cálculo centralizada en funciones reutilizables
4. **Accesibilidad:** Uso adecuado de atributos HTML (como `data-*`) para almacenar datos relacionados con elementos
5. **Performance:** No recalculando innelemente (solo cuando cambia algo relevante)

## Sugerencias para practicar (si quieres aprender más)

1. **Modifica el formato de moneda:** Cambia `es-AR` por `en-US` y observa cómo cambia el formato
2. **Agrega validación:** Evita que se ingresen cantidades negativas o decimales donde no correspondan
3. **Mejora la UI:** Agrega un mensaje cuando no hay materiales disponibles
4. **Experimenta con eventos:** En vez de `input`, prueba con `change` en el campo de cantidad y nota la diferencia
5. **Revisa el HTML asociado:** Mira cómo está estructurada la tabla y la plantilla para entender mejor los selectores usados

---

## Apéndice: Explicación detallada de los bloques 2 y 3

### Bloque 2 — Fetch API: cómo habla JS con el servidor

```javascript
fetch('../api/materiales.php')
  .then(res => res.json())
  .then(data => {
    // acá hacemos cosas con los materiales
  })
  .catch(err => console.error('Error cargando materiales:', err));
```

#### ¿Qué está pasando acá?

Imaginate que vos estás en un restaurante. El **cliente** sos JavaScript (el navegador). El **cocinero** es el servidor con `materiales.php`. El **menú** es la lista de materiales.

```javascript
fetch('../api/materiales.php')
```

Esto es como **pedirle el menú al mozo**. Le decís al navegador: "andá a esta dirección del servidor y traeme lo que haya".

La dirección `../api/materiales.php` significa: "subí un nivel desde donde estoy (`../`), entrá a la carpeta `api/`, y ejecutá el archivo `materiales.php`". Ese archivo PHP probablemente hace una consulta SQL tipo `SELECT * FROM materiales` y devuelve el resultado.

#### El gran problema: el servidor es lento (asincronía)

Acá viene el concepto más IMPORTANTE que tenés que entender en JavaScript:

**El servidor puede tardar**. 1 segundo, 3 segundos, hasta 30 segundos si hay un problema. Mientras tanto, el navegador NO se puede congelar porque entonces el usuario no podría ni mover el mouse.

JavaScript resuelve esto con **programación asincrónica**. Es como pedir un café: vos no te quedás mirando fijo la máquina de café; hacés otra cosa y cuando el café está listo, te avisan.

```javascript
fetch(...)  // Esto NO bloquea. Es como "pedí el café, seguí con tu vida"
  .then(...)  // Esto es "cuando el café esté listo, ejecutá esto"
```

#### La promesa

`fetch()` devuelve un objeto llamado **Promise** (promesa). Una promesa es exactamente lo que suena: "prometo que en el futuro te voy a dar un resultado, pero no sé cuándo exactamente".

Una promesa tiene 3 estados:
- **Pending** (pendiente): todavía no se resolvió
- **Fulfilled** (cumplida): salió bien, tengo los datos
- **Rejected** (rechazada): salió mal, tengo un error

#### .then() — cuando sale bien

```javascript
.then(res => res.json())
```

El primer `.then()` recibe la respuesta cruda del servidor (un objeto `Response`). Ese objeto tiene metadatos: código de estado HTTP (200, 404, 500), headers, etc.

`res.json()` es OTRA promesa. ¿Por qué? Porque el cuerpo de la respuesta puede ser enorme y tarda en procesarse. Entonces tenés que esperar otra vez.

Es como:
1. `fetch` → "recibí el paquete"
2. `res.json()` → "ahora abrí el paquete y convertí lo de adentro (JSON) en un objeto JavaScript usable"

```javascript
.then(data => {
  // data ya es un array/objeto JavaScript real
})
```

Acá `data` ya no es texto JSON. Ya es un array de objetos JavaScript con el que podés trabajar directamente: `data.forEach(...)`, `data.length`, `data[0].nombre`, etc.

#### .catch() — cuando sale mal

```javascript
.catch(err => console.error('Error cargando materiales:', err));
```

Si la red se cae, el servidor devuelve 500, o hay un error de conexión, esto se ejecuta. Sin esto, tu página se queda en silencio y el usuario piensa que funciona cuando en realidad falló.

#### Versión moderna con async/await (para que lo reconozcas)

Muchos códigos modernos escriben esto así:

```javascript
async function cargarMateriales() {
  try {
    const res = await fetch('../api/materiales.php');
    const data = await res.json();
    // usamos data
  } catch (err) {
    console.error('Error:', err);
  }
}
```

Es exactamente lo mismo. `async/await` es solo **azúcar sintáctica** sobre `.then()` y promesas. Hace que el código se lea como si fuera sincrónico.

#### Analogía completa del restaurant

| Código | Analogía |
|--------|----------|
| `fetch(...)` | Pedir el menú al mozo |
| La URL `../api/materiales.php` | La cocina donde está el menú |
| `.then(res => res.json())` | Esperar que el mozo traiga el menú a tu mesa |
| `.then(data => ...)` | Abrir el menú y elegir qué comer |
| `.catch(err => ...)` | Si el mozo se cayó, pedir disculpas |

---

### Bloque 3 — Organizar datos en memoria

```javascript
const materialesAgrupados = {};

data.forEach(mat => {
  const cat = mat.nombre_categoria || 'Sin categoría';
  if (!materialesAgrupados[cat]) {
    materialesAgrupados[cat] = [];
  }
  materialesAgrupados[cat].push({
    id: mat.id_material,
    nombre: mat.nombre,
    unidad: mat.unidad_medida,
    precio: parseFloat(mat.precio_compra) || 0
  });
});
```

#### ¿Qué problema resuelve?

El servidor devuelve un array plano como este:

```javascript
[
  { id_material: 1, nombre: "Tornillo plano", nombre_categoria: "Tornillos", unidad_medida: "uds", precio_compra: "10.50" },
  { id_material: 2, nombre: "Tornillo Phillips", nombre_categoria: "Tornillos", unidad_medida: "uds", precio_compra: "12.00" },
  { id_material: 3, nombre: "Pino tratado", nombre_categoria: "Madera", unidad_medida: "mts", precio_compra: "250.00" },
  { id_material: 4, nombre: "Clavo 2\"", nombre_categoria: "Tornillos", unidad_medida: "kg", precio_compra: "8.00" }
]
```

Pero en el HTML, querés mostrarlos agrupados así en el `<select>`:

```
-- Seleccione --
▼ Tornillos
     Tornillo plano
     Tornillo Phillips
     Clavo 2"
▼ Madera
     Pino tratado
```

HTML no tiene una forma mágica de agrupar opciones. Necesitás un `optgroup` por categoría. Y para eso, necesitás los datos YA agrupados en una estructura que te lo facilite.

#### El objeto como mapa (no como clase)

```javascript
const materialesAgrupados = {};
```

`{}` se lee como "objeto literal vacío". Pero acá NO está siendo usado como una "clase" o "instancia" al estilo POO. Lo está usando como **mapa** o **diccionario**.

En otros lenguajes, usarías `new HashMap<String, List<Material>>()` o similar. En JavaScript, usás un objeto `{}` — que no es más que una colección de pares clave → valor.

Al final, `materialesAgrupados` se ve así:

```javascript
{
  "Tornillos": [
    { id: 1, nombre: "Tornillo plano", ... },
    { id: 2, nombre: "Tornillo Phillips", ... },
    { id: 4, nombre: "Clavo 2\"", ... }
  ],
  "Madera": [
    { id: 3, nombre: "Pino tratado", ... }
  ]
}
```

Las **claves** son nombres de categoría (`"Tornillos"`, `"Madera"`).
Los **valores** son arrays de materiales.

#### Paso a paso de cómo se construye

```javascript
data.forEach(mat => {
```

`forEach` recorre CADA elemento del array `data`. Por cada elemento, ejecuta la función que le pasás. Es como decir: "para cada material en la lista, haceme esto".

---

```javascript
const cat = mat.nombre_categoria || 'Sin categoría';
```

`||` acá NO es un booleano "true or false". En JavaScript, `||` se llama **operador de cortocircuito** (short-circuit). Funciona así:

- Si lo de la izquierda es "truthy" (existe, no es null, no es undefined, no es cadena vacía), usá ESO.
- Si lo de la izquierda es "falsy" (null, undefined, 0, `""`, false), usá lo de la derecha.

Es un **valor por defecto** en una línea. Si el material no tiene `nombre_categoria`, en vez de tener `undefined`, le ponés `'Sin categoría'`.

---

```javascript
if (!materialesAgrupados[cat]) {
  materialesAgrupados[cat] = [];
}
```

Acá verificás: "¿Ya existe una entrada para esta categoría en mi objeto?"

- Si NO existe (`!materialesAgrupados[cat]` → `!undefined` → `true`), creala como un array vacío.
- Si ya existe (porque otro material de la misma categoría ya la creó), no hagas nada, usá la que ya está.

---

```javascript
materialesAgrupados[cat].push({
  id: mat.id_material,
  nombre: mat.nombre,
  unidad: mat.unidad_medida,
  precio: parseFloat(mat.precio_compra) || 0
});
```

Agregá el material al array de su categoría. Notá que acá NO estamos usando el objeto original `mat` directamente. **Estamos creando un NUEVO objeto** con propiedades renombradas y transformadas:

- `mat.id_material` → `id` (más corto)
- `mat.precio_compra` (string `"10.50"`) → `parseFloat(...)` → `precio` (número `10.5`)
- También aplica el cortocircuito: si `parseFloat` da `NaN` (no se pudo convertir), poné `0`

#### ¿Por qué NO usar el objeto original `mat` directamente?

Porque:
1. **Renombrás propiedades** para que sean más manejables en el frontend (`id_material` → `id`)
2. **Convertís tipos**: `precio_compra` viene como string del JSON. Lo pasás a número con `parseFloat`
3. **Eliminás basura**: si el servidor devuelve 20 propiedades y solo necesitás 4, no arrastrás las otras 16

#### Analogía de la biblioteca

Imaginate que recibís un montón de libros todos mezclados en una caja:

```
data = [Libro1, Libro2, Libro3, ...]
```

Y querés ordenarlos en una estantería por género:

```javascript
const estanteria = {};

data.forEach(libro => {
  const genero = libro.genero || 'Sin género';

  if (!estanteria[genero]) {
    estanteria[genero] = [];  // creo un estante vacío para este género
  }

  estanteria[genero].push({
    titulo: libro.titulo,
    autor: libro.autor
  });
});
```

Al final, `estanteria` se ve así:

```
{
  "Ficción": [ { titulo: "1984", autor: "Orwell" }, ... ],
  "Ciencia": [ { titulo: "Breve historia del tiempo", autor: "Hawking" } ],
  "Sin género": [ ... ]
}
```

Ahora, cuando querés mostrarle los libros al usuario agrupados por género, ya los tenés listos.

#### Lo que MÁS cuesta entender acá (y es clave)

Fijate que al principio `materialesAgrupados` es un objeto VACÍO `{}`.

Después de la primera iteración (`mat = { id_material: 1, nombre_categoria: "Tornillos", ... }`):

```javascript
materialesAgrupados["Tornillos"] = [];  // ← esto MODIFICA el objeto original
materialesAgrupados["Tornillos"].push({ id: 1, ... });  // ← agrega al array
```

Después de la segunda iteración (`mat = { id_material: 2, nombre_categoria: "Tornillos", ... }`):

```javascript
// materialesAgrupados["Tornillos"] YA EXISTE, así que NO se sobreescribe
// directamente se pushea el nuevo material
materialesAgrupados["Tornillos"].push({ id: 2, ... });
```

**El objeto `materialesAgrupados` se va construyendo de a poco, mutación tras mutación.** No se asigna un objeto nuevo cada vez. Se va modificando el mismo objeto en cada vuelta del `forEach`.

Es como si tuvieras una caja de herramientas vacía y fueras agregando herramientas a medida que las necesitás. La caja es siempre la misma, pero su contenido cambia.
