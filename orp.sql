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
DROP DATABASE IF EXISTS `orp`;
CREATE DATABASE IF NOT EXISTS `orp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `orp`;

-- Dumping structure for table ORP.accounts
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `steamid` varchar(32) NOT NULL,
  `steamname` varchar(32) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.accounts: ~4 rows (approximately)
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` (`id`, `steamid`, `steamname`, `game_version`, `locale`, `email`, `time`, `admin`, `helper`, `registration_time`, `registration_ip`, `count_login`, `count_kick`, `last_login_time`) VALUES
	(14, '76561198291141818', NULL, NULL, NULL, NULL, NULL, 5, 0, NULL, '127.0.0.1', NULL, NULL, NULL),
	(15, '76561198448214499', NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '66.91.242.78', NULL, NULL, NULL),
	(16, '76561198377588641', NULL, NULL, NULL, NULL, NULL, 5, 0, NULL, '73.42.144.81', NULL, NULL, NULL),
	(17, '76561198327418783', NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, '168.211.219.151', NULL, NULL, NULL);
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;

-- Dumping structure for table ORP.applicants
DROP TABLE IF EXISTS `applicants`;
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
DROP TABLE IF EXISTS `atm`;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table ORP.atm: ~0 rows (approximately)
/*!40000 ALTER TABLE `atm` DISABLE KEYS */;
INSERT INTO `atm` (`id`, `modelid`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
	(1, 494, 129221, 78053, 1478, 0, 90, 0),
	(2, 494, 173869, 211218, 1298.76, 0, -89.7542, 0);
/*!40000 ALTER TABLE `atm` ENABLE KEYS */;

-- Dumping structure for table ORP.bans
DROP TABLE IF EXISTS `bans`;
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
DROP TABLE IF EXISTS `characters`;
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
  `x` varchar(50) NOT NULL DEFAULT '170694.515625',
  `y` varchar(50) NOT NULL DEFAULT '194947.453125',
  `z` varchar(50) NOT NULL DEFAULT '1396.9643554688',
  `a` varchar(50) NOT NULL DEFAULT '90.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Dumping data for table ORP.characters: ~6 rows (approximately)
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
INSERT INTO `characters` (`id`, `accountid`, `steamid`, `firstname`, `lastname`, `gender`, `health`, `armour`, `cash`, `bank`, `x`, `y`, `z`, `a`) VALUES
	(2, 14, '76561198291141818', 'Phillip', 'Hughes', 0, 100, 0, 100, 1000, '167297.15625', '196590.125', '1289.3999023438', '62.705413818359'),
	(3, 14, '76561198291141818', 'Phillip', 'Huff', 0, 100, 0, 100, 1000, '121620.9765625', '117651.109375', '5010.8061523438', '176.76721191406'),
	(4, 14, '76561198291141818', 'Samantha', 'Wright', 1, 100, 0, 100, 1000, '125773.0', '80246.0', '1645.0', '90.0'),
	(6, 16, '76561198377588641', 'Commodore', 'Dev', 0, 100, 0, 100, 1000, '-10369.102539062', '150256.484375', '-24.000240325928', '-68.286560058594'),
	(7, 16, '76561198377588641', 'Marcus', 'Irwin', 0, 100, 0, 100, 1000, '170694.515625', '194947.453125', '1396.9643554688', '90.0'),
	(8, 17, '76561198327418783', 'Ali', 'Sheldon', 0, 100, 0, 100, 1000, '166690.484375', '197257.984375', '1289.3431396484', '-65.298217773438');
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table ORP.factions
DROP TABLE IF EXISTS `factions`;
CREATE TABLE IF NOT EXISTS `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `short_name` varchar(6) DEFAULT NULL,
  `motd` varchar(50) DEFAULT 'Default MOTD',
  `leadership_rank` int(11) DEFAULT NULL,
  `radio_dimension` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ORP.factions: ~0 rows (approximately)
/*!40000 ALTER TABLE `factions` DISABLE KEYS */;
/*!40000 ALTER TABLE `factions` ENABLE KEYS */;

-- Dumping structure for table ORP.faction_ranks
DROP TABLE IF EXISTS `faction_ranks`;
CREATE TABLE IF NOT EXISTS `faction_ranks` (
  `id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `rank_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table ORP.faction_ranks: ~0 rows (approximately)
/*!40000 ALTER TABLE `faction_ranks` DISABLE KEYS */;
/*!40000 ALTER TABLE `faction_ranks` ENABLE KEYS */;

-- Dumping structure for table ORP.ipbans
DROP TABLE IF EXISTS `ipbans`;
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
DROP TABLE IF EXISTS `kicks`;
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
DROP TABLE IF EXISTS `log_chat`;
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
DROP TABLE IF EXISTS `log_login`;
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
DROP TABLE IF EXISTS `log_reports`;
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
DROP TABLE IF EXISTS `log_weaponshot`;
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

-- Dumping structure for table ORP.markers
DROP TABLE IF EXISTS `markers`;
CREATE TABLE IF NOT EXISTS `markers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(11) NOT NULL,
  `x1` float NOT NULL,
  `y1` float NOT NULL,
  `z1` float NOT NULL,
  `x2` float NOT NULL,
  `y2` float NOT NULL,
  `z2` float NOT NULL,
  `r` int(11) DEFAULT NULL,
  `g` int(11) DEFAULT NULL,
  `b` int(11) DEFAULT NULL,
  `a` int(11) DEFAULT NULL,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table ORP.markers: ~0 rows (approximately)
/*!40000 ALTER TABLE `markers` DISABLE KEYS */;
/*!40000 ALTER TABLE `markers` ENABLE KEYS */;

-- Dumping structure for table ORP.vehicles
DROP TABLE IF EXISTS `vehicles`;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

-- Dumping data for table ORP.vehicles: ~7 rows (approximately)
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` (`id`, `owner`, `model`, `plate`, `faction`, `x`, `y`, `z`, `a`, `r`, `g`, `b`) VALUES
	(1, 2, 12, '1', 0, '129135.2109375', '79771.65625', '1469.5354003906', '-90.713439941406', 255, 255, 255),
	(2, 7, 6, 'Commodore', 0, '130205.15625', '80522.5078125', '1468.7551269531', '-178.45524597168', 255, 255, 255),
	(3, 3, 7, 'Pickup', 0, '128573.125', '79694.5234375', '1467.4923095703', '-89.936798095703', 255, 255, 255),
	(4, 2, 3, 'HIGHWAY', 0, '177662.171875', '211093.546875', '1195.2258300781', '0.056781426072121', 255, 255, 255),
	(5, 2, 3, 'HIGHWAY', 0, '174926.984375', '211088.734375', '1195.2176513672', '0.86799430847168', 255, 255, 255),
	(6, 2, 20, 'HIGHWAY', 0, '176247.453125', '212162.265625', '2151.6293945313', '-90.329650878906', 255, 255, 255),
	(7, 7, 6, 'Test', 0, '169077.515625', '194126.859375', '1209.3485107422', '-19.992433547974', 255, 255, 255);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
