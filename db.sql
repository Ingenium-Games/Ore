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
  `Accounts` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Appearance` longtext COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '{"sex":0}',
  `Modifiers` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Health` int(3) NOT NULL DEFAULT 100,
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

-- Dumping data for table db.characters: ~1 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table db.character_accounts
CREATE TABLE IF NOT EXISTS `character_accounts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Account_Number` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Bank` int(11) NOT NULL DEFAULT 0,
  `Pin` varchar(12) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0000',
  `Loan` int(11) DEFAULT NULL,
  `Duration` int(3) DEFAULT NULL,
  `Active` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Character_ID` (`Character_ID`),
  UNIQUE KEY `Account_Number` (`Account_Number`),
  KEY `Duration` (`Duration`),
  KEY `Active` (`Active`),
  CONSTRAINT `FK_character_accounts_characters` FOREIGN KEY (`Character_ID`) REFERENCES `characters` (`Character_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.character_accounts: ~0 rows (approximately)
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.jobs: ~5 rows (approximately)
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` (`ID`, `Name`, `Label`, `Grade`, `Grade_Label`, `Grade_Salary`) VALUES
	(1, 'unemployed', 'Unemployed', 0, 'Unemployed', 12),
	(2, 'police', 'Police', 0, 'Cadet', 25),
	(3, 'police', '', 1, 'Junior Officer', 29),
	(4, 'police', '', 2, 'Officer', 34),
	(5, 'police', '', 3, 'Senior Officer', 40);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table db.job_accounts: ~0 rows (approximately)
/*!40000 ALTER TABLE `job_accounts` DISABLE KEYS */;
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

-- Dumping data for table db.users: ~0 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
