-- Adminer 4.7.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP DATABASE IF EXISTS `orp`;
CREATE DATABASE `orp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `orp`;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

INSERT INTO `accounts` (`id`, `steamid`, `steamname`, `game_version`, `locale`, `email`, `time`, `admin`, `helper`, `registration_time`, `registration_ip`, `count_login`, `count_kick`, `last_login_time`) VALUES
(14,	'76561198291141818',	NULL,	NULL,	NULL,	NULL,	NULL,	5,	0,	NULL,	'127.0.0.1',	NULL,	NULL,	NULL),
(15,	'76561198448214499',	NULL,	NULL,	NULL,	NULL,	NULL,	0,	0,	NULL,	'66.91.242.78',	NULL,	NULL,	NULL),
(16,	'76561198377588641',	NULL,	NULL,	NULL,	NULL,	NULL,	5,	0,	NULL,	'73.42.144.81',	NULL,	NULL,	NULL),
(17,	'76561198327418783',	NULL,	NULL,	NULL,	NULL,	NULL,	5,	0,	NULL,	'168.211.219.151',	NULL,	NULL,	NULL),
(18,	'76561198144143595',	NULL,	NULL,	NULL,	NULL,	NULL,	5,	0,	NULL,	'193.84.189.246',	NULL,	NULL,	NULL)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `steamid` = VALUES(`steamid`), `steamname` = VALUES(`steamname`), `game_version` = VALUES(`game_version`), `locale` = VALUES(`locale`), `email` = VALUES(`email`), `time` = VALUES(`time`), `admin` = VALUES(`admin`), `helper` = VALUES(`helper`), `registration_time` = VALUES(`registration_time`), `registration_ip` = VALUES(`registration_ip`), `count_login` = VALUES(`count_login`), `count_kick` = VALUES(`count_kick`), `last_login_time` = VALUES(`last_login_time`);

DROP TABLE IF EXISTS `applicants`;
CREATE TABLE `applicants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discordName` varchar(255) NOT NULL,
  `experience` varchar(5000) NOT NULL,
  `why` varchar(5000) NOT NULL,
  `what` varchar(5000) NOT NULL,
  `what2` varchar(5000) NOT NULL,
  `discordTag` varchar(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `atm`;
CREATE TABLE `atm` (
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

INSERT INTO `atm` (`id`, `modelid`, `x`, `y`, `z`, `rx`, `ry`, `rz`) VALUES
(1,	494,	129221,	78053,	1478,	0,	90,	0),
(2,	494,	173869,	211218,	1298.76,	0,	-89.7542,	0)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `modelid` = VALUES(`modelid`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `rx` = VALUES(`rx`), `ry` = VALUES(`ry`), `rz` = VALUES(`rz`);

DROP TABLE IF EXISTS `bans`;
CREATE TABLE `bans` (
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


DROP TABLE IF EXISTS `houses`;
CREATE TABLE `houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `doorid` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `ownership_type` int(11) NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL,
  `locked` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL,
  `price` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `message` varchar(128) NOT NULL DEFAULT 'This is a default business message.',
  `ix` varchar(16) NOT NULL DEFAULT '0.0',
  `iy` varchar(16) NOT NULL DEFAULT '0.0',
  `iz` varchar(16) NOT NULL DEFAULT '0.0',
  `ia` varchar(16) NOT NULL DEFAULT '0.0',
  `ex` varchar(16) NOT NULL DEFAULT '0.0',
  `ey` varchar(16) NOT NULL DEFAULT '0.0',
  `ez` varchar(16) NOT NULL DEFAULT '0.0',
  `ea` varchar(16) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `businesses`;
