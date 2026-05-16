<?php
function getDB(): PDO {
    require_once __DIR__ . "/../../../../config/conexion.php";
    return db::connect();
}

function validateRazonSocial(string $razonSocial, PDO $pdo, ?int $excludeId = null): ?string {
    $sql = "SELECT COUNT(*) FROM proveedores WHERE razon_social = ?";
    $params = [$razonSocial];
    if ($excludeId !== null) {
        $sql .= " AND id_proveedor != ?";
        $params[] = $excludeId;
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchColumn() > 0 ? "Proveedor ya existe" : null;
}

function validateCUIT(string $cuit, PDO $pdo, ?int $excludeId = null): ?string {
    if (strlen($cuit) !== 11) {
        return "CUIT debe tener 11 dígitos";
    }
    $sql = "SELECT COUNT(*) FROM proveedores WHERE cuit = ?";
    $params = [$cuit];
    if ($excludeId !== null) {
        $sql .= " AND id_proveedor != ?";
        $params[] = $excludeId;
    }
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt->fetchColumn() > 0 ? "CUIT ya existe" : null;
}

function validateEmail(string $email): ?string {
    return filter_var($email, FILTER_VALIDATE_EMAIL) ? null : "Email inválido";
}

function validateRequired(array $fields, array $data): array {
    $errors = [];
    foreach ($fields as $field) {
        if (empty(trim($data[$field] ?? ''))) {
            $errors[] = "Todos los campos son obligatorios";
            break;
        }
    }
    return $errors;
}

function setFlashMessage(string $type, string $message): void {
    $_SESSION["flash_{$type}"] = $message;
}

function getFlashMessages(): array {
    $messages = [];
    foreach (['success', 'error'] as $type) {
        $key = "flash_{$type}";
        if (isset($_SESSION[$key])) {
            $messages[$type] = $_SESSION[$key];
            unset($_SESSION[$key]);
        }
    }
    return $messages;
}
?>