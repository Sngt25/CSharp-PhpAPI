-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 11, 2024 at 04:11 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommercedb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderShippingStatus` (IN `order_id` INT, IN `new_shipping_status_id` INT)   BEGIN
    -- Update the shipping status for the specified order
    UPDATE _order as o
    SET status_id = new_shipping_status_id
    WHERE o.order_id = order_id;

    -- Check if any rows were affected by the update
    IF ROW_COUNT() > 0 THEN
        SELECT 'Shipping status updated successfully.' as success;
    ELSE
        SELECT 'Order not found or no changes were made to shipping status.' as failed;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderTotalAmount` ()   BEGIN
    DECLARE order_id_cursor INT;
    DECLARE done BOOLEAN DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR
        SELECT order_id FROM _order WHERE order_id BETWEEN 1 AND 10;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    order_loop: LOOP
        FETCH cur INTO order_id_cursor;
        IF done THEN
            LEAVE order_loop;
        END IF;
        
        -- Call your existing function to compute total amount
        -- Use IFNULL to handle null values returned by the function
        UPDATE _order
        SET total_amount = IFNULL(TotalOrder(order_id_cursor), 0)
        WHERE order_id = order_id_cursor;
    END LOOP;

    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUnitPrice` ()   BEGIN
    CREATE TEMPORARY TABLE temp_orderitem AS 
        SELECT oi.order_item_id, p.price
        FROM orderitem oi
        JOIN product p ON oi.product_id = p.product_id;

    UPDATE orderitem oi
    JOIN temp_orderitem temp ON oi.order_item_id = temp.order_item_id
    SET oi.unit_price = temp.price;

    DROP TEMPORARY TABLE IF EXISTS temp_orderitem;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserStatus` ()   BEGIN
    DECLARE user_id_var INT;
    DECLARE last_login_var TIMESTAMP;
    DECLARE status_var BOOLEAN;

    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT user_id, last_login FROM _user;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO user_id_var, last_login_var;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF last_login_var < DATE_SUB(NOW(), INTERVAL 1 MONTH) THEN
            SET status_var = FALSE;
        ELSE
            SET status_var = TRUE;
        END IF;

        UPDATE _user SET status = status_var WHERE user_id = user_id_var;
    END LOOP;
    CLOSE cur;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_usernames` ()   BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE new_username VARCHAR(255);
    DECLARE existing_count INT;
    DECLARE user_id_cursor INT;
    DECLARE rand_string VARCHAR(5);

    -- Declare cursor for selecting user_id from `_user`
    DECLARE cur CURSOR FOR SELECT `user_id` FROM `_user` FOR UPDATE;

    -- Declare handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Start an implicit transaction
    BEGIN

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO user_id_cursor;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Generating random string of length 5
        SET rand_string = LPAD(FLOOR(RAND() * 100000), 5, '0');

        SET new_username = CONCAT('user', rand_string);

        -- Checking if the generated username already exists
        SELECT COUNT(*) INTO existing_count FROM `_user` WHERE `username` = new_username;

        IF existing_count = 0 THEN
            UPDATE `_user` SET `username` = new_username WHERE `user_id` = user_id_cursor;
        ELSE
            -- Regenerate new username if it already exists
            REPEAT
                SET rand_string = LPAD(FLOOR(RAND() * 100000), 5, '0');
                SET new_username = CONCAT('user', rand_string);
                SELECT COUNT(*) INTO existing_count FROM `_user` WHERE `username` = new_username;
            UNTIL existing_count = 0 END REPEAT;
            UPDATE `_user` SET `username` = new_username WHERE `user_id` = user_id_cursor;
        END IF;
    END LOOP;

    CLOSE cur;

    -- End the implicit transaction
    END;

END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `TotalOrder` (`order_id` INT) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE total_price DECIMAL(10, 2);
    
    -- Calculate total price by summing the prices of all items in the order
    SELECT SUM(oi.quantity * oi.unit_price) INTO total_price
    FROM orderitem oi
    WHERE oi.order_id = order_id;
    
    RETURN total_price;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`, `description`) VALUES
(1, 'Electronics', 'Electronic gadgets and accessories'),
(2, 'Home and Garden', 'Products for home and outdoor living'),
(3, 'Fashion', 'Trendy clothing and accessories'),
(4, 'Toys and Games', 'Entertaining toys and exciting games'),
(5, 'Sports and Outdoors', 'Outdoor and sports equipment'),
(6, 'Books', 'A wide range of books for all ages'),
(7, 'Health and Beauty', 'Healthcare and beauty products'),
(8, 'Automotive', 'Automobile accessories and parts'),
(9, 'Kitchen and Dining', 'Kitchenware and dining products'),
(10, 'Pet Supplies', 'Supplies for pets and pet lovers');