CREATE TABLE `businesses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `markerid` int(11) NOT NULL,
  `owner` int(11) NOT NULL DEFAULT 0,
  `ownership_type` int(11) NOT NULL DEFAULT 0,
  `name` varchar(32) NOT NULL,
  `locked` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL,
  `enterable` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `dimension` int(11) NOT NULL DEFAULT 0,
  `message` varchar(128) NOT NULL DEFAULT 'This is a default business message.',
  `ix` varchar(16) NOT NULL DEFAULT '0.0',
  `iy` varchar(16) NOT NULL DEFAULT '0.0',
  `iz` varchar(16) NOT NULL DEFAULT '0.0',
  `ia` varchar(16) NOT NULL DEFAULT '0.0',
  `ex` varchar(16) NOT NULL DEFAULT '0.0',
  `ey` varchar(16) NOT NULL DEFAULT '0.0',
  `ez` varchar(16) NOT NULL DEFAULT '0.0',
  `ea` varchar(16) NOT NULL DEFAULT '0.0',
  `mx` varchar(16) NOT NULL DEFAULT '0.0',
  `my` varchar(16) NOT NULL DEFAULT '0.0',
  `mz` varchar(16) NOT NULL DEFAULT '0.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
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
  `paycheck` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL DEFAULT 0,
  `minutes` int(11) NOT NULL DEFAULT 0,
  `playtime` int(11) NOT NULL DEFAULT 0,
  `x` varchar(50) NOT NULL DEFAULT '170694.515625',
  `y` varchar(50) NOT NULL DEFAULT '194947.453125',
  `z` varchar(50) NOT NULL DEFAULT '1396.9643554688',
  `a` varchar(50) NOT NULL DEFAULT '90.0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

INSERT INTO `characters` (`id`, `accountid`, `steamid`, `firstname`, `lastname`, `gender`, `health`, `armour`, `cash`, `bank`, `paycheck`, `level`, `exp`, `minutes`, `playtime`, `x`, `y`, `z`, `a`) VALUES
(2,	14,	'76561198291141818',	'Phillip',	'Hughes',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'195311.390625',	'185562.921875',	'1238.5687255859',	'-0.056134846061468'),
(3,	14,	'76561198291141818',	'Phillip',	'Huff',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'121620.9765625',	'117651.109375',	'5010.8061523438',	'176.76721191406'),
(4,	14,	'76561198291141818',	'Samantha',	'Wright',	1,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'125773.0',	'80246.0',	'1645.0',	'90.0'),
(6,	16,	'76561198377588641',	'Commodore',	'Dev',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'-10369.102539062',	'150256.484375',	'-24.000240325928',	'-68.286560058594'),
(7,	16,	'76561198377588641',	'Marcus',	'Irwin',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'175288.0',	'211024.0',	'1282.5264892578',	'126.91049194336'),
(8,	17,	'76561198327418783',	'Ali',	'Sheldon',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'166662.09375',	'197352.296875',	'1289.4000244141',	'52.641815185547'),
(9,	18,	'76561198144143595',	'Mike',	'Hawk',	0,	100,	0,	100,	1000,	0,	1,	0,	0,	0,	'114055.8359375',	'217836.953125',	'586.44323730469',	'-60.409240722656')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `accountid` = VALUES(`accountid`), `steamid` = VALUES(`steamid`), `firstname` = VALUES(`firstname`), `lastname` = VALUES(`lastname`), `gender` = VALUES(`gender`), `health` = VALUES(`health`), `armour` = VALUES(`armour`), `cash` = VALUES(`cash`), `bank` = VALUES(`bank`), `paycheck` = VALUES(`paycheck`), `level` = VALUES(`level`), `exp` = VALUES(`exp`), `minutes` = VALUES(`minutes`), `playtime` = VALUES(`playtime`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `a` = VALUES(`a`);

DROP TABLE IF EXISTS `factions`;
CREATE TABLE `factions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `short_name` varchar(6) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `motd` varchar(50) DEFAULT 'Default MOTD',
  `leadership_rank` int(11) DEFAULT NULL,
  `radio_dimension` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

INSERT INTO `factions` (`id`, `name`, `short_name`, `type`, `motd`, `leadership_rank`, `radio_dimension`, `bank`) VALUES
(1,	'Nevada Highway Patrol',	'NHP',	1,	'Default MOTD',	10,	0,	0)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `name` = VALUES(`name`), `short_name` = VALUES(`short_name`), `type` = VALUES(`type`), `motd` = VALUES(`motd`), `leadership_rank` = VALUES(`leadership_rank`), `radio_dimension` = VALUES(`radio_dimension`), `bank` = VALUES(`bank`);

