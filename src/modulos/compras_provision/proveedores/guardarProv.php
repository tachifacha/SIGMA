<?php
session_start();
require_once __DIR__ . "/include/common.php";

$pdo = getDB();
$errores = [];
$id = $_POST["id"] ?? null;

$razon_social = trim($_POST["razon_social"] ?? "");
$cuit = trim($_POST["cuit"] ?? "");
$direccion = trim($_POST["direccion"] ?? "");
$telefono = $_POST["telefono"] ?? "";
$email = trim($_POST["email"] ?? "");
$historial_cumplimiento = trim($_POST["historial_cumplimiento"] ?? "");

// Validaciones
$excludeId = $id ? (int)$id : null;

$errores = validateRequired(
    ["razon_social", "cuit", "email", "historial_cumplimiento", "direccion", "telefono"],
    $_POST
);

$err = validateRazonSocial($razon_social, $pdo, $excludeId);
if ($err) $errores[] = $err;

$err = validateCUIT($cuit, $pdo, $excludeId);
if ($err) $errores[] = $err;

$err = validateEmail($email);
if ($err) $errores[] = $err;

if (empty($errores)) {
    try {
        $pdo->beginTransaction();
        if ($id) {
            $stmt = $pdo->prepare(
                "UPDATE proveedores SET razon_social=?, cuit=?, email=?, historial_cumplimiento=?, direccion=?, telefono=? WHERE id_proveedor=?"
            );
            $stmt->execute([$razon_social, $cuit, $email, $historial_cumplimiento, $direccion, $telefono, (int)$id]);
            $pdo->commit();
            setFlashMessage("success", "Proveedor actualizado correctamente");
            header("Location: proveedores.php?edit=" . $id);
        } else {
            $stmt = $pdo->prepare(
                "INSERT INTO proveedores (razon_social, cuit, email, historial_cumplimiento, direccion, telefono) VALUES (?, ?, ?, ?, ?, ?)"
            );
            $stmt->execute([$razon_social, $cuit, $email, $historial_cumplimiento, $direccion, $telefono]);
            $pdo->commit();
            setFlashMessage("success", "Proveedor añadido correctamente");
            header("Location: proveedores.php");
        }
        exit();
    } catch (Exception $e) {
        $pdo->rollBack();
        $errores[] = "Error al guardar proveedor: " . $e->getMessage();
    }
}

// If we get here, there were errors
foreach ($errores as $err) {
    setFlashMessage("error", $err);
}
$redirectId = $id ? "?edit=" . $id : "";
header("Location: proveedores.php" . $redirectId);
exit();
?>