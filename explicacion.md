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
