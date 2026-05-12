-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost
-- Tiempo de generación: 09-05-2026 a las 17:50:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `app_datos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones_obra`
--

CREATE TABLE `asignaciones_obra` (
  `id_asignacion` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `id_obra` int(11) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asignaciones_obra`
--

INSERT INTO `asignaciones_obra` (`id_asignacion`, `id_empleado`, `id_obra`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 1, 1, '2026-01-10', NULL),
(2, 2, 1, '2026-01-10', NULL),
(3, 3, 1, '2026-01-12', NULL),
(4, 5, 1, '2026-01-15', NULL),
(5, 7, 1, '2026-02-01', NULL),
(6, 6, 2, '2026-02-05', NULL),
(7, 3, 2, '2026-02-05', NULL),
(8, 5, 2, '2026-02-06', NULL),
(9, 8, 2, '2026-02-10', NULL),
(10, 9, 2, '2026-02-10', NULL),
(11, 2, 3, '2026-03-01', '2026-08-30'),
(12, 11, 3, '2026-03-03', '2026-08-30'),
(13, 12, 3, '2026-03-03', '2026-08-30'),
(14, 1, 4, '2026-01-20', NULL),
(15, 10, 4, '2026-01-22', NULL),
(16, 4, 4, '2026-01-22', NULL),
(17, 7, 4, '2026-02-15', NULL),
(18, 8, 5, '2026-04-01', NULL),
(19, 5, 5, '2026-04-01', NULL),
(20, 11, 5, '2026-04-05', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `id_asistencia` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora_ingreso` time DEFAULT NULL,
  `hora_egreso` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asistencia`
--

INSERT INTO `asistencia` (`id_asistencia`, `id_empleado`, `fecha`, `hora_ingreso`, `hora_egreso`) VALUES
(1, 1, '2026-04-01', '07:55:00', '17:05:00'),
(2, 2, '2026-04-01', '08:00:00', '16:45:00'),
(3, 3, '2026-04-01', '07:45:00', '17:10:00'),
(4, 5, '2026-04-01', '07:58:00', '17:00:00'),
(5, 7, '2026-04-01', '08:10:00', '16:50:00'),
(6, 6, '2026-04-01', '08:00:00', '17:15:00'),
(7, 8, '2026-04-01', '07:50:00', '16:40:00'),
(8, 9, '2026-04-01', '08:05:00', '17:00:00'),
(9, 10, '2026-04-01', '08:30:00', '17:30:00'),
(10, 11, '2026-04-01', '07:40:00', '16:55:00'),
(11, 12, '2026-04-01', '08:00:00', '16:30:00'),
(12, 4, '2026-04-01', '08:15:00', '17:20:00'),
(13, 1, '2026-04-02', '07:50:00', '17:00:00'),
(14, 3, '2026-04-02', '07:48:00', '17:12:00'),
(15, 5, '2026-04-02', '08:02:00', '16:58:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias_material`
--

CREATE TABLE `categorias_material` (
  `id_categoria` int(11) NOT NULL,
  `nombre_categoria` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categorias_material`
--

INSERT INTO `categorias_material` (`id_categoria`, `nombre_categoria`) VALUES
(1, 'Cementos y cales'),
(2, 'Áridos'),
(3, 'Hierros y perfiles'),
(4, 'Ladrillos y bloques'),
(5, 'Instalación eléctrica'),
(6, 'Instalación sanitaria'),
(7, 'Pinturería'),
(8, 'Aislaciones'),
(9, 'Carpintería'),
(10, 'Seguridad industrial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `razon_social` varchar(100) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `razon_social`, `cuit`, `direccion`, `telefono`, `email`) VALUES
(1, 'Desarrollos Urbanos SA', '30-71234567-1', 'Av. Italia 450, Resistencia', '3624001001', 'compras@duurbanos.com'),
(2, 'Municipalidad de Fontana', '30-99911122-3', 'Av. Alvear 4900, Fontana', '3624002002', 'obraspublicas@fontana.gob.ar'),
(3, 'Ministerio de Educación Chaco', '30-88877766-5', 'Marcelo T. de Alvear 145, Resistencia', '3624003003', 'infraestructura@educacionchaco.gob.ar'),
(4, 'Logística del Nordeste SRL', '30-74561234-8', 'Parque Industrial 22, Resistencia', '3624004004', 'admin@ldn.com.ar'),
(5, 'Inversiones Mitre SAS', '30-70123456-9', 'Mitre 540, Resistencia', '3624005005', 'proyectos@mitresas.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuenta_corriente`
--

CREATE TABLE `cuenta_corriente` (
  `id_movimiento` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_venta` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `monto` decimal(12,2) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cuenta_corriente`
--

INSERT INTO `cuenta_corriente` (`id_movimiento`, `id_cliente`, `id_venta`, `fecha`, `monto`, `tipo`) VALUES
(1, 1, 1, '2026-01-08', 6450000.00, 'DEBITO'),
(2, 1, 1, '2026-01-20', 2000000.00, 'CREDITO'),
(3, 1, 1, '2026-02-15', 1500000.00, 'CREDITO'),
(4, 2, 2, '2026-02-01', 8685000.00, 'DEBITO'),
(5, 2, 2, '2026-02-25', 3000000.00, 'CREDITO'),
(6, 2, 2, '2026-03-20', 2500000.00, 'CREDITO'),
(7, 3, 3, '2026-02-28', 2235000.00, 'DEBITO'),
(8, 3, 3, '2026-03-15', 1000000.00, 'CREDITO'),
(9, 4, 4, '2026-01-18', 5040000.00, 'DEBITO'),
(10, 4, 4, '2026-02-05', 2000000.00, 'CREDITO'),
(11, 5, NULL, '2026-04-05', 350000.00, 'CREDITO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `categoria_laboral` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `nombre`, `apellido`, `dni`, `categoria_laboral`) VALUES
(1, 'Juan', 'Pérez', '30111222', 'Maestro mayor de obras'),
(2, 'María', 'Gómez', '28999888', 'Arquitecta'),
(3, 'Carlos', 'López', '31555444', 'Capataz'),
(4, 'Ana', 'Martínez', '33444555', 'Administrativa'),
(5, 'Diego', 'Fernández', '29888777', 'Albañil'),
(6, 'Lucía', 'Ramírez', '32777111', 'Ingeniera civil'),
(7, 'Pedro', 'Sosa', '31111999', 'Electricista'),
(8, 'Sofía', 'Torres', '35666777', 'Sanitarista'),
(9, 'Miguel', 'Benítez', '29000111', 'Chofer'),
(10, 'Valeria', 'Acuña', '33999444', 'Compras'),
(11, 'Ricardo', 'Medina', '28123456', 'Herrero'),
(12, 'Florencia', 'Vega', '34777888', 'Seguridad e higiene');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evaluaciones`
--

CREATE TABLE `evaluaciones` (
  `id_evaluacion` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha` date DEFAULT NULL,
  `puntaje` int(11) DEFAULT NULL,
  `comentarios` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `evaluaciones`
--

INSERT INTO `evaluaciones` (`id_evaluacion`, `id_empleado`, `fecha`, `puntaje`, `comentarios`) VALUES
(1, 1, '2026-03-31', 9, 'Excelente coordinación general de obra y cumplimiento de objetivos.'),
(2, 2, '2026-03-31', 10, 'Muy buen desempeño técnico y comunicación con clientes.'),
(3, 3, '2026-03-31', 8, 'Buena supervisión del equipo y control de avances.'),
(4, 5, '2026-03-31', 7, 'Correcta ejecución de tareas de mampostería.'),
(5, 7, '2026-03-31', 8, 'Instalaciones eléctricas ejecutadas según pliego.'),
(6, 8, '2026-03-31', 8, 'Buen cumplimiento en instalaciones sanitarias.'),
(7, 10, '2026-03-31', 9, 'Excelente gestión de compras y negociación con proveedores.'),
(8, 12, '2026-03-31', 9, 'Muy buen seguimiento de normas de seguridad e higiene.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `materiales`
--

CREATE TABLE `materiales` (
  `id_material` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `stock_minimo` decimal(10,2) DEFAULT NULL,
  `unidad_medida` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `materiales`
--

INSERT INTO `materiales` (`id_material`, `nombre`, `descripcion`, `id_categoria`, `stock_minimo`, `unidad_medida`) VALUES
(1, 'Cemento Portland x 50kg', 'Bolsa de cemento Portland de uso general', 1, 200.00, 'bolsa'),
(2, 'Cal hidratada x 25kg', 'Cal para revoques y mezclas', 1, 100.00, 'bolsa'),
(3, 'Arena fina', 'Árido fino para mezcla y terminaciones', 2, 20.00, 'm3'),
(4, 'Piedra partida 6/20', 'Árido grueso para hormigón', 2, 30.00, 'm3'),
(5, 'Hierro ADN 8mm', 'Barra de hierro nervado 8 mm', 3, 150.00, 'barra'),
(6, 'Hierro ADN 12mm', 'Barra de hierro nervado 12 mm', 3, 120.00, 'barra'),
(7, 'Perfil C 100', 'Perfil galvanizado estructural', 3, 80.00, 'unidad'),
(8, 'Ladrillo hueco 18x18x33', 'Ladrillo cerámico hueco portante', 4, 3000.00, 'unidad'),
(9, 'Bloque de hormigón 19x19x39', 'Bloque para cerramiento y muros', 4, 1500.00, 'unidad'),
(10, 'Cable unipolar 2,5 mm', 'Cable normalizado para instalación eléctrica', 5, 500.00, 'metro'),
(11, 'Cable unipolar 4 mm', 'Cable para tomas especiales', 5, 300.00, 'metro'),
(12, 'Caño corrugado 3/4', 'Caño plástico corrugado para embutir', 5, 200.00, 'metro'),
(13, 'Caño PVC 110 mm', 'Caño PVC para desagüe cloacal', 6, 60.00, 'metro'),
(14, 'Caño termofusión 20 mm', 'Caño para agua fría/caliente', 6, 120.00, 'metro'),
(15, 'Pintura látex interior blanco 20L', 'Pintura interior de alto rendimiento', 7, 25.00, 'balde'),
(16, 'Membrana asfáltica 4 mm', 'Membrana aluminizada para impermeabilización', 8, 40.00, 'rollo'),
(17, 'Puerta placa interior 80x200', 'Puerta placa marco de chapa', 9, 10.00, 'unidad'),
(18, 'Casco de seguridad', 'Elemento de protección personal', 10, 30.00, 'unidad'),
(19, 'Guantes de descarne', 'Guantes reforzados para obra', 10, 50.00, 'par'),
(20, 'Botas de seguridad', 'Calzado con puntera reforzada', 10, 20.00, 'par');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_material`
--

CREATE TABLE `movimientos_material` (
  `id_movimiento` int(11) NOT NULL,
  `id_material` int(11) NOT NULL,
  `id_obra` int(11) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimientos_material`
--

INSERT INTO `movimientos_material` (`id_movimiento`, `id_material`, `id_obra`, `tipo`, `fecha`, `cantidad`, `id_usuario`, `observaciones`) VALUES
(1, 1, NULL, 'INGRESO', '2026-01-05', 800.00, 4, 'Ingreso inicial de stock por apertura de ejercicio.'),
(2, 2, NULL, 'INGRESO', '2026-01-05', 300.00, 4, 'Ingreso inicial de stock.'),
(3, 3, NULL, 'INGRESO', '2026-01-05', 120.00, 4, 'Stock inicial arena fina.'),
(4, 4, NULL, 'INGRESO', '2026-01-05', 160.00, 4, 'Stock inicial piedra partida.'),
(5, 5, NULL, 'INGRESO', '2026-01-05', 500.00, 4, 'Stock inicial hierro 8 mm.'),
(6, 6, NULL, 'INGRESO', '2026-01-05', 350.00, 4, 'Stock inicial hierro 12 mm.'),
(7, 8, NULL, 'INGRESO', '2026-01-05', 12000.00, 4, 'Stock inicial ladrillos.'),
(8, 10, NULL, 'INGRESO', '2026-01-05', 2500.00, 4, 'Stock inicial cables 2,5 mm.'),
(9, 13, NULL, 'INGRESO', '2026-01-05', 250.00, 4, 'Stock inicial caños PVC.'),
(10, 18, NULL, 'INGRESO', '2026-01-05', 100.00, 4, 'Ingreso inicial EPP.'),
(11, 1, 1, 'EGRESO', '2026-01-15', 180.00, 2, 'Hormigonado de bases en Edificio Altos del Centro.'),
(12, 4, 1, 'EGRESO', '2026-01-15', 25.00, 2, 'Uso en fundaciones.'),
(13, 5, 1, 'EGRESO', '2026-01-18', 120.00, 2, 'Armado de columnas y vigas.'),
(14, 8, 1, 'EGRESO', '2026-02-02', 2500.00, 2, 'Mampostería planta baja.'),
(15, 1, 2, 'EGRESO', '2026-02-20', 220.00, 3, 'Platea inicial del complejo.'),
(16, 6, 2, 'EGRESO', '2026-02-22', 140.00, 3, 'Estructura principal módulo A.'),
(17, 13, 2, 'EGRESO', '2026-03-05', 45.00, 3, 'Desagües sanitarios etapa 1.'),
(18, 10, 3, 'EGRESO', '2026-03-12', 320.00, 2, 'Recambio de instalación eléctrica aulas.'),
(19, 15, 3, 'EGRESO', '2026-03-20', 18.00, 2, 'Pintura interior de aulas refaccionadas.'),
(20, 18, 4, 'EGRESO', '2026-02-01', 15.00, 1, 'Entrega de cascos para nuevo frente de obra.'),
(21, 19, 4, 'INGRESO', '2026-02-10', 80.00, 4, 'Compra de guantes para cuadrilla.'),
(22, 14, 5, 'EGRESO', '2026-04-06', 90.00, 2, 'Instalación sanitaria locales comerciales.'),
(23, 17, 5, 'INGRESO', '2026-04-03', 12.00, 4, 'Recepción de puertas interiores.'),
(24, 16, 1, 'INGRESO', '2026-03-25', 50.00, 4, 'Compra de membrana para cubierta.'),
(25, 16, 1, 'EGRESO', '2026-04-02', 12.00, 2, 'Impermeabilización de losa.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `obras`
--

CREATE TABLE `obras` (
  `id_obra` int(11) NOT NULL,
  `nombre_obra` varchar(100) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin_estimada` date DEFAULT NULL,
  `presupuesto_materiales` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `obras`
--

INSERT INTO `obras` (`id_obra`, `nombre_obra`, `direccion`, `fecha_inicio`, `fecha_fin_estimada`, `presupuesto_materiales`) VALUES
(1, 'Edificio Altos del Centro', 'Av. San Martín 1250, Resistencia', '2026-01-10', '2026-12-20', 18500000.00),
(2, 'Complejo Habitacional Norte', 'Ruta 11 Km 1012, Fontana', '2026-02-05', '2027-03-15', 25400000.00),
(3, 'Refacción Escuela Técnica N°4', 'Calle 12 N°845, Barranqueras', '2026-03-01', '2026-08-30', 6200000.00),
(4, 'Centro Logístico Sigma', 'Parque Industrial Lote 18', '2026-01-20', '2026-10-15', 14350000.00),
(5, 'Locales Comerciales Mitre', 'Mitre 540, Resistencia', '2026-04-01', '2026-11-30', 9800000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `oc_detalle`
--

CREATE TABLE `oc_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_oc` int(11) NOT NULL,
  `id_material` int(11) NOT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `oc_detalle`
--

INSERT INTO `oc_detalle` (`id_detalle`, `id_oc`, `id_material`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 1, 800.00, 7200.00),
(2, 1, 2, 300.00, 4100.00),
(3, 1, 3, 120.00, 18500.00),
(4, 1, 4, 160.00, 22300.00),
(5, 1, 8, 12000.00, 950.00),
(6, 2, 5, 500.00, 12300.00),
(7, 2, 6, 350.00, 19800.00),
(8, 2, 7, 90.00, 45000.00),
(9, 3, 10, 1500.00, 850.00),
(10, 3, 11, 800.00, 1320.00),
(11, 3, 12, 500.00, 690.00),
(12, 4, 13, 120.00, 9800.00),
(13, 4, 14, 240.00, 3500.00),
(14, 5, 15, 40.00, 112000.00),
(15, 5, 16, 60.00, 98000.00),
(16, 6, 17, 12.00, 185000.00),
(17, 6, 18, 40.00, 22000.00),
(18, 6, 19, 80.00, 9800.00),
(19, 6, 20, 25.00, 45000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ordenes_compra`
--

CREATE TABLE `ordenes_compra` (
  `id_oc` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `fecha_emision` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ordenes_compra`
--

INSERT INTO `ordenes_compra` (`id_oc`, `id_proveedor`, `fecha_emision`, `estado`) VALUES
(1, 1, '2026-01-03', 'RECIBIDA'),
(2, 2, '2026-01-04', 'RECIBIDA'),
(3, 3, '2026-02-25', 'RECIBIDA'),
(4, 4, '2026-03-01', 'RECIBIDA'),
(5, 5, '2026-03-15', 'PENDIENTE'),
(6, 1, '2026-04-02', 'EMITIDA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presupuestos`
--

CREATE TABLE `presupuestos` (
  `id_presupuesto` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `presupuestos`
--

INSERT INTO `presupuestos` (`id_presupuesto`, `id_cliente`, `fecha_emision`, `fecha_vencimiento`, `estado`) VALUES
(1, 1, '2025-12-15', '2026-01-15', 'Aprobado'),
(2, 2, '2026-01-20', '2026-02-20', 'Aprobado'),
(3, 3, '2026-02-10', '2026-03-10', 'Aprobado'),
(4, 4, '2025-12-28', '2026-01-28', 'Aprobado'),
(5, 5, '2026-03-10', '2026-04-10', 'Pendiente'),
(6, 1, '2026-04-01', '2026-04-30', 'En revisión');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presupuesto_detalle`
--

CREATE TABLE `presupuesto_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_presupuesto` int(11) NOT NULL,
  `id_material` int(11) NOT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `precio_unitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `presupuesto_detalle`
--

INSERT INTO `presupuesto_detalle` (`id_detalle`, `id_presupuesto`, `id_material`, `cantidad`, `precio_unitario`) VALUES
(1, 1, 1, 1800.00, 8500.00),
(2, 1, 5, 650.00, 14500.00),
(3, 1, 8, 18000.00, 1250.00),
(4, 1, 16, 120.00, 125000.00),
(5, 2, 1, 2400.00, 8600.00),
(6, 2, 6, 950.00, 22000.00),
(7, 2, 9, 12000.00, 1650.00),
(8, 2, 13, 350.00, 12500.00),
(9, 3, 10, 1200.00, 1200.00),
(10, 3, 15, 60.00, 135000.00),
(11, 3, 18, 60.00, 28000.00),
(12, 4, 1, 1500.00, 8700.00),
(13, 4, 7, 160.00, 62000.00),
(14, 4, 18, 80.00, 30000.00),
(15, 5, 14, 200.00, 4800.00),
(16, 5, 17, 18.00, 240000.00),
(17, 6, 3, 50.00, 25000.00),
(18, 6, 4, 60.00, 29000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `razon_social` varchar(100) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `historial_cumplimiento` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`id_proveedor`, `razon_social`, `cuit`, `direccion`, `telefono`, `email`, `historial_cumplimiento`) VALUES
(1, 'Corralón El Constructor SA', '30-62345123-7', 'Av. Sarmiento 3200, Resistencia', '3624101001', 'ventas@elconstructor.com.ar', 'Cumple con entregas en tiempo y forma.'),
(2, 'Hierros del Litoral SRL', '30-61234999-4', 'Ruta 16 Km 15, Resistencia', '3624102002', 'pedidos@hierroslitoral.com', 'Buen cumplimiento, con leves demoras en alta demanda.'),
(3, 'Electricidad Integral SAS', '30-69888777-1', 'French 890, Resistencia', '3624103003', 'comercial@electrointegral.com', 'Entrega rápida y documentación completa.'),
(4, 'Sanitarios del Nordeste', '30-64567890-2', 'Av. Castelli 2100, Resistencia', '3624104004', 'ventas@sanitariosnordeste.com', 'Excelente atención postventa.'),
(5, 'Pinturerías Color Hogar', '30-63332221-8', '9 de Julio 1500, Resistencia', '3624105005', 'empresas@colorhogar.com', 'Provee primeras marcas y asesora técnicamente.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepciones`
--

CREATE TABLE `recepciones` (
  `id_recepcion` int(11) NOT NULL,
  `id_oc` int(11) NOT NULL,
  `fecha_recepcion` date DEFAULT NULL,
  `numero_remito` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepciones`
--

INSERT INTO `recepciones` (`id_recepcion`, `id_oc`, `fecha_recepcion`, `numero_remito`) VALUES
(1, 1, '2026-01-05', 'REM-0001-00004521'),
(2, 2, '2026-01-06', 'REM-0002-00001874'),
(3, 3, '2026-02-28', 'REM-0003-00006711'),
(4, 4, '2026-03-04', 'REM-0004-00003190'),
(5, 6, '2026-04-05', 'REM-0001-00005210');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `recepcion_detalle`
--

CREATE TABLE `recepcion_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_recepcion` int(11) NOT NULL,
  `id_material` int(11) NOT NULL,
  `cantidad_recibida` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `recepcion_detalle`
--

INSERT INTO `recepcion_detalle` (`id_detalle`, `id_recepcion`, `id_material`, `cantidad_recibida`) VALUES
(1, 1, 1, 800.00),
(2, 1, 2, 300.00),
(3, 1, 3, 120.00),
(4, 1, 4, 160.00),
(5, 1, 8, 12000.00),
(6, 2, 5, 500.00),
(7, 2, 6, 350.00),
(8, 2, 7, 90.00),
(9, 3, 10, 1500.00),
(10, 3, 11, 800.00),
(11, 3, 12, 500.00),
(12, 4, 13, 120.00),
(13, 4, 14, 240.00),
(14, 5, 17, 12.00),
(15, 5, 18, 40.00),
(16, 5, 19, 80.00),
(17, 5, 20, 25.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_rol`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Jefe de Compras'),
(3, 'Encargado de Depósito'),
(4, 'Vendedor'),
(5, 'Administración'),
(6, 'Gestor de RRHH'),
(7, 'Jefe de Obra');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tokens`
--

CREATE TABLE `tokens` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','jefe_compras','paniol','vendedor','rrhh','jefe_obra') NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `creado`) VALUES
(1, 'leo', 'leo@gmail.com', '$2y$10$RKCZaAz.Ps7hIL7IjE1pVumCiodOuva7a7i3Z/MVYVErX0fJkH65e', 'admin', '2026-04-15 23:35:27'),
(2, 'dani', 'dani@gmail.com', '$2y$10$K36SqCtsM.BcV3z04aisNOrt8wokZdAiwEU42U5LbjPvBC3.3b.sW', 'jefe_compras', '2026-04-16 00:07:56'),
(3, 'tachi', 'tachi@gmail.com', '$2y$10$yOEERiVysOyBQW0ZGq2YGeGel6t9KFXhTjd8F5jnRmSLyFR2h3GMe', 'vendedor', '2026-04-15 23:49:03'),
(4, 'gigi', 'gigi@gmail.com', '$2y$10$FztWLCOdeZe4MqwNf5wP9..CqYPVmVf9Y1rOf489r3oFfl/Y8KMcK', 'jefe_obra', '2026-04-16 00:23:42'),
(5, 'mario', 'mario@gmail.com', '$2y$10$71um3bHj.rYPEgaMbongSeqvL6l1bVzuLw/Y.9GSzlyxg.Kq9KVmi', 'paniol', '2026-04-16 00:26:17'),
(6, 'andres', 'andres@gmail.com', '$2y$10$958cFoG7tBtwY/RneQAuOe7Qu6cK6YIsDRhiM83OycOdqW2jjE94S', 'rrhh', '2026-04-16 00:29:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios3`
--

CREATE TABLE `usuarios3` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `contraseña_hash` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios3`
--

INSERT INTO `usuarios3` (`id_usuario`, `nombre_usuario`, `contraseña_hash`, `id_rol`) VALUES
(1, 'admin', 'hash_admin_123', 1),
(2, 'jperez', 'hash_jperez_123', 2),
(3, 'mgomez', 'hash_mgomez_123', 2),
(4, 'deposito1', 'hash_deposito_123', 3),
(5, 'compras1', 'hash_compras_123', 4),
(6, 'admin_finanzas', 'hash_finanzas_123', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `id_presupuesto` int(11) NOT NULL,
  `fecha_venta` date DEFAULT NULL,
  `total` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `id_presupuesto`, `fecha_venta`, `total`) VALUES
(1, 1, '2026-01-08', 21500000.00),
(2, 2, '2026-02-01', 28950000.00),
(3, 3, '2026-02-28', 7450000.00),
(4, 4, '2026-01-18', 16800000.00);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asignaciones_obra`
--
ALTER TABLE `asignaciones_obra`
  ADD PRIMARY KEY (`id_asignacion`),
  ADD KEY `id_empleado` (`id_empleado`),
  ADD KEY `id_obra` (`id_obra`);

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`id_asistencia`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `categorias_material`
--
ALTER TABLE `categorias_material`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `cuenta_corriente`
--
ALTER TABLE `cuenta_corriente`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_venta` (`id_venta`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `evaluaciones`
--
ALTER TABLE `evaluaciones`
  ADD PRIMARY KEY (`id_evaluacion`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `materiales`
--
ALTER TABLE `materiales`
  ADD PRIMARY KEY (`id_material`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `movimientos_material`
--
ALTER TABLE `movimientos_material`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_material` (`id_material`),
  ADD KEY `id_obra` (`id_obra`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `obras`
--
ALTER TABLE `obras`
  ADD PRIMARY KEY (`id_obra`);

--
-- Indices de la tabla `oc_detalle`
--
ALTER TABLE `oc_detalle`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_oc` (`id_oc`),
  ADD KEY `id_material` (`id_material`);

--
-- Indices de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD PRIMARY KEY (`id_oc`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `presupuestos`
--
ALTER TABLE `presupuestos`
  ADD PRIMARY KEY (`id_presupuesto`),
  ADD KEY `id_cliente` (`id_cliente`);

--
-- Indices de la tabla `presupuesto_detalle`
--
ALTER TABLE `presupuesto_detalle`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_presupuesto` (`id_presupuesto`),
  ADD KEY `id_material` (`id_material`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD PRIMARY KEY (`id_recepcion`),
  ADD KEY `id_oc` (`id_oc`);

--
-- Indices de la tabla `recepcion_detalle`
--
ALTER TABLE `recepcion_detalle`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_recepcion` (`id_recepcion`),
  ADD KEY `id_material` (`id_material`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre`);

--
-- Indices de la tabla `usuarios3`
--
ALTER TABLE `usuarios3`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `nombre_usuario` (`nombre_usuario`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_presupuesto` (`id_presupuesto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `asignaciones_obra`
--
ALTER TABLE `asignaciones_obra`
  MODIFY `id_asignacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  MODIFY `id_asistencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `categorias_material`
--
ALTER TABLE `categorias_material`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cuenta_corriente`
--
ALTER TABLE `cuenta_corriente`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `evaluaciones`
--
ALTER TABLE `evaluaciones`
  MODIFY `id_evaluacion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `materiales`
--
ALTER TABLE `materiales`
  MODIFY `id_material` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `movimientos_material`
--
ALTER TABLE `movimientos_material`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `obras`
--
ALTER TABLE `obras`
  MODIFY `id_obra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `oc_detalle`
--
ALTER TABLE `oc_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  MODIFY `id_oc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `presupuestos`
--
ALTER TABLE `presupuestos`
  MODIFY `id_presupuesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `presupuesto_detalle`
--
ALTER TABLE `presupuesto_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `recepciones`
--
ALTER TABLE `recepciones`
  MODIFY `id_recepcion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `recepcion_detalle`
--
ALTER TABLE `recepcion_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `usuarios3`
--
ALTER TABLE `usuarios3`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignaciones_obra`
--
ALTER TABLE `asignaciones_obra`
  ADD CONSTRAINT `asignaciones_obra_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `asignaciones_obra_ibfk_2` FOREIGN KEY (`id_obra`) REFERENCES `obras` (`id_obra`);

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `cuenta_corriente`
--
ALTER TABLE `cuenta_corriente`
  ADD CONSTRAINT `cuenta_corriente_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `cuenta_corriente_ibfk_2` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`);

--
-- Filtros para la tabla `evaluaciones`
--
ALTER TABLE `evaluaciones`
  ADD CONSTRAINT `evaluaciones_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `materiales`
--
ALTER TABLE `materiales`
  ADD CONSTRAINT `materiales_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias_material` (`id_categoria`);

--
-- Filtros para la tabla `movimientos_material`
--
ALTER TABLE `movimientos_material`
  ADD CONSTRAINT `movimientos_material_ibfk_1` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`),
  ADD CONSTRAINT `movimientos_material_ibfk_2` FOREIGN KEY (`id_obra`) REFERENCES `obras` (`id_obra`),
  ADD CONSTRAINT `movimientos_material_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios3` (`id_usuario`);

--
-- Filtros para la tabla `oc_detalle`
--
ALTER TABLE `oc_detalle`
  ADD CONSTRAINT `oc_detalle_ibfk_1` FOREIGN KEY (`id_oc`) REFERENCES `ordenes_compra` (`id_oc`),
  ADD CONSTRAINT `oc_detalle_ibfk_2` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`);

--
-- Filtros para la tabla `ordenes_compra`
--
ALTER TABLE `ordenes_compra`
  ADD CONSTRAINT `ordenes_compra_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`);

--
-- Filtros para la tabla `presupuestos`
--
ALTER TABLE `presupuestos`
  ADD CONSTRAINT `presupuestos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);

--
-- Filtros para la tabla `presupuesto_detalle`
--
ALTER TABLE `presupuesto_detalle`
  ADD CONSTRAINT `presupuesto_detalle_ibfk_1` FOREIGN KEY (`id_presupuesto`) REFERENCES `presupuestos` (`id_presupuesto`),
  ADD CONSTRAINT `presupuesto_detalle_ibfk_2` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`);

--
-- Filtros para la tabla `recepciones`
--
ALTER TABLE `recepciones`
  ADD CONSTRAINT `recepciones_ibfk_1` FOREIGN KEY (`id_oc`) REFERENCES `ordenes_compra` (`id_oc`);

--
-- Filtros para la tabla `recepcion_detalle`
--
ALTER TABLE `recepcion_detalle`
  ADD CONSTRAINT `recepcion_detalle_ibfk_1` FOREIGN KEY (`id_recepcion`) REFERENCES `recepciones` (`id_recepcion`),
  ADD CONSTRAINT `recepcion_detalle_ibfk_2` FOREIGN KEY (`id_material`) REFERENCES `materiales` (`id_material`);

--
-- Filtros para la tabla `usuarios3`
--
ALTER TABLE `usuarios3`
  ADD CONSTRAINT `usuarios3_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_presupuesto`) REFERENCES `presupuestos` (`id_presupuesto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
