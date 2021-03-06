-- phpMyAdmin SQL Dump
-- version 4.8.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2019 at 11:20 AM
-- Server version: 10.1.31-MariaDB
-- PHP Version: 7.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `assis`
--

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`id`, `name`, `email`, `password`, `phone`, `active`) VALUES
(1, 'Ahmed Sherif', 'ahmedsaeed.fcih@gmail.com', '81dc9bdb52d04dc20036dbd8313ed055', '01114236554', 1);

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

CREATE TABLE `company` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `db_server` varchar(100) NOT NULL,
  `db_name` varchar(50) NOT NULL,
  `db_username` varchar(50) NOT NULL,
  `db_password` varchar(75) NOT NULL,
  `db_driver` varchar(50) NOT NULL,
  `platform_id` int(11) NOT NULL,
  `domain` varchar(100) NOT NULL,
  `type_id` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `support` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `bot_name` varchar(255) NOT NULL,
  `db_verified` int(11) NOT NULL DEFAULT '0',
  `first_train` int(11) NOT NULL DEFAULT '0',
  `current_story_id` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`id`, `client_id`, `name`, `description`, `db_server`, `db_name`, `db_username`, `db_password`, `db_driver`, `platform_id`, `domain`, `type_id`, `status`, `support`, `token`, `bot_name`, `db_verified`, `first_train`, `current_story_id`, `active`) VALUES
(1, 1, 'Optimal Solutions', '', 'localhost', 'test', 'root', '', 'mysqli', 5, 'localhost', 1, 'pending', 1, '$2y$10$McAvpJsUXTRQddeICxLeJ.PzALgMV.QBrIOfHhvMAJAbz./Ej9eHu', 'Optimal_1', 1, 1, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `payment_det`
--

CREATE TABLE `payment_det` (
  `id` int(11) NOT NULL,
  `indicator` varchar(50) NOT NULL,
  `subscription_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `payment_det`
--

INSERT INTO `payment_det` (`id`, `indicator`, `subscription_id`) VALUES
(1, '27602c473028402f', 1);

-- --------------------------------------------------------

--
-- Table structure for table `platform`
--

CREATE TABLE `platform` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `platform`
--

INSERT INTO `platform` (`id`, `name`, `active`) VALUES
(1, 'wordpress', 1),
(2, 'joomla', 1),
(3, 'oscommerce', 1),
(4, 'shopify', 1),
(5, 'native', 1);

-- --------------------------------------------------------

--
-- Table structure for table `price_packg`
--

CREATE TABLE `price_packg` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `num_days` int(11) NOT NULL,
  `price` float NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `scenarios`
--

CREATE TABLE `scenarios` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `companyId` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scenarios`
--

INSERT INTO `scenarios` (`id`, `name`, `companyId`, `active`) VALUES
(1, 'Test', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `subscriptions`
--

CREATE TABLE `subscriptions` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `from_date` varchar(50) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `payment_status` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subscriptions`
--

INSERT INTO `subscriptions` (`id`, `client_id`, `package_id`, `from_date`, `payment_id`, `payment_status`, `status`, `active`) VALUES
(1, 1, 1, '07/18/2019', 0, 'pending', 'pending', 1),
(2, 3, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(3, 4, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(4, 5, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(5, 6, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(6, 7, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(7, 8, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(8, 9, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(9, 10, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(10, 11, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(11, 1, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(12, 1, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(13, 2, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(14, 3, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(15, 4, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(16, 5, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(17, 1, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(18, 1, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(19, 2, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(20, 1, 1, '08/02/2019', 0, 'pending', 'pending', 1),
(21, 1, 1, '08/03/2019', 0, 'pending', 'pending', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `role` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `job` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `brief` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `facebook` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `name`, `job`, `brief`, `email`, `facebook`, `active`) VALUES
(1, 'sheko00o', '81dc9bdb52d04dc20036dbd8313ed055', 1, 'Ahmed Sherif', 'System Developer', 'I\'m a developer', 'ahmed.sherif.fcih@gmail.com', 'https://www.facebook.com/Ahmed.Sherif.998', 1);

-- --------------------------------------------------------

--
-- Table structure for table `website_type`
--

CREATE TABLE `website_type` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `website_type`
--

INSERT INTO `website_type` (`id`, `name`, `active`) VALUES
(1, 'E-Commerce', 1),
(2, 'Informaitve', 1),
(3, 'Service Based', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `payment_det`
--
ALTER TABLE `payment_det`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `platform`
--
ALTER TABLE `platform`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `price_packg`
--
ALTER TABLE `price_packg`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `scenarios`
--
ALTER TABLE `scenarios`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscriptions`
--
ALTER TABLE `subscriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `website_type`
--
ALTER TABLE `website_type`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payment_det`
--
ALTER TABLE `payment_det`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `platform`
--
ALTER TABLE `platform`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `price_packg`
--
ALTER TABLE `price_packg`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `scenarios`
--
ALTER TABLE `scenarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subscriptions`
--
ALTER TABLE `subscriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `website_type`
--
ALTER TABLE `website_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
