-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.1.38-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for orp
CREATE DATABASE IF NOT EXISTS `orp` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `orp`;

-- Dumping structure for table orp.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `steamid` varchar(17) NOT NULL,
  `steam_name` varchar(32) NOT NULL,
  `game_version` mediumint(10) unsigned NOT NULL,
  `locale` varchar(6) NOT NULL,
  `email` varchar(28) NOT NULL DEFAULT '',
  `time` int(10) unsigned NOT NULL,
  `admin` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `helper` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `registration_time` int(10) unsigned NOT NULL,
  `registration_ip` varchar(16) NOT NULL,
  `count_login` int(10) unsigned NOT NULL,
  `count_kick` int(10) unsigned NOT NULL,
  `last_login_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.accounts: ~0 rows (approximately)
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table orp.applicants
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

-- Dumping data for table orp.applicants: ~0 rows (approximately)
/*!40000 ALTER TABLE `applicants` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicants` ENABLE KEYS */;

-- Dumping structure for table orp.atm
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

-- Dumping data for table orp.atm: ~0 rows (approximately)
/*!40000 ALTER TABLE `atm` DISABLE KEYS */;
REPLACE INTO `atm` (`id`, `modelid`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
	(1, 494, 129221, 78053, 1478, 0, 90, 0);
/*!40000 ALTER TABLE `atm` ENABLE KEYS */;

-- Dumping structure for table orp.bans
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

-- Dumping data for table orp.bans: ~0 rows (approximately)
/*!40000 ALTER TABLE `bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `bans` ENABLE KEYS */;

-- Dumping structure for table orp.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(11) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `health` float NOT NULL DEFAULT '100',
  `armour` float NOT NULL DEFAULT '0',
  `cash` int(11) NOT NULL DEFAULT '100',
  `bank` int(11) NOT NULL DEFAULT '1000',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table orp.characters: ~0 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table orp.ipbans
CREATE TABLE IF NOT EXISTS `ipbans` (
  `ip` varchar(16) NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `ban_time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.ipbans: ~0 rows (approximately)
/*!40000 ALTER TABLE `ipbans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ipbans` ENABLE KEYS */;

-- Dumping structure for table orp.kicks
CREATE TABLE IF NOT EXISTS `kicks` (
  `id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `kicks_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.kicks: ~0 rows (approximately)
/*!40000 ALTER TABLE `kicks` DISABLE KEYS */;
/*!40000 ALTER TABLE `kicks` ENABLE KEYS */;

-- Dumping structure for table orp.log_chat
CREATE TABLE IF NOT EXISTS `log_chat` (
  `id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `text` varchar(300) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_chat_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.log_chat: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_chat` ENABLE KEYS */;

-- Dumping structure for table orp.log_login
CREATE TABLE IF NOT EXISTS `log_login` (
  `id` int(10) unsigned NOT NULL,
  `ip` varchar(16) NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `action` enum('ACTION_LOGIN','ACTION_LOGOUT') NOT NULL,
  `service` enum('SERVICE_SERVER','SERVICE_OTHER') NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `log_login_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.log_login: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_login` ENABLE KEYS */;

-- Dumping structure for table orp.log_reports
CREATE TABLE IF NOT EXISTS `log_reports` (
  `id` int(10) unsigned NOT NULL,
  `reportedby_id` int(10) unsigned NOT NULL,
  `report_time` int(10) unsigned NOT NULL,
  `message` varchar(128) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_reports_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table orp.log_reports: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_reports` ENABLE KEYS */;

-- Dumping structure for table orp.log_weaponshot
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

-- Dumping data for table orp.log_weaponshot: ~0 rows (approximately)
/*!40000 ALTER TABLE `log_weaponshot` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_weaponshot` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
