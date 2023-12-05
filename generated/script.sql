-- AUTO-GENERATED FILE.

-- This file is an auto-generated file by Ballerina persistence layer for model.
-- Please verify the generated scripts and execute them against the target DB server.

DROP TABLE IF EXISTS `PoliceRequest`;
DROP TABLE IF EXISTS `Offense`;
DROP TABLE IF EXISTS `Citizen`;

CREATE TABLE `Citizen` (
	`id` VARCHAR(191) NOT NULL,
	`nic` VARCHAR(191) NOT NULL,
	`fullname` VARCHAR(191) NOT NULL,
	`isCriminal` BOOLEAN NOT NULL,
	PRIMARY KEY(`id`)
);

CREATE TABLE `Offense` (
	`id` VARCHAR(191) NOT NULL,
	`offense` VARCHAR(191) NOT NULL,
	`citizenId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`citizenId`) REFERENCES `Citizen`(`id`),
	PRIMARY KEY(`id`)
);

CREATE TABLE `PoliceRequest` (
	`id` VARCHAR(191) NOT NULL,
	`status` VARCHAR(191) NOT NULL,
	`reason` VARCHAR(191),
	`gid` VARCHAR(191) NOT NULL,
	`appliedTime` TIMESTAMP NOT NULL,
	`citizenId` VARCHAR(191) NOT NULL,
	FOREIGN KEY(`citizenId`) REFERENCES `Citizen`(`id`),
	PRIMARY KEY(`id`)
);
