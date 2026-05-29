<<<<<<< HEAD
<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$correcto = false;
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = $flash_success = $_SESSION["flash_success"] ?? "";
$_SESSION["flash_success"] ?? [];
unset($_SESSION["flash_success"]);

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $razon_social = trim($_POST["razon_social"]);
    $cuit = trim($_POST["cuit"]);
    $direccion = trim($_POST["direccion"]);
    $telefono = $_POST["telefono"];
    $email = trim($_POST["email"]);
    $historial_cumplimiento = trim($_POST["historial_cumplimiento"]);

    // validaciones
    // unicidad proveedor
    $validarProv = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where razon_social=?",
    );
    $validarProv->execute([$razon_social]);
    if ($validarProv->fetchColumn() > 0) {
        $errores[] = "Proveedor ya existe";
    }

    // unicidad CUIT
    $validarCuit = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where cuit=?",
    );
    $validarCuit->execute([$cuit]);
    if ($validarCuit->fetchColumn() > 0) {
        $errores[] = "CUIT ya existe";
    }
    // CUIT once digitos
    if (strlen($cuit) != 11) {
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
                "INSERT INTO proveedores (razon_social, cuit, email, historial_cumplimiento, direccion, telefono) VALUES (?, ?, ?, ?, ?, ?)",
            );
            $stmt->execute([
                $razon_social,
                $cuit,
                $email,
                $historial_cumplimiento,
                $direccion,
                $telefono,
            ]);
            $pdo->commit();
            $_SESSION["flash_success"] = "Proveedor añadido correctamente";
            header("Location: añadirProv.php");
            exit();
        } catch (Exception $e) {
            $pdo->rollBack();
            $errores[] = "Error al añadir proveedor" . $e->getMessage();
        }
    }

    if (!empty($errores)) {
        $_SESSION["flash_errors"] = $errores;
        header("Location: añadirProv.php");
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir Proveedor</title>
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
    <h1>Añadir Proveedor</h1>
    <form action="añadirProv.php" method="post">
        <label for="razon_social">Razón Social:</label>
        <input type="text" id="razon_social" name="razon_social" placeholder="Tu Razon Social" required>
        <br>
        <label for="cuit">CUIT:</label>
        <input type="text" id="cuit" name="cuit" placeholder="CUIT sin guiones (11 dígitos)" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" placeholder="TuEmail@example.com" required>
        <br>
        <label for="historial_cumplimiento">Historial de Cumplimiento:</label>
        <input type="text" id="historial_cumplimiento" name="historial_cumplimiento" required>
        <br>
        <label for="direccion">Dirección:</label>
        <input type="text" id="direccion" name="direccion" placeholder="Tu Dirección 123" required>
        <br>
        <label for="telefono">Teléfono:</label>
        <input type="number" id="telefono" name="telefono" placeholder="12345678910" required>
        <br>
        <button type="submit">Añadir</button>
    </form>
    <button>
        <a href="apuntar a index despues">Volver a inicio</a>
    </button>
</body>
</html>
=======
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

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $razon_social = trim($_POST["razon_social"]);
    $cuit = trim($_POST["cuit"]);
    $direccion = trim($_POST["direccion"]);
    $telefono = $_POST["telefono"];
    $email = trim($_POST["email"]);
    $historial_cumplimiento = trim($_POST["historial_cumplimiento"]);

    // validaciones
    // unicidad proveedor
    $validarProv = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where razon_social=?",
    );
    $validarProv->execute([$razon_social]);
    if ($validarProv->fetchColumn() > 0) {
        $errores[] = "Proveedor ya existe";
    }

    // unicidad CUIT
    $validarCuit = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where cuit=?",
    );
    $validarCuit->execute([$cuit]);
    if ($validarCuit->fetchColumn() > 0) {
        $errores[] = "CUIT ya existe";
    }
    // CUIT once digitos
    if (strlen($cuit) != 11) {
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
                "INSERT INTO proveedores (razon_social, cuit, email, historial_cumplimiento, direccion, telefono) VALUES (?, ?, ?, ?, ?, ?)",
            );
            $stmt->execute([
                $razon_social,
                $cuit,
                $email,
                $historial_cumplimiento,
                $direccion,
                $telefono,
            ]);
            $pdo->commit();
            $_SESSION["flash_success"] = "Proveedor añadido correctamente";
            header("Location: añadirProv.php");
            exit();
        } catch (Exception $e) {
            $pdo->rollBack();
            $errores[] = "Error al añadir proveedor" . $e->getMessage();
        }
    }

    if (!empty($errores)) {
        $_SESSION["flash_errors"] = $errores;
        header("Location: añadirProv.php");
        exit();
    }
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir Proveedor</title>
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
    <h1>Añadir Proveedor</h1>
    <form action="añadirProv.php" method="post">
        <label for="razon_social">Razón Social:</label>
        <input type="text" id="razon_social" name="razon_social" placeholder="Tu Razon Social" required>
        <br>
        <label for="cuit">CUIT:</label>
        <input type="text" id="cuit" name="cuit" placeholder="CUIT sin guiones (11 dígitos)" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" placeholder="TuEmail@example.com" required>
        <br>
        <label for="historial_cumplimiento">Historial de Cumplimiento:</label>
        <input type="text" id="historial_cumplimiento" name="historial_cumplimiento" required>
        <br>
        <label for="direccion">Dirección:</label>
        <input type="text" id="direccion" name="direccion" placeholder="Tu Dirección 123" required>
        <br>
        <label for="telefono">Teléfono:</label>
        <input type="number" id="telefono" name="telefono" placeholder="12345678910" required>
        <br>
        <button type="submit">Añadir</button>
    </form>
    <button>
        <a href="apuntar a index despues">Volver a inicio</a>
    </button>
</body>
</html>
>>>>>>> 52d952fb4caf85db35038f9d8634db609af918dc
