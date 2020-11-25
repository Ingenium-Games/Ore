-- --------------------------------------------------------
-- Host:                         103.1.184.249
-- Server version:               10.5.7-MariaDB - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             11.1.0.6116
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for db
CREATE DATABASE IF NOT EXISTS `db` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `db`;

-- Dumping structure for table db.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Primary_ID` varchar(50) DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etc...',
  `Created` timestamp NOT NULL DEFAULT current_timestamp(),
  `Last_Login` timestamp NOT NULL DEFAULT current_timestamp(),
  `City_ID` varchar(10) DEFAULT NULL COMMENT 'City ID / License to be used for Government Actions',
  `First_Name` varchar(25) DEFAULT NULL,
  `Last_Name` varchar(25) DEFAULT NULL,
  `Birth_Date` varchar(10) DEFAULT NULL COMMENT 'The Characters DOB in DD/MM/YYYY format.',
  `Height` int(3) DEFAULT NULL COMMENT 'The Characters height in CM.',
  `Phone` varchar(7) DEFAULT NULL,
  `Photo` varchar(455) DEFAULT 'img/icons8-team-100.png',
  `Bank` decimal(13,2) DEFAULT 300.00,
  `Appearance` longtext NOT NULL DEFAULT '{"sex":0}',
  `Inventory` longtext NOT NULL DEFAULT '{"cash":0.00}',
  `Status` varchar(255) NOT NULL DEFAULT '{}',
  `Job` varchar(255) NOT NULL DEFAULT '{}',
  `Coords` varchar(255) NOT NULL DEFAULT '{"x":-1050.30, "y":-2740.95, "z":14.6}' COMMENT 'Last Position Saved...',
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  KEY `First_Name` (`First_Name`),
  KEY `Last_Name` (`Last_Name`),
  KEY `City_ID` (`City_ID`),
  KEY `Coords` (`Coords`),
  KEY `Wanted` (`Wanted`),
  KEY `Active` (`Active`),
  KEY `Job` (`Job`),
  KEY `Birth_Date` (`Birth_Date`),
  KEY `Status` (`Status`),
  KEY `Bank` (`Bank`),
  KEY `Phone` (`Phone`),
  KEY `Primary_ID` (`Primary_ID`),
  KEY `Height` (`Height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Character Table';

-- Data exporting was unselected.

-- Dumping structure for table db.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `License_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by FiveM (The License)',
  `FiveM_ID` varchar(50) DEFAULT NULL,
  `Steam_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Steam',
  `Discord_ID` varchar(50) DEFAULT NULL COMMENT 'Unique ID assigned by Discord',
  `Locale` varchar(4) DEFAULT NULL COMMENT 'Language Preferance as Key',
  `Ace` varchar(10) DEFAULT 'public' COMMENT 'All users are Public, Moderators are Mods and Admins are Admins. No Higher Roler than Admin.',
  `Join_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Last_Login` timestamp NOT NULL DEFAULT current_timestamp(),
  `IP_Address` varchar(18) DEFAULT NULL COMMENT 'Last Connected IP Address',
  `Ban` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 is Not Banned. 1 is Banned.',
  `Supporter` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `License_ID` (`License_ID`),
  KEY `Discord_ID` (`Discord_ID`),
  KEY `Steam_ID` (`Steam_ID`),
  KEY `IP_Address` (`IP_Address`),
  KEY `FiveM_ID` (`FiveM_ID`),
  KEY `Language_Key` (`Locale`) USING BTREE,
  KEY `Ban_Status` (`Ban`) USING BTREE,
  KEY `Supporter_Status` (`Supporter`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users Table';

-- Data exporting was unselected.

-- Dumping structure for table db.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Hash` varchar(50) DEFAULT NULL,
  `Plate` varchar(8) DEFAULT NULL,
  `City_ID` varchar(8) DEFAULT NULL,
  `Inventory` longtext NOT NULL DEFAULT '{}',
  `Mods` longtext NOT NULL DEFAULT '{}',
  `Parked` tinyint(1) NOT NULL DEFAULT 0,
  `Repairing` tinyint(1) NOT NULL DEFAULT 0,
  `Impounded` tinyint(1) NOT NULL DEFAULT 0,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Engine` int(4) NOT NULL DEFAULT 1000,
  `Body` int(4) NOT NULL DEFAULT 1000,
  `Brakes` int(3) NOT NULL DEFAULT 100,
  `Axle` int(3) NOT NULL DEFAULT 100,
  `Radiator` int(3) NOT NULL DEFAULT 100,
  `Clutch` int(3) NOT NULL DEFAULT 100,
  `Transmission` int(3) NOT NULL DEFAULT 100,
  `Electronics` int(3) NOT NULL DEFAULT 100,
  `Fuel` int(3) NOT NULL DEFAULT 100,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Plate` (`Plate`),
  KEY `Wanted` (`Wanted`),
  KEY `Repairing` (`Repairing`),
  KEY `Impounded` (`Impounded`),
  KEY `Hash` (`Hash`),
  KEY `State` (`Parked`) USING BTREE,
  KEY `Veh-Char-City_ID` (`City_ID`),
  CONSTRAINT `Veh-Char-City_ID` FOREIGN KEY (`City_ID`) REFERENCES `characters` (`City_ID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Vehicles table';

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