DROP TABLE IF EXISTS `faction_members`;
CREATE TABLE `faction_members` (
  `char_id` int(11) NOT NULL,
  `faction_id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  KEY `faction_id` (`faction_id`),
  KEY `char_id` (`char_id`),
  CONSTRAINT `faction_members_ibfk_1` FOREIGN KEY (`faction_id`) REFERENCES `factions` (`id`),
  CONSTRAINT `faction_members_ibfk_2` FOREIGN KEY (`char_id`) REFERENCES `characters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `faction_ranks`;
CREATE TABLE `faction_ranks` (
  `id` int(11) NOT NULL,
  `rank_id` int(11) NOT NULL,
  `rank_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `inventory`;
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) DEFAULT NULL,
  `itemid` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `inventory` (`id`, `charid`, `itemid`, `amount`) VALUES
(1,	2,	1,	69),
(2,	7,	1,	69)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `charid` = VALUES(`charid`), `itemid` = VALUES(`itemid`), `amount` = VALUES(`amount`);

DROP TABLE IF EXISTS `ipbans`;
CREATE TABLE `ipbans` (
  `ip` varchar(16) NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `ban_time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT 'No Name Job',
  `type` int(11) NOT NULL,
  `minimum_hours` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `job_coords`;
CREATE TABLE `job_coords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobid` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `a` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `jobid` (`jobid`),
  CONSTRAINT `job_coords_ibfk_1` FOREIGN KEY (`jobid`) REFERENCES `jobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `job_ranks`;
CREATE TABLE `job_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jobid` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobid` (`jobid`),
  CONSTRAINT `job_ranks_ibfk_1` FOREIGN KEY (`jobid`) REFERENCES `jobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `kicks`;
CREATE TABLE `kicks` (
  `id` int(10) unsigned NOT NULL,
  `admin_id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `reason` varchar(128) NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `kicks_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `log_chat`;
CREATE TABLE `log_chat` (
  `id` int(10) unsigned NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `text` varchar(300) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_chat_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `log_login`;
CREATE TABLE `log_login` (
  `id` int(10) unsigned NOT NULL,
  `ip` varchar(16) NOT NULL,
  `time` int(10) unsigned NOT NULL,
  `action` enum('ACTION_LOGIN','ACTION_LOGOUT') NOT NULL,
  `service` enum('SERVICE_SERVER','SERVICE_OTHER') NOT NULL,
  KEY `id` (`id`) USING BTREE,
  CONSTRAINT `log_login_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `log_reports`;
CREATE TABLE `log_reports` (
  `id` int(10) unsigned NOT NULL,
  `reportedby_id` int(10) unsigned NOT NULL,
  `report_time` int(10) unsigned NOT NULL,
  `message` varchar(128) NOT NULL,
  KEY `id` (`id`),
  CONSTRAINT `log_reports_ibfk_1` FOREIGN KEY (`id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `log_weaponshot`;
CREATE TABLE `log_weaponshot` (
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


DROP TABLE IF EXISTS `markers`;
CREATE TABLE `markers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(11) NOT NULL,
  `x1` float NOT NULL,
  `y1` float NOT NULL,
  `z1` float NOT NULL,
  `dimension1` int(11) NOT NULL,
  `x2` float DEFAULT NULL,
  `y2` float DEFAULT NULL,
  `z2` float DEFAULT NULL,
  `dimension2` int(11) DEFAULT NULL,
  `r` int(11) DEFAULT 255,
  `g` int(11) DEFAULT 204,
  `b` int(11) DEFAULT 0,
  `a` int(11) DEFAULT 200,
  `is_locked` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `markers` (`id`, `model`, `x1`, `y1`, `z1`, `dimension1`, `x2`, `y2`, `z2`, `dimension2`, `r`, `g`, `b`, `a`, `is_locked`) VALUES
(1,	334,	198314,	209427,	1292.31,	0,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	0)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `model` = VALUES(`model`), `x1` = VALUES(`x1`), `y1` = VALUES(`y1`), `z1` = VALUES(`z1`), `dimension1` = VALUES(`dimension1`), `x2` = VALUES(`x2`), `y2` = VALUES(`y2`), `z2` = VALUES(`z2`), `dimension2` = VALUES(`dimension2`), `r` = VALUES(`r`), `g` = VALUES(`g`), `b` = VALUES(`b`), `a` = VALUES(`a`), `is_locked` = VALUES(`is_locked`);

DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

INSERT INTO `vehicles` (`id`, `owner`, `model`, `plate`, `faction`, `x`, `y`, `z`, `a`, `r`, `g`, `b`) VALUES
(1,	2,	12,	'1',	0,	'129135.2109375',	'79771.65625',	'1469.5354003906',	'-90.713439941406',	255,	255,	255),
(2,	7,	6,	'Commodore',	0,	'130205.15625',	'80522.5078125',	'1468.7551269531',	'-178.45524597168',	255,	255,	255),
(3,	2,	7,	'Pickup',	0,	'128573.125',	'79694.5234375',	'1467.4923095703',	'-89.936798095703',	255,	255,	255),
(4,	2,	3,	'HIGHWAY',	0,	'177662.171875',	'211093.546875',	'1195.2258300781',	'0.056781426072121',	255,	255,	255),
(5,	2,	3,	'HIGHWAY',	0,	'174923.40625',	'211088.203125',	'1195.1424560547',	'0.87984919548035',	255,	255,	255),
(6,	2,	20,	'HIGHWAY',	0,	'176247.453125',	'212162.265625',	'2151.6293945313',	'-90.329650878906',	255,	255,	255),
(7,	7,	6,	'Test',	0,	'169077.515625',	'194126.859375',	'1209.3485107422',	'-19.992433547974',	255,	255,	255),
(8,	9,	6,	'Sprenner',	0,	'162650.484375',	'197963.40625',	'404.84573364258',	'14.56453037262',	255,	255,	255),
(9,	2,	1,	'GCHECK',	0,	'175248.421875',	'209112.328125',	'1194.9920654297',	'165.87629699707',	255,	255,	255)
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `owner` = VALUES(`owner`), `model` = VALUES(`model`), `plate` = VALUES(`plate`), `faction` = VALUES(`faction`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `a` = VALUES(`a`), `r` = VALUES(`r`), `g` = VALUES(`g`), `b` = VALUES(`b`);

DROP TABLE IF EXISTS `warrants`;
CREATE TABLE `warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `warrant` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `warrant` (`warrant`),
  CONSTRAINT `warrants_ibfk_1` FOREIGN KEY (`warrant`) REFERENCES `warrants_pc` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `warrants_pc`;
CREATE TABLE `warrants_pc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `warrant` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

INSERT INTO `warrants_pc` (`id`, `warrant`) VALUES
(1,	'Rape'),
(2,	'Murder'),
(3,	'Obstruction of Justice')
ON DUPLICATE KEY UPDATE `id` = VALUES(`id`), `warrant` = VALUES(`warrant`);

-- 2019-12-29 11:19:01