-- --------------------------------------------------------

--
-- Stand-in structure for view `categorysales`
-- (See below for the actual view)
--
CREATE TABLE `categorysales` (
`category_id` int(11)
,`category_name` varchar(255)
,`total_quantity_sold` decimal(32,0)
,`total_sales` decimal(42,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `orderdetails`
-- (See below for the actual view)
--
CREATE TABLE `orderdetails` (
`order_id` int(11)
,`order_date` datetime
,`user_id` int(11)
,`email` varchar(255)
,`product_id` int(11)
,`name` varchar(255)
,`quantity` int(11)
,`unit_price` decimal(10,2)
,`total_price` decimal(20,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `orderitem`
--

CREATE TABLE `orderitem` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orderitem`
--

INSERT INTO `orderitem` (`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(32, 2, 13, 1, 707.43),
(33, 3, 15, 3, 935.48),
(34, 1, 12, 2, 951.56),
(35, 5, 14, 1, 453.59),
(36, 6, 16, 2, 154.52),
(37, 7, 18, 1, 539.76),
(38, 8, 20, 3, 928.47),
(39, 9, 19, 1, 217.64),
(40, 10, 17, 2, 887.23),
(41, 10, 29, 3, 104.24),
(42, 9, 21, 5, 745.23),
(43, 1, 2, 1, 155.62),
(44, 1, 5, 1, 664.05);

--
-- Triggers `orderitem`
--
DELIMITER $$
CREATE TRIGGER `update_total_amount_after_delete` AFTER DELETE ON `orderitem` FOR EACH ROW BEGIN
    DECLARE order_total DECIMAL(10,2);
    SET order_total = TotalOrder(OLD.order_id);
    UPDATE _order SET total_amount = order_total WHERE order_id = OLD.order_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_total_amount_after_insert` AFTER INSERT ON `orderitem` FOR EACH ROW BEGIN
    DECLARE order_total DECIMAL(10,2);
    SET order_total = TotalOrder(NEW.order_id);
    UPDATE _order SET total_amount = order_total WHERE order_id = NEW.order_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_total_amount_after_update` AFTER UPDATE ON `orderitem` FOR EACH ROW BEGIN
    DECLARE order_total DECIMAL(10,2);
    SET order_total = TotalOrder(NEW.order_id);
    UPDATE _order SET total_amount = order_total WHERE order_id = NEW.order_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_unit_price_before_insert` BEFORE INSERT ON `orderitem` FOR EACH ROW BEGIN
    SET NEW.unit_price = (SELECT price FROM product WHERE product_id = NEW.product_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_status`
--

CREATE TABLE `order_status` (
  `status_id` int(11) NOT NULL,
  `status_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_status`
--

INSERT INTO `order_status` (`status_id`, `status_name`) VALUES
(1, 'Received'),
(2, 'Cancelled'),
(3, 'Completed'),
(4, 'Ready to Ship'),
(5, 'Shipped');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(1000) NOT NULL DEFAULT '',
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `quantity_in_stock` int(11) NOT NULL DEFAULT 0,
  `category_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `name`, `description`, `price`, `quantity_in_stock`, `category_id`) VALUES
(1, 'Cosmetic Product 63', 'Description of Cosmetic Product 11', 683.92, 7, 7),
(2, 'Car Part 85', 'Description of Car Part 14', 155.62, 34, 8),
(3, 'Car Part 24', 'Description of Car Part 5', 567.12, 65, 8),
(4, 'Garden Tool 58', 'Description of Garden Tool 76', 49.50, 95, 2),
(5, 'Toy 34', 'Description of Toy 53', 664.05, 70, 4),
(6, 'Kitchen Appliance 48', 'Description of Kitchen Appliance 15', 292.88, 1, 9),
(7, 'Cosmetic Product 12', 'Description of Cosmetic Product 34', 361.60, 75, 7),
(8, 'Pet Toy 69', 'Description of Pet Toy 15', 684.68, 95, 10),
(9, 'Garden Tool 23', 'Description of Garden Tool 84', 484.55, 90, 2),
(10, 'Book 17', 'Description of Book 52', 77.35, 82, 6),
(11, 'Car Part 58', 'Description of Car Part 46', 544.76, 33, 8),
(12, 'Kitchen Appliance 89', 'Description of Kitchen Appliance 92', 951.56, 96, 9),
(13, 'Dress 57', 'Description of Dress 28', 707.43, 67, 3),
(14, 'Kitchen Appliance 23', 'Description of Kitchen Appliance 43', 453.59, 96, 9),
(15, 'Toy 26', 'Description of Toy 54', 935.48, 4, 4),
(16, 'Dress 15', 'Description of Dress 92', 154.52, 0, 3),
(17, 'Smartphone 91', 'Description of Smartphone 72', 887.23, 25, 1),
(18, 'Smartphone 95', 'Description of Smartphone 88', 539.76, 4, 1),
(19, 'Cosmetic Product 36', 'Description of Cosmetic Product 86', 217.64, 50, 7),
(20, 'Toy 85', 'Description of Toy 10', 928.47, 34, 4),
(21, 'Car Part 12', 'Description of Car Part 42', 745.23, 45, 8),
(22, 'Smartphone 79', 'Description of Smartphone 70', 140.18, 59, 1),
(23, 'Garden Tool 22', 'Description of Garden Tool 81', 377.19, 44, 2),
(24, 'Outdoor Gear 83', 'Description of Outdoor Gear 82', 630.72, 67, 5),
(25, 'Outdoor Gear 28', 'Description of Outdoor Gear 5', 428.09, 96, 5),
(26, 'Kitchen Appliance 41', 'Description of Kitchen Appliance 69', 230.18, 6, 9),
(27, 'Garden Tool 79', 'Description of Garden Tool 55', 398.64, 32, 2),
(28, 'Outdoor Gear 27', 'Description of Outdoor Gear 84', 389.66, 41, 5),
(29, 'Toy 49', 'Description of Toy 91', 104.24, 76, 4),
(30, 'Garden Tool 90', 'Description of Garden Tool 93', 928.45, 85, 2),
(31, 'Outdoor Gear 83', 'Description of Outdoor Gear 53', 166.48, 22, 5),
(32, 'Dress 72', 'Description of Dress 0', 829.33, 13, 3),
(33, 'Car Part 0', 'Description of Car Part 22', 127.83, 95, 8),
(34, 'Pet Toy 56', 'Description of Pet Toy 0', 326.46, 61, 10),
(35, 'Smartphone 93', 'Description of Smartphone 84', 406.81, 50, 1),
(36, 'Smartphone 32', 'Description of Smartphone 75', 805.92, 76, 1),
(37, 'Kitchen Appliance 94', 'Description of Kitchen Appliance 82', 292.36, 99, 9),
(38, 'Pet Toy 30', 'Description of Pet Toy 64', 283.28, 49, 10),
(39, 'Dress 36', 'Description of Dress 87', 262.12, 70, 3),
(40, 'Book 55', 'Description of Book 84', 533.92, 14, 6),
(41, 'Cosmetic Product 28', 'Description of Cosmetic Product 27', 510.11, 73, 7),
(42, 'Dress 46', 'Description of Dress 20', 605.32, 41, 3),
(43, 'Book 56', 'Description of Book 64', 525.02, 69, 6),
(44, 'Pet Toy 79', 'Description of Pet Toy 79', 571.26, 47, 10),
(45, 'Book 88', 'Description of Book 79', 350.05, 35, 6),
(46, 'Cosmetic Product 86', 'Description of Cosmetic Product 68', 834.75, 12, 7),
(47, 'Book 39', 'Description of Book 30', 347.98, 81, 6),
(48, 'Outdoor Gear 27', 'Description of Outdoor Gear 64', 415.13, 0, 5),
(49, 'Toy 59', 'Description of Toy 19', 178.50, 31, 4),
(50, 'Pet Toy 5', 'Description of Pet Toy 31', 376.62, 95, 10),
(69, 'Harry Potter', 'Harry Potter book description', 1000.00, 1, 6),
(70, 'test', 'test', 12.00, 3, 6);

-- --------------------------------------------------------

--
-- Stand-in structure for view `productcatalog`
-- (See below for the actual view)
--
CREATE TABLE `productcatalog` (
`product_id` int(11)
,`name` varchar(255)
,`description` varchar(1000)
,`price` decimal(10,2)
,`quantity_in_stock` int(11)
,`category_name` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `user_types`
--

CREATE TABLE `user_types` (
  `user_type_id` int(11) NOT NULL,
  `user_type_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_types`
--

INSERT INTO `user_types` (`user_type_id`, `user_type_name`) VALUES
(1, 'admin'),
(2, 'customer');

-- --------------------------------------------------------

--
-- Table structure for table `_order`
--

CREATE TABLE `_order` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `_order`
--

INSERT INTO `_order` (`order_id`, `user_id`, `order_date`, `total_amount`, `status_id`) VALUES
(1, 1, '2024-01-31 08:00:00', 2722.79, 3),
(2, 2, '2024-01-31 09:30:00', 707.43, 1),
(3, 3, '2024-01-31 10:45:00', 2806.44, 3),
(4, 4, '2024-01-31 12:15:00', 0.00, 2),
(5, 5, '2024-01-31 14:00:00', 453.59, 1),
(6, 6, '2024-01-31 15:30:00', 309.04, 2),
(7, 7, '2024-01-31 17:00:00', 539.76, 3),
(8, 8, '2024-01-31 18:15:00', 2785.41, 2),
(9, 9, '2024-01-31 19:45:00', 3943.79, 1),
(10, 10, '2024-01-31 21:00:00', 2087.18, 3);

-- --------------------------------------------------------

--
-- Table structure for table `_user`
--

CREATE TABLE `_user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT current_timestamp(),
  `status` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `_user`
--

INSERT INTO `_user` (`user_id`, `username`, `email`, `password`, `address`, `user_type_id`, `created_at`, `last_login`, `status`) VALUES
(1, 'user45340', 'john.doe@example.com', '21345', '123 Main St, Cityville', 2, '2024-03-06 21:19:01', '2024-01-07 01:54:41', 0),
(2, 'user00718', 'jane.smith@example.com', '4323', '456 Oak St, Townsville', 2, '2024-03-06 21:19:01', '2024-02-01 01:54:41', 0),
(3, 'user67572', 'bob.johnson@example.com', '53423', '789 Pine St, Villagetown', 2, '2024-03-06 21:19:01', '2024-03-01 01:54:41', 1),
(4, 'user35704', 'alice.williams@example.com', '34432', '101 Maple St, Hamlet', 2, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(5, 'user75808', 'charlie.brown@example.com', '4312', '202 Birch St, Township', 2, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(6, 'user71929', 'eva.anderson@example.com', '345', '303 Cedar St, Borough', 2, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(7, 'user32218', 'david.martin@example.com', '34532', '404 Redwood St, District', 2, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(8, 'user45306', 'sara.moore@example.com', '5432', '505 Spruce St, Village', 2, '2024-03-06 21:19:01', '2024-02-01 01:54:41', 0),
(9, 'user29877', 'michael.white@example.com', '32454', '606 Elm St, Town', 2, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(10, 'user13467', 'olivia.taylor@example.com', '45432', '707 Fir St, City', 2, '2024-03-06 21:19:01', '2024-01-10 01:54:41', 0),
(11, 'admin1225', 'admin@gmail.com', 'admin2', 'Dimasalang, Masbate', 1, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(12, 'user9464', 'mark@gmail.com', '34534', 'hgfd', NULL, '2024-03-06 21:19:01', '2024-03-06 01:54:41', 1),
(13, 'user623423', 'jay@gmail.cmo', '43534', 'hgfd', NULL, '2024-03-06 21:21:42', '2024-03-06 01:54:41', 1),
(14, 'user426534', 'hie@gmail.com', '2362', 'test', 2, '2024-03-06 21:25:58', '2024-03-06 01:54:41', 1),
(15, 'user13425', 'yes@gmail.com', '2345', 'test', 2, '2024-03-06 21:28:16', '2024-03-06 21:28:16', 1),
(17, 'user14235', 'kal@gmail.com', '234646', 'fgdfg', 2, '2024-03-06 21:41:01', '2024-03-06 21:41:01', 1),
(18, 'user235235', 'hi@gmail.com', '34536', 'USA', 2, '2024-03-08 11:38:57', '2024-03-08 11:38:57', 1),
(19, 'user6345', 'leah@gmail.com', NULL, 'australia', 2, '2024-03-08 11:49:15', '2024-03-08 11:49:15', 1),
(20, 'user5234', 'kim@gmail.com', NULL, 'PH', 2, '2024-03-08 11:50:06', '2024-03-08 11:50:06', 1),
(21, 'tes213', 'tes@gmail.com', NULL, 'tes philippines', 2, '2024-03-08 12:12:18', '2024-03-08 12:12:18', 1),
(22, 'jeddy1225', 'jeddycertifico25@gmail.com', NULL, 'Dimasalang, Masbate', 2, '2024-03-08 12:29:44', '2024-03-08 12:29:44', 1),
(26, 'jeddysample', 'jeddysample@gmail.com', NULL, 'dimasalang masbate', NULL, '2024-05-28 15:16:30', '2024-05-28 15:16:30', 1),
(27, 'Sngt', 'jeddycertifico@gmail.com', NULL, 'Dimasalang, Masbate', NULL, '2024-05-30 15:23:01', '2024-05-30 15:23:01', 1);

--
-- Triggers `_user`
--
DELIMITER $$
CREATE TRIGGER `update_status_before_insert` BEFORE INSERT ON `_user` FOR EACH ROW BEGIN
    DECLARE status BOOLEAN;

    IF NEW.last_login < DATE_SUB(NOW(), INTERVAL 1 MONTH) THEN
        SET NEW.status = FALSE;
    ELSE
        SET NEW.status = TRUE;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure for view `categorysales`
--
DROP TABLE IF EXISTS `categorysales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `categorysales`  AS SELECT `c`.`category_id` AS `category_id`, `c`.`category_name` AS `category_name`, sum(`oi`.`quantity`) AS `total_quantity_sold`, sum(`oi`.`quantity` * `oi`.`unit_price`) AS `total_sales` FROM ((`category` `c` join `product` `p` on(`c`.`category_id` = `p`.`category_id`)) join `orderitem` `oi` on(`p`.`product_id` = `oi`.`product_id`)) GROUP BY `c`.`category_id`, `c`.`category_name` ;

-- --------------------------------------------------------

--
-- Structure for view `orderdetails`
--
DROP TABLE IF EXISTS `orderdetails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `orderdetails`  AS SELECT `o`.`order_id` AS `order_id`, `o`.`order_date` AS `order_date`, `c`.`user_id` AS `user_id`, `c`.`email` AS `email`, `oi`.`product_id` AS `product_id`, `p`.`name` AS `name`, `oi`.`quantity` AS `quantity`, `oi`.`unit_price` AS `unit_price`, `oi`.`quantity`* `oi`.`unit_price` AS `total_price` FROM (((`_order` `o` join `_user` `c` on(`o`.`user_id` = `c`.`user_id`)) join `orderitem` `oi` on(`o`.`order_id` = `oi`.`order_id`)) join `product` `p` on(`oi`.`product_id` = `p`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `productcatalog`
--
DROP TABLE IF EXISTS `productcatalog`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `productcatalog`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`name` AS `name`, `p`.`description` AS `description`, `p`.`price` AS `price`, `p`.`quantity_in_stock` AS `quantity_in_stock`, `c`.`category_name` AS `category_name` FROM (`product` `p` join `category` `c` on(`p`.`category_id` = `c`.`category_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `orderitem`
--
ALTER TABLE `orderitem`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `orderitem_ibfk_2_idx` (`product_id`);

--
-- Indexes for table `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`status_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `fk_category_id` (`category_id`);

--
-- Indexes for table `user_types`
--
ALTER TABLE `user_types`
  ADD PRIMARY KEY (`user_type_id`);

--
-- Indexes for table `_order`
--
ALTER TABLE `_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`user_id`),
  ADD KEY `fk_status_id` (`status_id`);

--
-- Indexes for table `_user`
--
ALTER TABLE `_user`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `fk_user_type` (`user_type_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orderitem`
--
ALTER TABLE `orderitem`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `order_status`
--
ALTER TABLE `order_status`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT for table `_order`
--
ALTER TABLE `_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `_user`
--
ALTER TABLE `_user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderitem`
--
ALTER TABLE `orderitem`
  ADD CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `_order` (`order_id`),
  ADD CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`);

--
-- Constraints for table `_order`
--
ALTER TABLE `_order`
  ADD CONSTRAINT `_order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `_user` (`user_id`),
  ADD CONSTRAINT `fk_status_id` FOREIGN KEY (`status_id`) REFERENCES `order_status` (`status_id`);

--
-- Constraints for table `_user`
--
ALTER TABLE `_user`
  ADD CONSTRAINT `fk_user_type` FOREIGN KEY (`user_type_id`) REFERENCES `user_types` (`user_type_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
