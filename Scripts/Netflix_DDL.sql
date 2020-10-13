/***********************************************
** MScA ANALYTICS 
** DATA ENGINEERING PLATFORMS FINAL PROJECT(MSCA 31012)
** (DDL) Creating the Netflix Dimensional Model 
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- Schema netflix
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `netflix` DEFAULT CHARACTER SET latin1 ;
USE `netflix` ;

-- -----------------------------------------------------
-- Table `netflix`.`fact_records`
-- Write Fact table fact_rental DDL script here
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`fact_records` (
  `record_id` INT(10) NOT NULL AUTO_INCREMENT,
  `show_id` INT(10),
  `type_id` INT(10),
  `date_added_id` INT(10),
  `release_year_id` INT(10),
  `rating_id` INT(10),
  `duration` INT(10),
  `title` VARCHAR(200),
  `description` VARCHAR(250),
  `imdb_user_review` FLOAT,
  `imdb_critic_review` FLOAT,
  `rt_user_review` FLOAT,
  `rt_critic_review` FLOAT,
  PRIMARY KEY (`record_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_type` (
  `type_id` INT(10) NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_cast`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_cast` (
  `cast_id` INT(10) NOT NULL AUTO_INCREMENT,
  `cast_firstName` VARCHAR(45),
  `cast_lastName` VARCHAR(45),
  PRIMARY KEY (`cast_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_records_cast_bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_records_cast_bridge` (
  `show_id` INT(10) NOT NULL,
  `cast_id` INT(10) NOT NULL,
  PRIMARY KEY (`show_id`, `cast_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_country` (
  `country_id` INT(10) NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45),
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `netflix`.`dim_records_country_bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_records_country_bridge` (
  `show_id` INT(10) NOT NULL,
  `country_id` INT(10) NOT NULL,
  PRIMARY KEY (`show_id`, `country_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `netflix`.`dim_date_added`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_date_added` (
  `date_added_id` INT(10) NOT NULL AUTO_INCREMENT,
  `date` DATE,
  `day_of_week` VARCHAR(10),
  `month` VARCHAR(10),
  `year` INT(10),
  PRIMARY KEY (`date_added_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



-- -----------------------------------------------------
-- Table `netflix`.`dim_director`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_director` (
  `director_id` INT(10) NOT NULL AUTO_INCREMENT,
  `director_firstName` VARCHAR(45),
  `director_lastName` VARCHAR(45),
  PRIMARY KEY (`director_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_records_director_bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_records_director_bridge` (
  `show_id` INT(10) NOT NULL,
  `director_id` INT(10) NOT NULL,
  PRIMARY KEY (`show_id`, `director_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



-- -----------------------------------------------------
-- Table `netflix`.`dim_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_category` (
  `category_id` INT(10) NOT NULL AUTO_INCREMENT,
  `category` VARCHAR(45),
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_records_category_bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_records_category_bridge` (
  `show_id` INT(10) NOT NULL,
  `category_id` INT(10) NOT NULL,
  PRIMARY KEY (`show_id`, `category_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



-- -----------------------------------------------------
-- Table `netflix`.`dim_rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_rating` (
  `rating_id` INT(10) NOT NULL AUTO_INCREMENT,
  `rating` VARCHAR(45),
  PRIMARY KEY (`rating_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



-- -----------------------------------------------------
-- Table `netflix`.`dim_release_year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_release_year` (
  `release_year_id` INT(10) NOT NULL AUTO_INCREMENT,
  `release_year` INT(10),
  PRIMARY KEY (`release_year_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `netflix`.`dim_show`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `netflix`.`dim_show` (
  `show_id` INT(10) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200),
  `description` VARCHAR(250),
  PRIMARY KEY (`show_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

