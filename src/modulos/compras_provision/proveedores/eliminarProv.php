<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();

$id = $_POST["id"] ?? null;

if ($id) {
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
