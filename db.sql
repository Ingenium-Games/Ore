-- --------------------------------------------------------
-- Host:                         112.213.37.62
-- Server version:               10.3.28-MariaDB - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for db
CREATE DATABASE IF NOT EXISTS `db` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `db`;

-- Dumping structure for table db.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Primary_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character Owner\\',
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Character ID to be called as reference, C00:Unique_ID/C01:Unique_ID/C02:Unique_ID etc...',
  `Created` timestamp NOT NULL DEFAULT current_timestamp(),
  `Last_Seen` timestamp NOT NULL DEFAULT current_timestamp(),
  `City_ID` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'City ID / License to be used for Government Actions',
  `First_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Last_Name` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Birth_Date` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The Characters DOB in DD/MM/YYYY format.',
  `Height` int(3) DEFAULT NULL COMMENT 'The Characters height in CM.',
  `Phone` varchar(7) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Job` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"job":unemployed,"grade":0}',
  `Notes` varchar(4500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `Photo` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'img/icons8-team-100.png',
  `Appearance` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"sex":0}',
  `Inventory` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{}',
  `Accounts` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Modifiers` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Health` int(3) NOT NULL DEFAULT 400,
  `Armour` int(3) NOT NULL DEFAULT 0,
  `Hunger` int(3) NOT NULL DEFAULT 100,
  `Thirst` int(3) NOT NULL DEFAULT 100,
  `Stress` int(3) NOT NULL DEFAULT 0,
  `Instance` int(2) NOT NULL DEFAULT 0,
  `Coords` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"x":-1050.30, "y":-2740.95, "z":14.6}' COMMENT 'Last Position Saved...',
  `Weight` int(3) NOT NULL DEFAULT 0,
  `Is_Jailed` tinyint(1) NOT NULL DEFAULT 0,
  `Jail_Time` int(5) NOT NULL DEFAULT 0,
  `Is_Dead` tinyint(1) NOT NULL DEFAULT 0,
  `Dead_Time` timestamp NULL DEFAULT NULL,
  `Wanted` tinyint(1) NOT NULL DEFAULT 0,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `Character_ID` (`Character_ID`) USING BTREE,
  KEY `City_ID` (`City_ID`) USING BTREE,
  KEY `Wanted` (`Wanted`) USING BTREE,
  KEY `Phone` (`Phone`) USING BTREE,
  KEY `Primary_ID` (`Primary_ID`) USING BTREE,
  KEY `Status` (`Hunger`) USING BTREE,
  KEY `Thirst` (`Thirst`),
  KEY `Health` (`Health`),
  KEY `Armour` (`Armour`),
  KEY `Is_Dead` (`Is_Dead`),
  KEY `Weight` (`Weight`),
  KEY `Active` (`Active`),
  KEY `Stress` (`Stress`),
  KEY `Is_Jailed` (`Is_Jailed`),
  KEY `Instance` (`Instance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Character Table';

-- Dumping data for table db.characters: ~3 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table db.character_accounts
CREATE TABLE IF NOT EXISTS `character_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Account_Number` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Bank_Name` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT 'Maze',
  `Bank` int(11) DEFAULT NULL,
  `Pin` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0000',
  `Loan` int(11) DEFAULT NULL,
  `Duration` int(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  UNIQUE KEY `Account_Number` (`Account_Number`),
  KEY `Duration` (`Duration`),
  KEY `Active` (`Active`),
  KEY `Bank` (`Bank_Name`) USING BTREE,
  CONSTRAINT `FK_character_accounts_characters` FOREIGN KEY (`Character_ID`) REFERENCES `characters` (`Character_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.character_accounts: ~2 rows (approximately)
/*!40000 ALTER TABLE `character_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_accounts` ENABLE KEYS */;

-- Dumping structure for table db.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Grade` int(11) NOT NULL DEFAULT 0,
  `Grade_Label` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Grade_Salary` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `Name` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.jobs: ~38 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`ID`, `Name`, `Label`, `Grade`, `Grade_Label`, `Grade_Salary`) VALUES
	(1, 'none', 'Unemployed', 0, 'Unemployed', 8),
	(2, 'cop', 'Police Department', 0, 'Cadet', 17),
	(3, 'cop', '', 1, 'Junior Officer', 22),
	(4, 'cop', '', 2, 'Officer', 26),
	(5, 'cop', '', 3, 'Senior Officer', 29),
	(6, 'ems', 'Emergancy Medical Services', 0, 'Trainee', 19),
	(7, 'ems', NULL, 1, 'Paramedic', 24),
	(8, 'ems', NULL, 2, 'Doctor', 29),
	(9, 'pdm', 'Premium Motor Sport', 0, 'Pre-Delivery', 13),
	(10, 'pdm', NULL, 1, 'Floor Sales', 18),
	(11, 'pdm', NULL, 2, 'Sales Expert', 23),
	(12, 'pdm', NULL, 3, 'Operations Director', 27),
	(13, 'ems', NULL, 3, 'Cheif Medical Officer', 33),
	(14, 'cop', NULL, 4, 'Cheif of Police', 33),
	(15, 'benny', 'Benny\'s Original Motorworks', 0, 'Apprentice', 12),
	(16, 'benny', NULL, 1, 'Mechanic', 22),
	(17, 'benny', NULL, 2, 'Import Logistics', 26),
	(18, 'benny', NULL, 3, 'Boss Man', 30),
	(19, 'news', 'Wezeal News', 0, 'Intern', 10),
	(20, 'news', NULL, 1, 'Camera Crew', 16),
	(21, 'news', NULL, 2, 'Reporter', 21),
	(22, 'news', NULL, 3, 'DJ Mixer', 25),
	(23, 'news', NULL, 4, 'News Anchor', 29),
	(24, 'bins', 'Desperado\'s Waste Services', 0, 'Waste Colector', 15),
	(25, 'bins', NULL, 1, 'Heavy Colections', 22),
	(26, 'bins', NULL, 2, 'Renew Technition', 25),
	(27, 'bins', NULL, 3, 'Service Logistic Manager', 28),
	(28, 'varg', 'Vargo', 0, 'Repin Yellow', 5),
	(29, 'ball', 'Baller', 0, 'Repin Purple', 5),
	(30, 'grov', 'Grove', 0, 'Repin Green', 5),
	(31, 'king', 'King\'s', 0, 'Repin Red', 5),
	(32, 'pepe', 'Pepe\'s Pizzaria', 0, 'Delivery Driver', 10),
	(33, 'pepe', NULL, 1, 'Pizza Chef', 18),
	(34, 'pepe', NULL, 2, 'Franchisee', 24),
	(35, 'gopo', 'Go Postal', 0, 'Delivery Driver', 13),
	(36, 'mine', 'Caveat Cutters Union', 0, 'Miner', 13),
	(37, 'lumb', 'Chippy Chop\'ns Wood Shop\'n', 0, 'Wood Cutter', 13),
	(38, 'chic', 'Cluckin\' Bell', 0, 'Chicken Packer', 13);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;

-- Dumping structure for table db.job_accounts
CREATE TABLE IF NOT EXISTS `job_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` varchar(1500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Boss` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Members` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Accounts` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  KEY `Name` (`Name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.job_accounts: ~14 rows (approximately)
/*!40000 ALTER TABLE `job_accounts` DISABLE KEYS */;
INSERT INTO `job_accounts` (`ID`, `Name`, `Description`, `Boss`, `Members`, `Accounts`) VALUES
	(1, 'none', 'Unemployed : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(2, 'cop', 'Police Department : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(3, 'news', 'Wezeal New\'s : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(4, 'grov', 'Grove : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(5, 'ball', 'Baller : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(6, 'ems', 'Emergancy Medical Services : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(7, 'pdm', 'Premium Motor Sport : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(8, 'benny', 'Benny\'s Original Motorworks : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(9, 'king', 'King\'s : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(10, 'bins', 'Desperardo Waste Management : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(11, 'varg', 'Vargo : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(12, 'chic', 'Cluckin\' Bell : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(13, 'pepe', 'Pepe\'s Pizzaria : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(14, 'mine', 'Caveat Cutters Union : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(15, 'lumb', 'Chippy Chop\'ns Wood Shop\'n : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}'),
	(16, 'gopo', 'Go Postal : Description for role here.', 'Not Owned', '[]', '{"safe":0,"bank":25000}');
/*!40000 ALTER TABLE `job_accounts` ENABLE KEYS */;

-- Dumping structure for table db.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Default ID - Auto Inc on new insert.',
  `Username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `License_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by FiveM (The License)',
  `FiveM_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Steam_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by Steam',
  `Discord_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Unique ID assigned by Discord',
  `Locale` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Language Preferance as Key',
  `Ace` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'public' COMMENT 'All users are Public, Moderators are Mods and Admins are Admins. No Higher Roler than Admin.',
  `Join_Date` timestamp NOT NULL DEFAULT current_timestamp(),
  `Last_Login` timestamp NOT NULL DEFAULT current_timestamp(),
  `IP_Address` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Last Connected IP Address',
  `Ban` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 is Not Banned. 1 is Banned.',
  `Supporter` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`) USING BTREE,
  UNIQUE KEY `License_ID` (`License_ID`) USING BTREE,
  KEY `Language_Key` (`Locale`) USING BTREE,
  KEY `Ban_Status` (`Ban`) USING BTREE,
  KEY `Supporter_Status` (`Supporter`) USING BTREE,
  KEY `Ace` (`Ace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Users Table';

-- Dumping data for table db.users: ~3 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
