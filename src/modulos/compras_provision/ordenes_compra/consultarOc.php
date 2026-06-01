<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();
$flash_errors = $_SESSION["flash_errors"] ?? [];
unset($_SESSION["flash_errors"]);
$flash_success = (array) ($_SESSION["flash_success"] ?? []);
unset($_SESSION["flash_success"]);

$consulta = $pdo
    ->query(
        "SELECT oc.id_oc, oc.fecha_emision, oc.estado, oc.total,
                p.razon_social
         FROM ordenes_compra oc
         JOIN proveedores p ON oc.id_proveedor = p.id_proveedor
         ORDER BY oc.id_oc DESC"
    )
    ->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Órdenes de Compra</title>
    <link rel="stylesheet" href="../../../css/sigma.css">
</head>
<body>
    <h1>Consultar Órdenes de Compra</h1>
    <?php if (!empty($flash_errors) || !empty($flash_success)): ?>
    <div class="flash-messages">
        <?php if (!empty($flash_errors)): ?>
            <?php foreach ($flash_errors as $err): ?>
                <div class="flash-msg flash-msg--error"><?= htmlspecialchars($err) ?></div>
            <?php endforeach; ?>
        <?php endif; ?>
        <?php if (!empty($flash_success)): ?>
            <?php foreach ($flash_success as $msg): ?>
                <div class="flash-msg flash-msg--success"><?= htmlspecialchars($msg) ?></div>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
    <?php endif; ?>

    <button><a href="añadirOc.php">Añadir</a></button>

    <table border="1">
        <thead>
            <tr>
                <th>Proveedor</th>
                <th>Fecha de Emisión</th>
                <th>Estado</th>
                <th>Total</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($consulta as $c): ?>
            <tr>
                <td><?= htmlspecialchars($c["razon_social"]) ?></td>
                <td><?= htmlspecialchars($c["fecha_emision"]) ?></td>
                <td><?= htmlspecialchars($c["estado"]) ?></td>
                <td>$<?= number_format($c["total"], 2, ",", ".") ?></td>
                <td>
                    <a href="editarOc.php?id=<?= $c["id_oc"] ?>">Editar</a>

                    <form action="eliminarOc.php" method="post" style="display:inline"
                          onsubmit="return confirm('¿Seguro de que querés eliminar esta orden de compra?')">
                        <input type="hidden" name="id" value="<?= $c[
                            "id_oc"
                        ] ?>">
                        <button type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>

    <button><a href="añadirOc.php">Volver a inicio</a></button>
</body>
</html>
