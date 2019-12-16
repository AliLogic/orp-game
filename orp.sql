-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.10-MariaDB-log - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for ORP
CREATE DATABASE IF NOT EXISTS `orp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `ORP`;

-- Dumping structure for table ORP.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `steamid` varchar(32) NOT NULL,
  `steam_name` varchar(32) DEFAULT NULL,
  `game_version` mediumint(10) unsigned DEFAULT NULL,
  `locale` varchar(6) DEFAULT NULL,
  `email` varchar(28) DEFAULT NULL,
  `time` int(10) unsigned DEFAULT NULL,
  `admin` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `helper` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `registration_time` int(10) unsigned DEFAULT NULL,
  `registration_ip` varchar(16) DEFAULT NULL,
  `count_login` int(10) unsigned DEFAULT NULL,
  `count_kick` int(10) unsigned zerofill DEFAULT NULL,
  `last_login_time` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `steamid` (`steamid`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.accounts: ~1 rows (approximately)
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` (`id`, `steamid`, `steam_name`, `game_version`, `locale`, `email`, `time`, `admin`, `helper`, `registration_time`, `registration_ip`, `count_login`, `count_kick`, `last_login_time`) VALUES
	(14, '76561198291141818', NULL, NULL, NULL, NULL, NULL, 5, 0, NULL, '127.0.0.1', NULL, NULL, NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table ORP.applicants
CREATE TABLE IF NOT EXISTS `applicants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discordName` varchar(255) NOT NULL,
  `experience` varchar(5000) NOT NULL,
  `why` varchar(5000) NOT NULL,
  `what` varchar(5000) NOT NULL,
  `what2` varchar(5000) NOT NULL,
  `discordTag` varchar(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ORP.applicants: ~0 rows (approximately)
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;

-- Dumping structure for table ORP.atm
CREATE TABLE IF NOT EXISTS `atm` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `modelid` mediumint(8) unsigned NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `rx` float NOT NULL,
  `ry` float NOT NULL,
  `rz` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.atm: ~0 rows (approximately)
/*!40000 ALTER TABLE `atm` DISABLE KEYS */;
INSERT INTO `atm` (`id`, `modelid`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
	(1, 494, 129221, 78053, 1478, 0, 90, 0);
/*!40000 ALTER TABLE `atm` ENABLE KEYS */;

-- Dumping structure for table ORP.bans
CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `ban_time` int(10) unsigned NOT NULL,
  `expire_time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  `ping` smallint(5) unsigned NOT NULL,
  `packetloss` float(4,2) NOT NULL,
  `locx` float(14,4) NOT NULL,
  `locy` float(14,4) NOT NULL,
  `locz` float(14,4) NOT NULL,
  `health` float(10,2) NOT NULL,
  `armor` float(10,2) NOT NULL,
  `weapon_id` smallint(5) unsigned NOT NULL,
  `weapon_ammo` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `bans_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table ORP.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(11) NOT NULL,
  `steamid` varchar(32) NOT NULL DEFAULT '',
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `gender` int(11) NOT NULL DEFAULT 0,
  `health` float NOT NULL DEFAULT 100,
  `armour` float NOT NULL DEFAULT 0,
  `cash` int(11) NOT NULL DEFAULT 100,
  `bank` int(11) NOT NULL DEFAULT 1000,
  `x` varchar(50) NOT NULL DEFAULT '125773.0',
  `y` varchar(50) NOT NULL DEFAULT '80246.0',
  `z` varchar(50) NOT NULL DEFAULT '1645.0',
  `a` varchar(50) NOT NULL DEFAULT '90.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumping data for table ORP.characters: ~3 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` (`id`, `accountid`, `steamid`, `firstname`, `lastname`, `gender`, `health`, `armour`, `cash`, `bank`, `x`, `y`, `z`, `a`) VALUES
	(2, 14, '76561198291141818', 'Phillip', 'Hughes', 0, 100, 0, 100, 1000, '125905.546875', '80002.25', '1566.9010009766', '-167.39573669434'),
	(3, 14, '76561198291141818', 'Phillip', 'Huff', 0, 100, 0, 100, 1000, '125773.0', '80246.0', '1645.0', '90.0'),
	(4, 14, '76561198291141818', 'Samantha', 'Wright', 1, 100, 0, 100, 1000, '125773.0', '80246.0', '1645.0', '90.0');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table ORP.ipbans
CREATE TABLE IF NOT EXISTS `ipbans` (
  `ip` varchar(16) NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `ban_time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.ipbans: ~0 rows (approximately)
/*!40000 ALTER TABLE `ipbans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipbans` ENABLE KEYS */;

-- Dumping structure for table ORP.kicks
CREATE TABLE IF NOT EXISTS `kicks` (
  `id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `kicks_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.kicks: ~0 rows (approximately)
/*!40000 ALTER TABLE `kicks` DISABLE KEYS */;
/*!40000 ALTER TABLE `kicks` ENABLE KEYS */;

-- Dumping structure for table ORP.log_chat
CREATE TABLE IF NOT EXISTS `log_chat` (
  `id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `text` varchar(300) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_chat_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.log_chat: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_chat` ENABLE KEYS */;

-- Dumping structure for table ORP.log_login
CREATE TABLE IF NOT EXISTS `log_login` (
  `id` int(10) unsigned NOT NULL,
  `ip` varchar(16) NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `action` enum('ACTION_LOGIN','ACTION_LOGOUT') NOT NULL,
  `service` enum('SERVICE_SERVER','SERVICE_OTHER') NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `log_login_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.log_login: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_login` ENABLE KEYS */;

-- Dumping structure for table ORP.log_reports
CREATE TABLE IF NOT EXISTS `log_reports` (
  `id` int(10) unsigned NOT NULL,
  `reportedby_id` int(10) unsigned NOT NULL,
  `report_time` int(10) unsigned NOT NULL,
  `message` varchar(128) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_reports_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.log_reports: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_reports` ENABLE KEYS */;

-- Dumping structure for table ORP.log_weaponshot
CREATE TABLE IF NOT EXISTS `log_weaponshot` (
  `id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `hittype` tinyint(3) unsigned NOT NULL,
  `hitplayer` int(10) unsigned NOT NULL,
  `hitx` float NOT NULL,
  `hity` float NOT NULL,
  `hitz` float NOT NULL,
  `startx` float NOT NULL,
  `starty` float NOT NULL,
  `startz` float NOT NULL,
  `weapon` tinyint(3) unsigned NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_weaponshot_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.log_weaponshot: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_weaponshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_weaponshot` ENABLE KEYS */;

-- Dumping structure for table ORP.vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` int(11) NOT NULL DEFAULT 0,
  `model` int(11) NOT NULL,
  `plate` varchar(13) NOT NULL DEFAULT 'ONSET',
  `faction` int(11) NOT NULL DEFAULT 0,
  `x` varchar(50) NOT NULL,
  `y` varchar(50) NOT NULL,
  `z` varchar(50) NOT NULL,
  `a` varchar(50) NOT NULL,
  `r` int(11) NOT NULL,
  `g` int(11) NOT NULL,
  `b` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table ORP.vehicles: ~0 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`id`, `owner`, `model`, `plate`, `faction`, `x`, `y`, `z`, `a`, `r`, `g`, `b`) VALUES
	(1, 2, 12, '1', 0, '129135.2109375', '79771.65625', '1469.5354003906', '-90.713439941406', 255, 255, 255);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
