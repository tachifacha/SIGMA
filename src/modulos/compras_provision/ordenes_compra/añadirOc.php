<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$correcto = false;
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = $_SESSION["flash_success"] ?? "";
unset($_SESSION["flash_success"]);

//obtener proveedor y material para select
$proveedores = $pdo
    ->query("SELECT id_proveedor,razon_social FROM proveedores")
    ->fetchAll(PDO::FETCH_ASSOC);
$materiales = $pdo
    ->query("SELECT id_material,nombre FROM materiales")
    ->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_proveedor = trim($_POST["id_proveedor"]);
    $fecha_emision = trim($_POST["fecha_emision"]);
    $id_material = trim($_POST["id_material"]);
    $cantidad = trim($_POST["cantidad"]);
    $precio = trim($_POST["precio"]);
    $estado = trim($_POST["estado"]);

    // validaciones
    if (
        empty($id_proveedor) ||
        empty($fecha_emision) ||
        empty($id_material) ||
        empty($cantidad) ||
        empty($precio) ||
        empty($estado)
    ) {
        $errores[] = "Todos los campos son obligatorios.";
    }
    if ($cantidad <= 0) {
        $errores[] = "La cantidad debe ser mayor a 0.";
    }
    if ($precio <= 0) {
        $errores[] = "El precio debe ser mayor a 0.";
    }

    if (empty($errores)) {
        try {
            $pdo->beginTransaction();
            $stmtoc = $pdo->prepare(
                "INSERT INTO ordenes_compra (id_proveedor, fecha_emision, estado) VALUES (?,?,'EMITIDA')",
            );
            $stmtoc->execute([$id_proveedor, $fecha_emision]);
            $id_oc = $pdo->lastInsertId();
            $stmtocd = $pdo->prepare(
                "INSERT INTO oc_detalle (id_oc, id_material, cantidad, precio) VALUES (?,?,?,?)",
            );
            $stmtocd->execute([$id_oc, $id_material, $cantidad, $precio]);
            $pdo->commit();
            $_SESSION["flash_success"] =
                "Orden de compra añadida correctamente";
            header("Location: consultarOc.php");
            exit();
        } catch (PDOException $e) {
            $pdo->rollBack();
            $errores[] = "Error al añadir orden de compra" . $e->getMessage();
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
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Añadir orden de compra</title>
</head>
<body>
    <?php if (!empty($flash_errors)): ?>
    <div class="flash-messages">
        <?php foreach ($flash_errors as $err): ?>
            <div class="flash-msg flash-msg--error"><?= htmlspecialchars(
                $err,
            ) ?></div>
        <?php endforeach; ?>
    </div>
    <?php endif; ?>

    <?php if ($flash_success): ?>
        <div class="flash-msg flash-msg--success"><?= htmlspecialchars(
            $flash_success,
        ) ?></div>
    <?php endif; ?>
<h1>Añadir orden de compra</h1>
<form action="añadirOc.php" method="post">
    <label for="id_proveedor">Proveedor:</label>
    <select name="id_proveedor" required>
        <option value="">Seleccione un proveedor</option>
        <?php foreach ($proveedores as $p): ?>
        <option value="<?= $p["id_proveedor"] ?>">
            <?= htmlspecialchars($p["razon_social"]) ?>
        </option>
        <?php endforeach; ?>
    </select>
    <br>
    <label for="fecha_emision">Fecha Emision:</label>
    <input type="date" id="fecha_emision" name="fecha_emision" required>
    <br>
    <label for="id_material">Material:</label>
    <select name="id_material" required>
        <option value="">Seleccione un material</option>
    </select>
</form>
</body>
</html>
