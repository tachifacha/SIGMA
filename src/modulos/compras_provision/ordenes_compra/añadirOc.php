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

//obtener proveedor y material para select
$proveedores = $pdo
    ->query("SELECT id_proveedor,razon_social FROM proveedores")
    ->fetchAll(PDO::FETCH_ASSOC);
$materiales = $pdo
    ->query("SELECT id_material,nombre FROM materiales")
    ->fetchAll(PDO::FETCH_ASSOC);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $proveedor = trim($_POST["id_proveedor"]);
    $fecha_emision = trim($_POST["fecha_emision"]);
    $material = trim($_POST["id_material"]);
    $cantidad = trim($_POST["cantidad"]);
    $precio = trim($_POST["precio"]);
    $estado = trim($_POST["estado"]);

    // validaciones
    if (
        empty($proveedor) ||
        empty($fecha_emision) ||
        empty($material) ||
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
            $stmtoc->execute([$proveedor, $fecha_emision]);
            $id_oc = $pdo->lastInsertId();
            $stmtocd = $pdo->prepare(
                "INSERT INTO oc_detalle (id_oc, id_material, cantidad, precio) VALUES (?,?,?,?)",
            );
            $stmtocd->execute([$id_oc, $material, $cantidad, $precio]);
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
