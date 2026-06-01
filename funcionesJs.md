# Explicación de funciones de `ordenes-compra.js`

## Mapa general del archivo

```
ordenes-compra.js
│
├── 🟢 DOMContentLoaded (línea 5) →  bloque principal
│   │
│   ├── fetch()                      → pide materiales
│   │   └── .then(data => ...)       → agrupa por categoría
│   │       └── agregarFila()        ← LLAMADA INICIAL
│   │
│   ├── evento "click" en #agregarFilaBtn → agregarFila()
│   │
│   ├── 🔵 agregarFila()             → clona template y asigna eventos
│   │   ├── poblarSelect()           → llena el <select> con opciones
│   │   ├── evento "change" en select → recalcularFila()
│   │   ├── evento "input" en cantidad → recalcularFila()
│   │   └── evento "click" en eliminar → remove() + reindexarFilas()
│   │
│   ├── 🔵 poblarSelect(selectEl)    → crea <optgroup> por categoría
│   │
│   ├── 🔵 recalcularFila(fila)      → subtotal = precio × cantidad
│   │   └── calcularTotal()
│   │
│   ├── 🔵 calcularTotal()           → suma todos los subtotales
│   │
│   ├── 🔵 reindexarFilas()          → renumera las filas (#1, #2, ...)
│   │
│   └── evento "submit" en #ocForm  → valida + serializa a JSON
```

---

## Archivos relacionados

```
src/
├── api/
│   └── materiales.php              ← provee los datos (API)
├── config/
│   └── conexion.php                ← conexión a la BD
├── js/
│   └── ordenes-compra.js           ← ESTE archivo
├── modulos/compras_provision/
│   └── ordenes_compra/
│       └── añadirOc.php            ← página HTML + PHP que lo usa
└── app_datosTachi.sql              ← estructura de la base de datos
```

### Cómo se relacionan

```
                    ┌─────────────────┐
                    │  añadirOc.php   │  ← HTML + PHP (el formulario)
                    │                 │
                    │ <script src=    │
                    │  "ordenes-      │
                    │   compra.js">   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ordenes-compra.js│  ← JavaScript (lógica del frontend)
                    │                 │
                    │ fetch() ──────────────┐
                    └───────────────────────┘
                                            │
                                   ┌────────▼────────┐
                                   │ materiales.php  │  ← API que consulta la BD
                                   │                 │
                                   │ SELECT ...      │
                                   │ FROM materiales │
                                   │ JOIN categorias │
                                   └────────┬────────┘
                                            │
                                   ┌────────▼────────┐
                                   │ Base de datos   │
                                   │ (MySQL)         │
                                   └─────────────────┘
```

### Tablas involucradas

- **`materiales`** — id_material, nombre, unidad_medida, precio_venta, id_categoria
- **`categorias_material`** — id_categoria, nombre_categoria
- **`ordenes_compra`** — id_oc, id_proveedor, fecha_emision, estado, total
- **`oc_detalle`** — id_oc, id_material, cantidad (renglones de cada orden)
- **`proveedores`** — id_proveedor, razon_social

---

## 1. `agregarFila()` — líneas 36–81

```javascript
function agregarFila() {
  const nuevaFila = templateFila.cloneNode(true);
  nuevaFila.classList.remove("template");
  nuevaFila.style.display = "";
  ...
```

**¿Qué hace?** Crea una nueva fila en la tabla para que el usuario pueda agregar otro material a la orden.

### Paso 1 — Clonar la plantilla

```javascript
const nuevaFila = templateFila.cloneNode(true);
```

En el HTML hay una fila oculta (con `style="display: none"` y clase `template`) que funciona como **molde**. En vez de construir la fila desde cero con JavaScript, hacen una copia de la que ya existe. `cloneNode(true)` significa "cloname todo, incluyendo los hijos" (el `true` es clave — sin eso, clona solo el `<tr>` vacío).

La variable `templateFila` se definió al principio del archivo:
```javascript
const templateFila = document.querySelector(".fila-material.template");
```

Agarró el molde UNA VEZ al cargar la página y lo guardó en una variable para reusarlo.

### Paso 2 — Hacerla visible

```javascript
nuevaFila.classList.remove("template");
nuevaFila.style.display = "";
```

Le saca la clase `template` (que la oculta vía CSS) y fuerza que se muestre.

