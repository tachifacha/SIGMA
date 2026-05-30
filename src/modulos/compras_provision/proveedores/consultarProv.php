<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$correcto = false;
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = (array) ($_SESSION["flash_success"] ?? []);
unset($_SESSION["flash_success"]);

$consulta = $pdo->query("SELECT * FROM proveedores ORDER BY id_proveedor");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Proveedores</title>
</head>
<body>
    <h1>Consultar Proveedores</h1>
    <?php if (!empty($flash_errors) || !empty($flash_success)): ?>
    <div class="flash-messages">
        <?php if (!empty($flash_errors)): ?>
            <?php foreach ($flash_errors as $err): ?>
                <div class="flash-msg flash-msg--error"><?= htmlspecialchars(
                    $err,
                ) ?></div>
            <?php endforeach; ?>
        <?php endif; ?>
        <?php if (!empty($flash_success)): ?>
            <?php foreach ($flash_success as $msg): ?>
                <div class="flash-msg flash-msg--success"><?= htmlspecialchars(
                    $msg,
                ) ?></div>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
    <?php endif; ?>
    <button><a href="añadirProv.php">Añadir</a></button>
    <table border="1">
        <thead>
            <tr>
                <th>Razon social</th>
                <th>CUIT</th>
                <th>Email</th>
                <th>Historial de Cumplimiento</th>
                <th>Direccion</th>
                <th>Telefono</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($consulta as $c): ?>
            <tr>
                <td><?= htmlspecialchars($c["razon_social"]) ?></td>
                <td><?= htmlspecialchars($c["cuit"]) ?></td>
                <td><?= htmlspecialchars($c["email"]) ?></td>
                <td><?= htmlspecialchars($c["historial_cumplimiento"]) ?></td>
                <td><?= htmlspecialchars($c["direccion"]) ?></td>
                <td><?= htmlspecialchars($c["telefono"]) ?></td>
                <!-- acciones -->
                <td>
                    <a href="editarProv.php?id=<?= $c[
                        "id_proveedor"
                    ] ?>">Editar</a>

                    <form action="eliminarProv.php" method="post" style="display:inline"
                          onsubmit="return confirm('¿Seguro de que querés eliminar este proveedor?')">
                        <input type="hidden" name="id" value="<?= $c[
                            "id_proveedor"
                        ] ?>">
                        <button type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <button>
        <a href="apuntar a index">Volver a inicio</a>
    </button>
</body>
</html>
