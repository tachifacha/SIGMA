<?php
session_start();
require "../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$correcto = false;
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = $_SESSION["flash_success"] ?? "";
unset($_SESSION["flash_success"]);

$consulta = $pdo->query("SELECT o.*, p.Razon_social as proveedor_nombre FROM ordenes_compra o JOIN proveedores p ON o.id_proveedor = p.id_proveedor ORDER BY o.id_oc");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Ordenes de Compra</title>
</head>
<body>
    <h1>Consultar Ordenes de Compra</h1>
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
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Fecha Emision</th>
                <th>Estado</th>
                <th>Proveedor</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($consulta as $c): ?>
            <tr>
                <td><?= htmlspecialchars($c["id_oc"]) ?></td>
                <td><?= htmlspecialchars($c["fecha_emision"]) ?></td>
                <td><?= htmlspecialchars($c["estado"]) ?></td>
                <td><?= htmlspecialchars($c["proveedor_nombre"]) ?></td>
                <div> <!-- acciones -->
                    <td><a href="a�adirOrden.php?id=<?= $c["id_oc"] ?>">Ver/Editar</a></td>
                    <form action="eliminarOrden.php" method="POST" onsubmit="return confirm('�Est�s seguro de eliminar el registro?');">
                        <input type="hidden" name="id" value="<?= htmlspecialchars($c["id_oc"]) ?>">
                        <button type="submit">Eliminar</button>
                    </form>
                </div>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <button>
        <a href="../../index.php">Volver a inicio</a>
    </button>
</body>
</html>