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
-- Table structure for table `foodtable`
--

CREATE TABLE `foodtable` (
  `id` int(11) NOT NULL,
  `idShop` text NOT NULL,
  `NameFood` text NOT NULL,
  `PathImage` text NOT NULL,
  `Price` text NOT NULL,
  `Detail` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `foodtable`
--

INSERT INTO `foodtable` (`id`, `idShop`, `NameFood`, `PathImage`, `Price`, `Detail`) VALUES
(5, '10', 'ส้มตำแซ่บๆ', '/rabbitfood/Food/foodimage242644.jpg', '50', 'ส้มตำรสเด็ด'),
(6, '10', 'ข้าวผัดกุ้ง', '/rabbitfood/Food/foodimage347458.jpg', '80', 'กุ้งตัวโตๆ'),
(7, '10', 'ไข่เจียว', '/rabbitfood/Food/foodimage965717.jpg', '40', 'ไข่ฟูๆ'),
(8, '10', 'แกงจืดเต้าหู้ไข่', '/rabbitfood/Food/foodimage748067.jpg', '80', 'แกงจืดหอมๆ'),
(9, '10', 'ปลาหมึกยัดไส้', '/rabbitfood/Food/foodimage353517.jpg', '180', 'ปลาหมึกตัวโตๆยัดไส้แน่นๆ'),
(11, '10', 'คอหมูย่าง', '/rabbitfood/Food/foodimage716031.jpg', '160', 'เนื้อหมูหมักหนุ่มๆ'),
(15, '12', 'กระเพราหมู', '/rabbitfood/Food/foodimage424912.jpg', '40', 'หมูค้างคืนอร่อยค้างโรงพยาบาล');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `foodtable`
--
ALTER TABLE `foodtable`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `foodtable`
--
ALTER TABLE `foodtable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
