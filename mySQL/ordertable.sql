-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 11, 2023 at 08:18 AM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rabbitfood`
--

-- --------------------------------------------------------

--
-- Table structure for table `ordertable`
--

CREATE TABLE `ordertable` (
  `id` int(11) NOT NULL,
  `OrderDateTime` text NOT NULL,
  `idUser` text NOT NULL,
  `NameUser` text NOT NULL,
  `idShop` text NOT NULL,
  `NameShop` text NOT NULL,
  `Distance` text NOT NULL,
  `Transport` text NOT NULL,
  `idFood` text NOT NULL,
  `NameFood` text NOT NULL,
  `Price` text NOT NULL,
  `Amount` text NOT NULL,
  `Sum` text NOT NULL,
  `idRider` text NOT NULL,
  `Status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `ordertable`
--

INSERT INTO `ordertable` (`id`, `OrderDateTime`, `idUser`, `NameUser`, `idShop`, `NameShop`, `Distance`, `Transport`, `idFood`, `NameFood`, `Price`, `Amount`, `Sum`, `idRider`, `Status`) VALUES
(2, '2022-12-25 19:25', '2', 'usertest', '10', 'rabbitfood', '12807.97', '128105', '[5, 6, 7]', '[ส้มตำแซ่บๆ, ข้าวผัดกุ้ง, ไข่เจียว]', '[50, 80, 40]', '[2, 2, 1]', '[100, 160, 40]', 'none', 'UserOrder'),
(3, '2022-12-25 19:27', '2', 'usertest', '12', 'ร้านเจ๊แดงซอย 8', '12808.54', '128115', '[15]', '[กระเพราหมู]', '[40]', '[2]', '[80]', 'none', 'UserOrder'),
(4, '2023-01-05 23:04', '9', 'dee', '10', 'rabbitfood', '12807.97', '128100', '[5, 7]', '[ส้มตำแซ่บๆ, ไข่เจียว]', '[50, 40]', '[2, 2]', '[100, 80]', 'none', 'UserOrder'),
(5, '2023-01-06 12:34', '14', 'sutest', '10', 'rabbitfood', '12807.97', '128100', '[5, 6]', '[ส้มตำแซ่บๆ, ข้าวผัดกุ้ง]', '[50, 80]', '[1, 2]', '[50, 160]', 'none', 'UserOrder');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ordertable`
--
ALTER TABLE `ordertable`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ordertable`
--
ALTER TABLE `ordertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