### Paso 3 — Ponerle materiales al select

```javascript
const selectMaterial = nuevaFila.querySelector(".material-select");
poblarSelect(selectMaterial);
```

Busca el `<select>` dentro de la fila nueva y lo llena con las opciones de materiales delegando en `poblarSelect()`.

### Paso 4 — Asignar eventos a la fila nueva

Cada fila nueva necesita sus propios event listeners. Si no, cuando el usuario cambia un material en la fila 3, no pasaría nada.

```javascript
selectMaterial.addEventListener("change", function () {
  const option = this.options[this.selectedIndex];
  const precio = parseFloat(option?.dataset?.precio) || 0;
  const unidad = option?.dataset?.unidad || "";

  const fila = this.closest(".fila-material");
  fila.querySelector(".precio-cell").textContent =
    "$" + precio.toLocaleString("es-AR");
  fila.querySelector(".unidad-cell").textContent = unidad;
  fila.querySelector(".hidden-id").value = this.value;

  recalcularFila(fila);
});
```

- `this` dentro del evento se refiere al `<select>` que disparó el cambio.
- `this.options[this.selectedIndex]` agarra el `<option>` que el usuario eligió.
- `option.dataset.precio` lee el atributo `data-precio` del HTML.
- `this.closest(".fila-material")` sube por el DOM hasta la fila contenedora.
- `toLocaleString("es-AR")` formatea el número para Argentina (ej: $1.250,00).
- Luego llama a `recalcularFila(fila)`.

Lo mismo ocurre con el input de cantidad y el botón eliminar.

### Paso 5 — Insertar la fila

```javascript
tablaBody.insertBefore(nuevaFila, document.querySelector(".fila-agregar"));
```

Pone la fila nueva justo antes del botón "+ Agregar material".

### Paso 6 — Renumerar

```javascript
reindexarFilas();
```

