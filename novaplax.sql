-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-07-2025 a las 17:18:03
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
-- Base de datos: `novaplax`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulo`
--

CREATE TABLE `articulo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `categoria_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `articulo`
--

INSERT INTO `articulo` (`id`, `nombre`, `descripcion`, `precio`, `stock`, `categoria_id`) VALUES
(1, 'Closet 3 puertas', 'Closet de melamina blanco, con cajones interiores y tiradores metálicos.', 950.00, 9, 1),
(2, 'Cómoda 5 cajones', 'Cómoda de melamina color nogal, con correderas metálicas.', 420.00, 0, 1),
(3, 'Repostero alto', 'Mueble alto para cocina, color blanco, tiradores de acero.', 680.00, 3, 2),
(4, 'Mesa de centro', 'Mesa de centro para sala, diseño minimalista, color roble.', 320.00, 7, 4),
(5, 'Escritorio ejecutivo', 'Escritorio de melamina gris, con cajonera lateral y amplia superficie.', 750.00, 7, 3),
(6, 'Rack para TV', 'Rack para televisor de hasta 60 pulgadas, con compartimentos.', 400.00, 8, 4),
(7, 'Biblioteca modular', 'Biblioteca en melamina blanca, modular, de 5 niveles.', 560.00, 1, 3),
(8, 'Alacena baja', 'Mueble bajo para cocina, dos puertas, color wengue.', 370.00, 8, 2),
(9, 'Mesa comedor 6 personas', 'Mesa rectangular para comedor, melamina color cedro.', 890.00, 3, 5),
(10, 'Velador sencillo', 'Velador pequeño de melamina color tabaco, con cajón.', 150.00, 20, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id`, `nombre`) VALUES
(1, 'Dormitorio'),
(2, 'Cocina'),
(3, 'Oficina'),
(4, 'Sala'),
(5, 'Comedor'),
(6, 'Baño'),
(7, 'Almacenamiento'),
(8, 'Infantil');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `dni` varchar(15) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id`, `dni`, `nombre`, `apellido`, `telefono`, `email`) VALUES
(1, '12345678', 'Axel', 'Santander', '987654321', 'axelsantander511@gmail.com'),
(2, '87654321', 'María', 'García', '912345678', 'maria.garcia@correo.com'),
(3, '23456789', 'Luis', 'Ramírez', '956789123', 'luis.ramirez@correo.com'),
(4, '34567890', 'Ana', 'Torres', '998877665', 'ana.torres@correo.com'),
(5, '45678901', 'Pedro', 'Sánchez', '911122233', 'pedro.sanchez@correo.com'),
(6, '56789012', 'Lucía', 'Fernández', '933344455', 'lucia.fernandez@correo.com'),
(7, '67890123', 'Carlos', 'Díaz', '922233344', 'carlos.diaz@correo.com'),
(8, '78901234', 'Sofía', 'Morales', '944556677', 'sofia.morales@correo.com'),
(9, '89012345', 'Jorge', 'Herrera', '955667788', 'jorge.herrera@correo.com'),
(10, '90123456', 'Elena', 'Castro', '977889900', 'elena.castro@correo.com');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket`
--

CREATE TABLE `ticket` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ticket`
--

INSERT INTO `ticket` (`id`, `usuario_id`, `cliente_id`, `fecha`, `total`) VALUES
(2, 1, 5, '2025-07-11 21:40:32', 4600.00),
(3, 1, 6, '2025-07-11 21:41:35', 2780.00),
(4, 1, 2, '2025-07-11 21:43:50', 680.00),
(5, 1, 3, '2025-07-11 21:44:51', 2960.00),
(6, 1, 8, '2025-07-11 21:49:50', 680.00),
(7, 4, 5, '2025-07-13 10:13:16', 2390.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticket_detalle`
--

CREATE TABLE `ticket_detalle` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `articulo_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ticket_detalle`
--

INSERT INTO `ticket_detalle` (`id`, `ticket_id`, `articulo_id`, `cantidad`, `precio_unitario`) VALUES
(4, 2, 2, 10, 420.00),
(5, 2, 6, 1, 400.00),
(6, 3, 3, 3, 680.00),
(7, 3, 8, 2, 370.00),
(8, 4, 3, 1, 680.00),
(9, 5, 4, 4, 320.00),
(10, 5, 7, 3, 560.00),
(11, 6, 3, 1, 680.00),
(12, 7, 1, 1, 950.00),
(13, 7, 7, 2, 560.00),
(14, 7, 4, 1, 320.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `rol` enum('admin','vendedor') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `usuario`, `contrasena`, `rol`) VALUES
(1, 'axel', 'admin', 'admin'),
(2, 'vendedor1', '1234', 'vendedor'),
(3, 'vendedor2', '5678', 'vendedor'),
(4, 'prueba', '1234', 'vendedor');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulo`
--
ALTER TABLE `articulo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoria_id` (`categoria_id`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `cliente_id` (`cliente_id`);

--
-- Indices de la tabla `ticket_detalle`
--
ALTER TABLE `ticket_detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ticket_id` (`ticket_id`),
  ADD KEY `articulo_id` (`articulo_id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `articulo`
--
ALTER TABLE `articulo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `ticket`
--
ALTER TABLE `ticket`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `ticket_detalle`
--
ALTER TABLE `ticket_detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `articulo`
--
ALTER TABLE `articulo`
  ADD CONSTRAINT `articulo_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuario` (`id`),
  ADD CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ticket_detalle`
--
ALTER TABLE `ticket_detalle`
  ADD CONSTRAINT `ticket_detalle_ibfk_1` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ticket_detalle_ibfk_2` FOREIGN KEY (`articulo_id`) REFERENCES `articulo` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
