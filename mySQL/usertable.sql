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
-- Table structure for table `usertable`
--

CREATE TABLE `usertable` (
  `id` int(11) NOT NULL,
  `ChooseType` text NOT NULL,
  `Name` text NOT NULL,
  `User` text NOT NULL,
  `Password` text NOT NULL,
  `NameShop` text NOT NULL,
  `Address` text NOT NULL,
  `Phone` text NOT NULL,
  `UrlPicture` text NOT NULL,
  `Lat` text NOT NULL,
  `Lng` text NOT NULL,
  `Token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `usertable`
--

INSERT INTO `usertable` (`id`, `ChooseType`, `Name`, `User`, `Password`, `NameShop`, `Address`, `Phone`, `UrlPicture`, `Lat`, `Lng`, `Token`) VALUES
(2, 'User', 'usertest', 'usertest', '12345', '', '', '', '', '', '', ''),
(3, 'Shop', 'shoptest', 'shoptest', '12345', '', '', '', '', '', '', ''),
(4, 'Rider', 'ridertest', 'ridertest', '12345', '', '', '', '', '', '', ''),
(9, 'User', 'dee', 'dek', '123456', '', '', '', '', '', '', ''),
(10, 'Shop', 'shoptwo', 'shoptwo', '123456', 'rabbitfood', '60 หมู่3 ต แหลมบัว อ นครชัยศรี จ นครปฐม 73120', '022455855', '/rabbitfood/Shop/shopimage806783.jpg', '13.843267937630888', '100.14997356713364', ''),
(11, 'Shop', 'rabbitshop', 'rabbitshop', '123456', '', '', '', '', '', '', ''),
(12, 'Shop', 'ร้านเจ๊แดง', 'testshop2', '123456', 'ร้านเจ๊แดงซอย 8', '88/8 ซอย 8 หมู่ 8', '0880808888', '/rabbitfood/Shop/shopimage579277.jpg', '13.841368856995288', '100.14359549324962', ''),
(13, 'User', 'rabbitfood', 'rabbittest', '123456', '', '', '', '', '', '', ''),
(14, 'User', 'sutest', 'sutest01', '123456', '', '', '', '', '', '', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `usertable`
--
ALTER TABLE `usertable`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `usertable`
--
ALTER TABLE `usertable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
