<?php
require_once "../config/conexion.php";

$pdo = db::connect();

$materiales = $pdo
    ->query(
        "SELECT m.id_material, m.nombre, m.unidad_medida,
        m.precio_venta, c.nombre_categoria
        FROM materiales m
        LEFT JOIN categorias_material c ON m.id_categoria = c.id_categoria
        ORDER BY c.nombre_categoria, m.nombre",
    )
    ->fetchAll(PDO::FETCH_ASSOC);

header("Content-Type: application/json");
echo json_encode($materiales);
