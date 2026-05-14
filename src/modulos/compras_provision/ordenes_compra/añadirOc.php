<?php
session_start();
require "../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = $_SESSION["flash_success"] ?? "";
unset($_SESSION["flash_success"]);

$proveedores = $pdo
    ->query("SELECT id_proveedor, razon_social FROM proveedores")
    ->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_proveedor = trim($_POST["id_proveedor"]);
    $fecha_emision = trim($_POST["fecha_emision"]);
    $materiales_data = json_decode($_POST["materiales_json"] ?? "[]", true);

    if (empty($id_proveedor) || empty($fecha_emision)) {
        $errores[] = "El proveedor y la fecha son obligatorios.";
    }

    if (empty($materiales_data)) {
        $errores[] = "Debe agregar al menos un material.";
    }

    if (empty($errores)) {
        try {
            $pdo->beginTransaction();
            $stmtoc = $pdo->prepare(
                "INSERT INTO ordenes_compra (id_proveedor, fecha_emision, estado) VALUES (?, ?, 'EMITIDA')"
            );
            $stmtoc->execute([$id_proveedor, $fecha_emision]);
            $id_oc = $pdo->lastInsertId();

            $stmtDet = $pdo->prepare(
                "INSERT INTO oc_detalle (id_oc, id_material, cantidad, precio) VALUES (?, ?, ?, ?)"
            );
            foreach ($materiales_data as $item) {
                $stmtDet->execute([
                    $id_oc,
                    $item['id_material'],
                    $item['cantidad'],
                    $item['precio_compra']
                ]);
            }

            $pdo->commit();
            $_SESSION["flash_success"] = "Orden de compra creada correctamente";
            header("Location: consultarOc.php");
            exit();
        } catch (PDOException $e) {
            $pdo->rollBack();
            $errores[] = "Error al crear orden de compra: " . $e->getMessage();
        }
    }

    if (!empty($errores)) {
        $_SESSION["flash_errors"] = $errores;
        header("Location: añadirOc.php");
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir orden de compra</title>
    <script src="../../js/ordenes-compra.js" defer></script>
</head>
<body>
    <?php if (!empty($flash_errors)): ?>
    <div class="flash-messages">
        <?php foreach ($flash_errors as $err): ?>
            <div class="flash-msg flash-msg--error"><?= htmlspecialchars($err) ?></div>
        <?php endforeach; ?>
    </div>
    <?php endif; ?>

    <?php if ($flash_success): ?>
        <div class="flash-msg flash-msg--success"><?= htmlspecialchars($flash_success) ?></div>
    <?php endif; ?>

    <h1>Añadir orden de compra</h1>

    <form action="añadirOc.php" method="post" id="ocForm">
        <table class="tabla-oc" id="tablaOC">
            <thead>
                <tr>
                    <th colspan="7" class="titulo-oc">ORDEN DE COMPRA</th>
                </tr>
            </thead>
            <tbody>
                <tr class="fila-encabezado">
                    <td class="label-cell">Proveedor</td>
                    <td colspan="3">
                        <select name="id_proveedor" required>
                            <option value="">-- Seleccione proveedor --</option>
                            <?php foreach ($proveedores as $p): ?>
                                <option value="<?= $p['id_proveedor'] ?>">
                                    <?= htmlspecialchars($p['razon_social']) ?>
                                </option>
                            <?php endforeach; ?>
                        </select>
                    </td>
                    <td class="label-cell">Fecha</td>
                    <td colspan="2">
                        <input type="date" name="fecha_emision" required>
                    </td>
                </tr>

                <tr class="fila-columnas">
                    <th>#</th>
                    <th colspan="2">Material</th>
                    <th>Cantidad</th>
                    <th>Unidad</th>
                    <th>Precio Compra</th>
                    <th>Subtotal</th>
                </tr>

                <tr class="fila-material template" style="display: none;">
                    <td class="num-row"></td>
                    <td colspan="2">
                        <select class="material-select">
                            <option value="">--</option>
                        </select>
                        <input type="hidden" class="hidden-id" name="materiales[id_material][]">
                    </td>
                    <td>
                        <input type="number" class="cantidad-input" min="1" value="1">
                        <input type="hidden" class="hidden-cant" name="materiales[cantidad][]">
                    </td>
                    <td class="unidad-cell"></td>
                    <td class="precio-cell">$0</td>
                    <td class="subtotal-cell">$0.00</td>
                    <td class="accion-cell">
                        <button type="button" class="btn-eliminar-fila" title="Eliminar">✕</button>
                    </td>
                </tr>

                <tr class="fila-agregar">
                    <td colspan="7">
                        <button type="button" id="agregarFilaBtn" class="btn-agregar-fila">
                            + Agregar material
                        </button>
                    </td>
                </tr>

                <tr class="fila-total">
                    <td colspan="6" class="text-right"><strong>TOTAL ORDEN:</strong></td>
                    <td id="totalOrden"><strong>$0.00</strong></td>
                </tr>
            </tbody>
        </table>

        <input type="hidden" name="materiales_json" id="materialesJson">

        <div class="acciones-form">
            <button type="submit" class="btn-submit">✓ Crear orden de compra</button>
            <a href="consultarOc.php" class="btn-cancel">Cancelar</a>
        </div>
    </form>
</body>
</html>