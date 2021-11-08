-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 08, 2021 at 12:44 PM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbaps`
--

-- --------------------------------------------------------

--
-- Table structure for table `tblaccuracy`
--

CREATE TABLE `tblaccuracy` (
  `id` int(11) NOT NULL,
  `algoritma` varchar(15) DEFAULT NULL,
  `testing` int(11) DEFAULT NULL,
  `total_data_training` int(11) DEFAULT NULL,
  `total_data` int(11) DEFAULT NULL,
  `tp` int(11) DEFAULT NULL,
  `tn` int(11) DEFAULT NULL,
  `fp` int(11) DEFAULT NULL,
  `fn` int(11) DEFAULT NULL,
  `tnull` int(11) DEFAULT NULL,
  `fnull` int(11) DEFAULT NULL,
  `accuracy` float(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tblaccuracy`
--

INSERT INTO `tblaccuracy` (`id`, `algoritma`, `testing`, `total_data_training`, `total_data`, `tp`, `tn`, `fp`, `fn`, `tnull`, `fnull`, `accuracy`) VALUES
(1, 'Bayesian', 1, 116537, 12949, 4992, 6485, 756, 716, 0, 0, 88.63),
(2, 'Bayesian', 2, 97115, 32371, 12438, 16376, 1822, 1735, 0, 0, 89.01),
(3, 'Bayesian', 3, 64743, 64743, 24728, 33007, 3565, 3443, 0, 0, 89.18),
(4, 'Bayesian', 4, 32372, 97114, 37089, 49558, 5427, 5039, 1, 0, 89.22),
(5, 'Bayesian', 5, 12949, 116537, 44629, 59488, 6444, 5965, 1, 10, 89.34),
(6, 'LVQ', 1, 116538, 12949, 0, 7241, 0, 5708, 0, 0, 55.92),
(7, 'LVQ', 2, 97116, 32371, 0, 18198, 0, 14173, 0, 0, 56.22),
(8, 'LVQ', 3, 64744, 64743, 0, 36572, 0, 28171, 0, 0, 56.49),
(9, 'LVQ', 4, 32373, 97114, 0, 54985, 0, 42129, 0, 0, 56.62),
(10, 'LVQ', 5, 12950, 116537, 0, 65942, 0, 50595, 0, 0, 56.58),
(11, 'LVQ', 1, 116538, 12949, 0, 7241, 0, 5708, 0, 0, 55.92),
(12, 'LVQ', 2, 97116, 32371, 0, 18198, 0, 14173, 0, 0, 56.22),
(13, 'LVQ', 3, 64744, 64743, 0, 36572, 0, 28171, 0, 0, 56.49),
(14, 'LVQ', 4, 32373, 97114, 0, 54985, 0, 42129, 0, 0, 56.62),
(15, 'LVQ', 5, 12950, 116537, 0, 65942, 0, 50595, 0, 0, 56.58),
(16, 'LVQ', 1, 116538, 12949, 0, 7241, 0, 5708, 0, 0, 55.92),
(17, 'LVQ', 2, 97116, 32371, 0, 18198, 0, 14173, 0, 0, 56.22),
(18, 'LVQ', 3, 64744, 64743, 0, 36572, 0, 28171, 0, 0, 56.49),
(19, 'LVQ', 4, 32373, 97114, 0, 54985, 0, 42129, 0, 0, 56.62),
(20, 'LVQ', 5, 12950, 116537, 0, 65942, 0, 50595, 0, 0, 56.58),
(21, 'LVQ', 1, 116538, 12949, 3882, 6466, 775, 1826, 0, 0, 79.91),
(22, 'LVQ', 2, 97116, 32371, 10757, 15039, 3159, 3416, 0, 0, 79.69),
(23, 'LVQ', 3, 64744, 64743, 21559, 29950, 6622, 6612, 0, 0, 79.56),
(24, 'LVQ', 4, 32373, 97114, 33996, 41892, 13093, 8133, 0, 0, 78.14),
(25, 'LVQ', 5, 12950, 116537, 40438, 51712, 14230, 10157, 0, 0, 79.07),
(26, 'LVQ', 1, 116538, 12949, 3882, 6466, 775, 1826, 0, 0, 79.91),
(27, 'LVQ', 2, 97116, 32371, 10757, 15039, 3159, 3416, 0, 0, 79.69),
(28, 'LVQ', 3, 64744, 64743, 21559, 29950, 6622, 6612, 0, 0, 79.56),
(29, 'LVQ', 4, 32373, 97114, 33996, 41892, 13093, 8133, 0, 0, 78.14),
(30, 'LVQ', 5, 12950, 116537, 40438, 51712, 14230, 10157, 0, 0, 79.07),
(31, 'LVQ', 1, 116538, 12949, 3882, 6466, 775, 1826, 0, 0, 79.91),
(32, 'LVQ', 2, 97116, 32371, 10757, 15039, 3159, 3416, 0, 0, 79.69),
(33, 'LVQ', 3, 64744, 64743, 21559, 29950, 6622, 6612, 0, 0, 79.56),
(34, 'LVQ', 4, 32373, 97114, 33900, 41980, 13005, 8229, 0, 0, 78.13),
(35, 'LVQ', 5, 12950, 116537, 40438, 51711, 14231, 10157, 0, 0, 79.07),
(36, 'LVQ', 1, 116538, 12949, 4081, 6291, 950, 1627, 0, 0, 80.10),
(37, 'LVQ', 2, 97116, 32371, 10772, 15002, 3196, 3401, 0, 0, 79.62),
(38, 'LVQ', 3, 64744, 64743, 21665, 29642, 6930, 6506, 0, 0, 79.25),
(39, 'LVQ', 4, 32373, 97114, 33600, 42911, 12074, 8529, 0, 0, 78.78),
(40, 'LVQ', 5, 12950, 116537, 40085, 51601, 14341, 10510, 0, 0, 78.68);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tblaccuracy`
--
ALTER TABLE `tblaccuracy`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tblaccuracy`
--
ALTER TABLE `tblaccuracy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
