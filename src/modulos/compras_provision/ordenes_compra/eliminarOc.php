<?php
session_start();
require "../../../config/conexion.php";

$pdo = db::connect();

$id = $_POST["id"] ?? null;

if ($id) {
    try {
        $pdo->beginTransaction();

        // Eliminar detalle primero (FK: oc_detalle.id_oc -> ordenes_compra.id_oc)
        $stmtDet = $pdo->prepare("DELETE FROM oc_detalle WHERE id_oc=?");
        $stmtDet->execute([$id]);

        // Eliminar cabecera
        $stmtOc = $pdo->prepare("DELETE FROM ordenes_compra WHERE id_oc=?");
        $stmtOc->execute([$id]);

        $pdo->commit();
        $_SESSION["flash_success"] = ["Orden de compra eliminada correctamente"];
        header("Location: consultarOc.php");
        exit();
    } catch (Exception $e) {
        $pdo->rollBack();
        $_SESSION["flash_errors"] = [
            "Error al eliminar orden de compra: " . $e->getMessage(),
        ];
        header("Location: consultarOc.php");
        exit();
    }
}
