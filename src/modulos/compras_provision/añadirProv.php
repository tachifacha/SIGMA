<?php
session_start();
require "../../config/conexion.php";

$pdo = db::connect();
$errores = [];
$correcto = false;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $razon_social = trim($_POST["razon_social"]);
    $cuit = trim($_POST["cuit"]);
    $direccion = trim($_POST["direccion"]);
    $telefono = $_POST["telefono"];
    $email = trim($_POST["email"]);
    $historial_cumplimiento = trim($_POST["historial_cumplimiento"]);

    // validaciones
    $validarProv = $pdo->prepare(
        "SELECT COUNT(*) FROM proveedores where razon_social=?",
    );
    $validarProv->execute(['razon_social']);
    if ($validarProv->fetchColumn() > 0) {
        $errores[] = "Proveedor ya existe";
    }
}
