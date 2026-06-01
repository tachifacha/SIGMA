# Diseño: Editar Orden de Compra (editarOc.php)

## Contexto

El CRUD de órdenes de compra tiene Create funcionando (`añadirOc.php` + `ordenes-compra.js`).
Faltan: Consultar, Editar y Eliminar. Este spec cubre **Editar**.

## Objetivo

Permitir modificar TODOS los datos de una OC existente: proveedor, fecha, materiales y cantidades.

## Datos del dominio

| Tabla | Columnas relevantes |
|---|---|
| `ordenes_compra` | id_oc (PK), id_proveedor (FK), fecha_emision, estado, total |
| `oc_detalle` | id_detalle (PK), id_oc (FK), id_material (FK), cantidad |

FK: `oc_detalle.id_oc -> ordenes_compra.id_oc`

## Enfoque: Delete + re-insert en transacción

1. **GET** `editarOc.php?id=12`:
   - Cargar OC existente (`SELECT * FROM ordenes_compra WHERE id_oc = ?`)
   - Cargar detalle con nombres de materiales (`SELECT od.*, m.nombre FROM oc_detalle od JOIN materiales m ...`)
   - Cargar lista de proveedores (mismo query que añadirOc.php)
   - Si la OC no existe → redirigir a consultarOc.php
   - Renderizar el mismo formulario que añadirOc.php, pre-populado

2. **Pre-populación del form**:
   - Proveedor: selected en el `<select>` por id_proveedor
   - Fecha: valor del `<input type="date">`
   - Materiales: JSON existente en `<input id="materialesExistentes">`, JS lee y arma filas al cargar

3. **POST** `editarOc.php`:
   - Misma validación que crear (proveedor, fecha, al menos 1 material)
   - Transacción:
     - `UPDATE ordenes_compra SET id_proveedor=?, fecha_emision=?, total=? WHERE id_oc=?`
     - `DELETE FROM oc_detalle WHERE id_oc=?`
     - `INSERT INTO oc_detalle (id_oc, id_material, cantidad) VALUES ...`
   - Commit → redirigir a consultarOc.php con flash success
   - Rollback en error

4. **JS**: Se reutiliza `ordenes-compra.js` con una extensión:
   - Al DOMContentLoaded, si existe `#materialesExistentes`, parsear el JSON y llamar a una función `cargarMaterialesExistentes()` que agrega filas con los valores pre-cargados

## Restricciones de negocio

- **Todos los estados son editables** (EMITIDA, PENDIENTE, RECIBIDA)
- No se puede cambiar el id_oc
- Se debe proporcionar al menos un material con cantidad > 0

## Archivos a crear/modificar

| Archivo | Acción | Descripción |
|---|---|---|
| `src/modulos/compras_provision/ordenes_compra/editarOc.php` | Crear | Formulario de edición + lógica POST |
| `src/js/ordenes-compra.js` | Modificar | Agregar función `cargarMaterialesExistentes()` |
