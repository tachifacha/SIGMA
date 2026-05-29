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
$provDB = null;
$id = null;

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    if (!isset($_GET["id"])) {
        header("Location: consultarProv.php");
        exit();
    }
    $id = $_GET["id"];

    $stmt = $pdo->prepare("SELECT * FROM proveedores WHERE id_proveedor= ?");
    $stmt->execute([$id]);
    $provDB = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$provDB) {
        header("Location: consultarProv.php");
        exit();
    }
}
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];
    $razon_social = trim($_POST["razon_social"]);
    $cuit = trim($_POST["cuit"]);
    $direccion = trim($_POST["direccion"]);
    $telefono = $_POST["telefono"];
    $email = trim($_POST["email"]);
    $historial_cumplimiento = trim($_POST["historial_cumplimiento"]);

    // validaciones
    // unicidad proveedor
    $validarProv = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where razon_social=? AND id_proveedor != ?",
    );
    $validarProv->execute([$razon_social, $id]);
    if ($validarProv->fetchColumn() > 0) {
        $errores[] = "Proveedor ya existe";
    }

    // unicidad CUIT
    $validarCuit = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where cuit=? AND id_proveedor != ?",
    );
    $validarCuit->execute([$cuit, $id]);
    if ($validarCuit->fetchColumn() > 0) {
        $errores[] = "CUIT ya existe";
    }
    // CUIT once digitos
    if (strlen($cuit) > 11 && strlen($cuit) < 13) {
        $errores[] = "CUIT debe tener 11 dígitos";
    }

    // validar email
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $errores[] = "Email inválido";
    }

    if (
        empty($razon_social) ||
        empty($cuit) ||
        empty($email) ||
        empty($historial_cumplimiento) ||
        empty($direccion) ||
        empty($telefono)
    ) {
        $errores[] = "Todos los campos son obligatorios";
    }

    if (empty($errores)) {
        try {
            $pdo->beginTransaction();
            $stmt = $pdo->prepare(
                "UPDATE proveedores SET razon_social=?, cuit=?, email=?, historial_cumplimiento=?, direccion=?, telefono=? WHERE id_proveedor=?",
            );
            $stmt->execute([
                $razon_social,
                $cuit,
                $email,
                $historial_cumplimiento,
                $direccion,
                $telefono,
                $id,
            ]);
            $pdo->commit();
            $_SESSION["flash_success"] = "Proveedor actualizado correctamente";
            header("Location: editarProv.php?id=" . $id);
            exit();
        } catch (Exception $e) {
            $pdo->rollBack();
            $errores[] = "Error al editar proveedor" . $e->getMessage();
        }
    }

    if (!empty($errores)) {
        $_SESSION["flash_errors"] = $errores;
        header("Location: editarProv.php?id=" . $id);
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Proveedor</title>
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

    <h1>Editar Proveedor</h1>

    <?php if ($provDB): ?>
    <form action="editarProv.php" method="post">
        <input type="hidden" name="id" value="<?= $provDB["id_proveedor"] ?>">
        <label for="razon_social">Razón Social:</label>
        <input type="text" id="razon_social" name="razon_social" value="<?= htmlspecialchars(
            $provDB["razon_social"],
        ) ?>" required>
        <br>
        <label for="cuit">CUIT:</label>
        <input type="text" id="cuit" name="cuit" value="<?= htmlspecialchars(
            $provDB["cuit"],
        ) ?>" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<?= htmlspecialchars(
            $provDB["email"],
        ) ?>" required>
        <br>
        <label for="historial_cumplimiento">Historial de Cumplimiento:</label>
        <input type="text" id="historial_cumplimiento" name="historial_cumplimiento" value="<?= htmlspecialchars(
            $provDB["historial_cumplimiento"],
        ) ?>" required>
        <br>
        <label for="direccion">Dirección:</label>
        <input type="text" id="direccion" name="direccion" value="<?= htmlspecialchars(
            $provDB["direccion"],
        ) ?>" required>
        <br>
        <label for="telefono">Teléfono:</label>
        <input type="number" id="telefono" name="telefono" value="<?= htmlspecialchars(
            $provDB["telefono"],
        ) ?>" required>
        <br>
        <button type="submit">Guardar cambios</button>
    </form>
    <?php endif; ?>
    <button><a href="consultarProv.php">Volver</a></button>
</body>
</html>
