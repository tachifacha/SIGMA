<?php
session_start();
require_once __DIR__ . "/include/common.php";

$pdo = getDB();
$flash = getFlashMessages();

// Check for edit mode
$editId = $_GET["edit"] ?? null;
$proveedorEdit = null;

if ($editId) {
    $stmt = $pdo->prepare("SELECT * FROM proveedores WHERE id_proveedor = ?");
    $stmt->execute([$editId]);
    $proveedorEdit = $stmt->fetch();
}

$consulta = $pdo->query("SELECT * FROM proveedores ORDER BY id_proveedor");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Proveedores</title>
</head>
<body>
    <h1>Gestión de Proveedores</h1>
    <?php if (isset($flash["error"])): ?>
    <div class="flash-messages">
        <div class="flash-msg flash-msg--error"><?= htmlspecialchars($flash["error"]) ?></div>
    </div>
    <?php endif; ?>
    <?php if (isset($flash["success"])): ?>
    <div class="flash-messages">
        <div class="flash-msg flash-msg--success"><?= htmlspecialchars($flash["success"]) ?></div>
    </div>
    <?php endif; ?>

    <button><a href="proveedores.php">Ver Proveedores</a></button>

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
                <td>
                    <a href="proveedores.php?edit=<?= $c["id_proveedor"] ?>">Editar</a>
                    <a href="eliminarProv.php?id=<?= $c["id_proveedor"] ?>">Eliminar</a>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>

    <h2><?= $proveedorEdit ? "Editar Proveedor" : "Añadir Proveedor" ?></h2>
    <form action="guardarProv.php" method="post">
        <?php if ($proveedorEdit): ?>
        <input type="hidden" name="id" value="<?= htmlspecialchars($proveedorEdit["id_proveedor"]) ?>">
        <?php endif; ?>
        <label for="razon_social">Razón Social:</label>
        <input type="text" id="razon_social" name="razon_social" value="<?= htmlspecialchars($proveedorEdit["razon_social"] ?? "") ?>" required>
        <br>
        <label for="cuit">CUIT:</label>
        <input type="text" id="cuit" name="cuit" value="<?= htmlspecialchars($proveedorEdit["cuit"] ?? "") ?>" placeholder="CUIT sin guiones (11 dígitos)" required>
        <br>
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<?= htmlspecialchars($proveedorEdit["email"] ?? "") ?>" required>
        <br>
        <label for="historial_cumplimiento">Historial de Cumplimiento:</label>
        <input type="text" id="historial_cumplimiento" name="historial_cumplimiento" value="<?= htmlspecialchars($proveedorEdit["historial_cumplimiento"] ?? "") ?>" required>
        <br>
        <label for="direccion">Dirección:</label>
        <input type="text" id="direccion" name="direccion" value="<?= htmlspecialchars($proveedorEdit["direccion"] ?? "") ?>" required>
        <br>
        <label for="telefono">Teléfono:</label>
        <input type="number" id="telefono" name="telefono" value="<?= htmlspecialchars($proveedorEdit["telefono"] ?? "") ?>" required>
        <br>
        <button type="submit"><?= $proveedorEdit ? "Guardar cambios" : "Añadir" ?></button>
        <?php if ($proveedorEdit): ?>
        <button type="button"><a href="proveedores.php">Cancelar</a></button>
        <?php endif; ?>
    </form>
</body>
</html>