Actualiza los números de las filas (#1, #2, #3...).

---

## 2. `poblarSelect(selectEl)` — líneas 83–102

```javascript
function poblarSelect(selectEl) {
  selectEl.innerHTML = '<option value="">-- Seleccione --</option>';

  Object.keys(materialesAgrupados).forEach((categoria) => {
    const optgroup = document.createElement("optgroup");
    optgroup.label = categoria;

    materialesAgrupados[categoria].forEach((mat) => {
      const option = document.createElement("option");
      option.value = mat.id;
      option.dataset.precio = mat.precio;
      option.dataset.unidad = mat.unidad;
      option.textContent = mat.nombre;
      optgroup.appendChild(option);
    });

    selectEl.appendChild(optgroup);
  });
}
```

**¿Qué hace?** Llena un `<select>` con los materiales agrupados por categoría.

`Object.keys(materialesAgrupados)` obtiene todas las claves del objeto como un array:
```javascript
["Tornillos", "Madera", "Ferretería"]
```

Por cada categoría, crea un `<optgroup>` (grupo con título en negrita):

```
-- Seleccione --
▼ Tornillos
     Tornillo plano
     Tornillo Phillips
▼ Madera
     Pino tratado
```

Por cada material dentro de la categoría crea un `<option>` con:
- `value` = id del material (se envía al servidor)
- `dataset.precio` = precio (accesible desde JS, no visible)
- `dataset.unidad` = unidad de medida
- `textContent` = nombre visible

Los options se insertan dentro del optgroup, y cada optgroup dentro del select.

---

## 3. `recalcularFila(fila)` — líneas 104–114

```javascript
function recalcularFila(fila) {
  const select = fila.querySelector(".material-select");
  const option = select.options[select.selectedIndex];
  const precio = parseFloat(option?.dataset?.precio) || 0;
  const cant = parseInt(fila.querySelector(".cantidad-input").value) || 0;
  const subtotal = precio * cant;

  fila.querySelector(".subtotal-cell").textContent =
    "$" + subtotal.toLocaleString("es-AR", { minimumFractionDigits: 2 });

  calcularTotal();
}
```

**¿Qué hace?** Calcula el subtotal de UNA fila y actualiza el total general.

Recibe una fila (el elemento `<tr>`). Adentro busca:
- El select → agarra el option seleccionado → extrae el precio
- El input de cantidad → toma el valor numérico

- `parseFloat()` convierte string `"150.00"` a número `150.00`
- `parseInt()` convierte `"5"` a `5`
- `|| 0` es cortocircuito: si da `NaN` porque está vacío, pone `0`

`precio * cant` = subtotal. Se formatea con `toLocaleString("es-AR", { minimumFractionDigits: 2 })`.

Ejemplo:
```
precio = 150.50
cant = 3
subtotal = 451.50
→ en la celda: $451.50
```

Finalmente llama a `calcularTotal()`. Esta función se ejecuta CADA VEZ que el usuario cambia algo. Es reactiva.

---

## 4. `calcularTotal()` — líneas 116–130

```javascript
function calcularTotal() {
  const filas = document.querySelectorAll(".fila-material:not(.template)");
  let total = 0;

  filas.forEach((fila) => {
    const select = fila.querySelector(".material-select");
    const option = select.options[select.selectedIndex];
    const precio = parseFloat(option?.dataset?.precio) || 0;
    const cant = parseInt(fila.querySelector(".cantidad-input").value) || 0;
    total += precio * cant;
  });

  document.getElementById("totalOrden").innerHTML =
    "<strong>$" +
    total.toLocaleString("es-AR", { minimumFractionDigits: 2 }) +
    "</strong>";
}
```

**¿Qué hace?** Recorre TODAS las filas, suma todos los subtotales y lo muestra en el pie de la tabla.

`document.querySelectorAll(".fila-material:not(.template)")` obtiene todas las filas visibles. Itera con `forEach` y acumula en `total += precio * cant`.

Al final actualiza el contenido HTML del elemento con id `totalOrden` con `<strong>` para negrita.

---

## 5. `reindexarFilas()` — líneas 132–137

```javascript
function reindexarFilas() {
  const filas = document.querySelectorAll(".fila-material:not(.template)");
  filas.forEach((fila, index) => {
    fila.querySelector(".num-row").textContent = index + 1;
  });
}
```

**¿Qué hace?** Renumera las filas después de eliminar una.

Si el usuario elimina la fila 2 y quedan las filas 1, 3, 4, este función las renumera a 1, 2, 3. El `index` del `forEach` empieza en 0, así que suma 1.

---

## 6. Evento submit del formulario — líneas 140–172

```javascript
document.getElementById("ocForm").addEventListener("submit", function (e) {
  const filas = document.querySelectorAll(".fila-material:not(.template)");
  const items = [];

  filas.forEach((fila) => {
    const select = fila.querySelector(".material-select");
    if (select.value) {
      const option = select.options[select.selectedIndex];
      const cantidad = parseInt(fila.querySelector(".cantidad-input").value) || 0;
      if (cantidad > 0) {
        items.push({
          id_material: parseInt(select.value),
          cantidad: cantidad,
          precio_venta: parseFloat(option.dataset.precio),
        });
      }
    }
  });

  document.getElementById("materialesJson").value = JSON.stringify(items);

  let total = 0;
  items.forEach((item) => {
    total += item.precio_venta * item.cantidad;
  });
  document.getElementById("totalOrdenHidden").value = total;

  if (items.length === 0) {
    e.preventDefault();
    alert("Debe agregar al menos un material con cantidad mayor a 0");
  }
});
```

**¿Qué hace?** Cuando el usuario hace clic en "Crear orden de compra", ANTES de enviar el formulario:

1. Recorre todas las filas, y por cada una con material seleccionado y cantidad > 0 crea un objeto `{ id_material, cantidad, precio_venta }`.
2. Convierte todo el array a JSON con `JSON.stringify()` y lo guarda en el hidden `materialesJson`.
3. Calcula el total y lo guarda en el hidden `totalOrdenHidden`.
4. Si no hay ítems válidos, previene el envío con `e.preventDefault()` y muestra `alert()`.

El PHP del lado del servidor recibe `$_POST["materiales_json"]` y lo decodifica con `json_decode()`.

---

## Resumen de la arquitectura de funciones

```
agregarFila()          → construye una fila nueva, delega en:
  ├── poblarSelect()   → llena el select con materiales
  ├── recalcularFila() → calcula subtotal de esa fila
  │   └── calcularTotal() → suma todo
  └── reindexarFilas() → renumera

calcularTotal()        → llamada desde cualquier cambio

reindexarFilas()       → llamada solo al eliminar

submit handler         → serializa todo a JSON y valida
```
