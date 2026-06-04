<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();

$id = $_POST["id"] ?? null;

if ($id && is_numeric($id)) {
    // Verificar que no tenga órdenes de compra asociadas
    $checkOc = $pdo->prepare(
        "SELECT COUNT(*) FROM ordenes_compra WHERE id_proveedor = ?",
    );
    $checkOc->execute([$id]);
    if ($checkOc->fetchColumn() > 0) {
        $_SESSION["flash_errors"] = [
            "No se puede eliminar el proveedor porque tiene órdenes de compra asociadas.",
        ];
        header("Location: consultarProv.php");
        exit();
    }

    try {
        $stmt = $pdo->prepare("DELETE FROM proveedores WHERE id_proveedor=?");
        $stmt->execute([$id]);
        $_SESSION["flash_success"] = ["Proveedor eliminado correctamente"];
        header("Location: consultarProv.php");
        exit();
    } catch (Exception $e) {
        $_SESSION["flash_errors"] = [
            "Error al eliminar proveedor: " . $e->getMessage(),
        ];
        header("Location: consultarProv.php");
        exit();
    }
}
?>
