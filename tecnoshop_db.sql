-- Base de datos TecnoShop (Versión Corregida y Alineada con MVC)
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS `tecnoshop_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `tecnoshop_db`;

-- --------------------------------------------------------
-- Tabla: usuarios (Autenticación del sistema web)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `detalle_ventas`;
DROP TABLE IF EXISTS `ventas`;
DROP TABLE IF EXISTS `productos`;
DROP TABLE IF EXISTS `categorias`;
DROP TABLE IF EXISTS `clientes`;
DROP TABLE IF EXISTS `usuarios`;

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','vendedor') DEFAULT 'vendedor',
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Usuario administrador por defecto (clave: password)
INSERT INTO `usuarios` (`id`, `nombre`, `email`, `password`, `rol`, `estado`) VALUES
(1, 'Administrador TecnoShop', 'admin@tecnoshop.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'activo');

-- --------------------------------------------------------
-- Tabla: categorias
-- --------------------------------------------------------
CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Celulares', 'Smartphones y teléfonos móviles de todas las marcas'),
(2, 'Computadores', 'Laptops, desktops y equipos todo en uno'),
(3, 'Accesorios', 'Cables, cargadores, fundas y power banks'),
(4, 'Periféricos', 'Teclados, mouse, monitores y audífonos');

-- --------------------------------------------------------
-- Tabla: clientes
-- --------------------------------------------------------
CREATE TABLE `clientes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(120) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `documento` (`documento`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `clientes` (`id`, `nombre`, `apellido`, `documento`, `telefono`, `email`, `direccion`, `estado`) VALUES
(1, 'Ana Sofía', 'Gómez', '1098765432', '3001234567', 'ana@correo.com', 'Calle 45 # 12-30, Bogotá', 'activo'),
(2, 'Carlos Andrés', 'Ruiz', '1023456789', '3209876543', 'carlos@correo.com', 'Carrera 15 # 80-10, Medellín', 'activo'),
(3, 'Laura Camila', 'Torres', '1054789632', '3114567890', 'laura@correo.com', 'Av. Siempre Viva 742, Cali', 'activo');

-- --------------------------------------------------------
-- Tabla: productos
-- --------------------------------------------------------
CREATE TABLE `productos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `precio` decimal(12,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `marca` varchar(80) DEFAULT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `categoria_id` (`categoria_id`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `categoria_id`, `precio`, `stock`, `marca`, `estado`) VALUES
(1, 'Samsung Galaxy A55', 'Pantalla Super AMOLED 6.6 pulgadas, 256GB, cámara triple 50MP', 1, 1499000.00, 12, 'Samsung', 'activo'),
(2, 'iPhone 15', 'Chip A16 Bionic, cámara avanzada 48MP, 128GB', 1, 3899000.00, 4, 'Apple', 'activo'),
(3, 'Laptop Lenovo IdeaPad 3', 'Intel Core i5 13va Gen, 16GB RAM, SSD 512GB NVMe', 2, 2450000.00, 8, 'Lenovo', 'activo'),
(4, 'MacBook Air M2', 'Chip Apple M2, 8GB RAM, SSD 256GB, pantalla Liquid Retina', 2, 4990000.00, 3, 'Apple', 'activo'),
(5, 'Cable USB-C 2m 65W', 'Carga rápida 65W, trenzado en nylon de alta resistencia', 3, 35000.00, 45, 'UGREEN', 'activo'),
(6, 'Funda Silicona iPhone 15', 'Protección antigolpes con interior en microfibra suave', 3, 65000.00, 25, 'Spigen', 'activo'),
(7, 'Mouse Logitech MX Master 3S', 'Inalámbrico ergonómico, sensor 8K DPI, silencioso', 4, 420000.00, 10, 'Logitech', 'activo'),
(8, 'Audífonos Sony WH-1000XM5', 'Cancelación activa de ruido líder, 30h de batería', 4, 1190000.00, 6, 'Sony', 'activo');

-- --------------------------------------------------------
-- Tabla: ventas
-- --------------------------------------------------------
CREATE TABLE `ventas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `total` decimal(14,2) NOT NULL DEFAULT 0.00,
  `estado` enum('pendiente','completada','cancelada') DEFAULT 'completada',
  `observacion` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_cliente` (`id_cliente`),
  CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------
-- Tabla: detalle_ventas
-- --------------------------------------------------------
CREATE TABLE `detalle_ventas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_venta` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unit` decimal(12,2) NOT NULL,
  `subtotal` decimal(14,2) GENERATED ALWAYS AS (`cantidad` * `precio_unit`) STORED,
  PRIMARY KEY (`id`),
  KEY `id_venta` (`id_venta`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_ventas_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `detalle_ventas_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Datos iniciales de ventas para que el Dashboard, Gráficas e IA muestren información real
INSERT INTO `ventas` (`id`, `id_cliente`, `fecha`, `total`, `estado`, `observacion`) VALUES
(1, 1, DATE_SUB(NOW(), INTERVAL 25 DAY), 3964000.00, 'completada', 'Compra de equipo principal y funda'),
(2, 2, DATE_SUB(NOW(), INTERVAL 10 DAY), 2870000.00, 'completada', 'Equipo de trabajo completo'),
(3, 1, DATE_SUB(NOW(), INTERVAL 2 DAY), 1225000.00, 'completada', 'Accesorios de audio y carga');

INSERT INTO `detalle_ventas` (`id_venta`, `id_producto`, `cantidad`, `precio_unit`) VALUES
(1, 2, 1, 3899000.00),
(1, 6, 1, 65000.00),
(2, 3, 1, 2450000.00),
(2, 7, 1, 420000.00),
(3, 8, 1, 1190000.00),
(3, 5, 1, 35000.00);

COMMIT;
