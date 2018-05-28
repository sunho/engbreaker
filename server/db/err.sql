-- MySQL Script generated by MySQL Workbench
-- 2018년 05월 29일 (화) 오전 05시 04분 12초
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema gorani_reader
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `word` (
  `word_id` INT NOT NULL AUTO_INCREMENT,
  `word` VARCHAR(45) NOT NULL,
  `word_pronunciation` VARCHAR(45) NULL,
  PRIMARY KEY (`word_id`),
  UNIQUE INDEX `uq_word_idx` (`word` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `relevant_word_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `relevant_word_type` (
  `relevant_word_type_code` INT NOT NULL,
  `relevant_word_type_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`relevant_word_type_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `relevant_word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `relevant_word` (
  `word_id` INT NOT NULL,
  `target_word_id` INT NOT NULL,
  `relevant_word_sequence` INT NOT NULL,
  `relevant_word_type_code` INT NOT NULL,
  PRIMARY KEY (`word_id`, `target_word_id`, `relevant_word_sequence`),
  INDEX `fk_relevant_word2_idx` (`target_word_id` ASC),
  INDEX `fk_relevant_word3_idx` (`relevant_word_type_code` ASC),
  CONSTRAINT `fk_relevant_word`
    FOREIGN KEY (`word_id`)
    REFERENCES `word` (`word_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_relevant_word2`
    FOREIGN KEY (`target_word_id`)
    REFERENCES `word` (`word_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_relevant_word3`
    FOREIGN KEY (`relevant_word_type_code`)
    REFERENCES `relevant_word_type` (`relevant_word_type_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book` (
  `book_id` INT NOT NULL AUTO_INCREMENT,
  `book_name` VARCHAR(45) NULL,
  PRIMARY KEY (`book_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sentence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentence` (
  `sentence_id` INT NOT NULL AUTO_INCREMENT,
  `sentence` VARCHAR(100) NULL,
  `book_id` INT NULL,
  PRIMARY KEY (`sentence_id`),
  INDEX `fk_sentence_idx` (`book_id` ASC),
  CONSTRAINT `fk_sentence`
    FOREIGN KEY (`book_id`)
    REFERENCES `book` (`book_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `word_sentence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `word_sentence` (
  `word_id` INT NOT NULL,
  `sentence_id` INT NOT NULL,
  PRIMARY KEY (`word_id`, `sentence_id`),
  INDEX `fk_word_sentence2_idx` (`sentence_id` ASC),
  CONSTRAINT `fk_word_sentence2`
    FOREIGN KEY (`sentence_id`)
    REFERENCES `sentence` (`sentence_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_word_sentence`
    FOREIGN KEY (`word_id`)
    REFERENCES `word` (`word_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `definition`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `definition` (
  `definition_id` INT NOT NULL AUTO_INCREMENT,
  `word_id` INT NOT NULL,
  `definition` VARCHAR(100) NOT NULL,
  `definition_pos` ENUM('verb', 'aux', 'tverb', 'noun', 'adj', 'adv', 'abr', 'prep', 'symbol', 'pronoun', 'conj', 'suffix', 'prefix', 'det') NULL,
  PRIMARY KEY (`definition_id`),
  CONSTRAINT `fk_definition`
    FOREIGN KEY (`word_id`)
    REFERENCES `word` (`word_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `known_word`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `known_word` (
  `user_id` INT NOT NULL,
  `word_id` INT NOT NULL,
  `known_word_added_date` DATETIME NOT NULL,
  PRIMARY KEY (`user_id`, `word_id`),
  INDEX `fk_known_word2_idx` (`word_id` ASC),
  CONSTRAINT `fk_known_word`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_known_word2`
    FOREIGN KEY (`word_id`)
    REFERENCES `word` (`word_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `user_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_detail` (
  `user_id` INT NOT NULL,
  `user_profile_image` VARCHAR(100) NOT NULL,
  `user_added_date` DATETIME NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_detail`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `oauth_service`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oauth_service` (
  `oauth_service_code` INT NOT NULL,
  `oauth_service_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`oauth_service_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `oauth_passport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oauth_passport` (
  `user_id` INT NOT NULL,
  `oauth_service_code` INT NOT NULL,
  `oauth_user_id` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`user_id`, `oauth_service_code`),
  INDEX `fk_oauth_passport2_idx` (`oauth_service_code` ASC),
  CONSTRAINT `fk_oauth_passport2`
    FOREIGN KEY (`oauth_service_code`)
    REFERENCES `oauth_service` (`oauth_service_code`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_oauth_passport`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `book_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `book_detail` (
  `book_id` INT NOT NULL,
  `book_cover_image` BLOB NULL,
  `book_author` VARCHAR(45) NULL,
  `book_popularity` VARCHAR(45) NULL,
  `book_publish_date` DATE NULL,
  PRIMARY KEY (`book_id`),
  CONSTRAINT `fk_book_detail`
    FOREIGN KEY (`book_id`)
    REFERENCES `book` (`book_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook` (
  `wordbook_uuid` BINARY(16) NOT NULL,
  `user_id` INT NOT NULL,
  `wordbook_name` VARCHAR(45) NOT NULL,
  `wordbook_seen_date` DATETIME NOT NULL,
  PRIMARY KEY (`wordbook_uuid`),
  INDEX `fk_wordbook_idx` (`user_id` ASC),
  CONSTRAINT `fk_wordbook`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook_entry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook_entry` (
  `wordbook_uuid` BINARY(16) NOT NULL,
  `definition_id` INT NOT NULL,
  `wordbook_entry_source_book` VARCHAR(45) NULL DEFAULT NULL,
  `wordbook_entry_source_sentence` VARCHAR(100) NULL DEFAULT NULL,
  `wordbook_entry_word_index` INT NULL DEFAULT NULL,
  `wordbook_entry_added_date` DATETIME NOT NULL,
  INDEX `fk_wordbook_entry_idx` (`wordbook_uuid` ASC),
  INDEX `fk_wordbook_entry2_idx` (`definition_id` ASC),
  CONSTRAINT `fk_wordbook_entry`
    FOREIGN KEY (`wordbook_uuid`)
    REFERENCES `wordbook` (`wordbook_uuid`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wordbook_entry2`
    FOREIGN KEY (`definition_id`)
    REFERENCES `definition` (`definition_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook_quiz_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook_quiz_type` (
  `wordbook_quiz_type_code` INT NOT NULL,
  `wordbook_quiz_type_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`wordbook_quiz_type_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook_quiz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook_quiz` (
  `wordbook_uuid` BINARY(16) NOT NULL,
  `wordbook_quiz_time` INT NOT NULL,
  `wordbook_quiz_type_code` INT NOT NULL,
  `wordbook_quiz_accuracy` DOUBLE NOT NULL,
  `wordbook_quiz_ended_date` DATETIME NOT NULL,
  PRIMARY KEY (`wordbook_uuid`, `wordbook_quiz_time`, `wordbook_quiz_type_code`),
  INDEX `fk_wordbook_quiz2_idx` (`wordbook_quiz_type_code` ASC),
  CONSTRAINT `fk_wordbook_quiz`
    FOREIGN KEY (`wordbook_uuid`)
    REFERENCES `wordbook` (`wordbook_uuid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wordbook_quiz2`
    FOREIGN KEY (`wordbook_quiz_type_code`)
    REFERENCES `wordbook_quiz_type` (`wordbook_quiz_type_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook_quiz_entry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook_quiz_entry` (
  `wordbook_uuid` BINARY(16) NOT NULL,
  `wordbook_quiz_time` INT NOT NULL,
  `definition_id` INT NOT NULL,
  `wordbook_quiz_entry_correct` DOUBLE NOT NULL,
  PRIMARY KEY (`wordbook_uuid`, `wordbook_quiz_time`, `definition_id`),
  INDEX `fk_wordbook_quiz_entry_idx` (`definition_id` ASC),
  CONSTRAINT `fk_wordbook_quiz_entry`
    FOREIGN KEY (`wordbook_uuid` , `wordbook_quiz_time`)
    REFERENCES `wordbook_quiz` (`wordbook_uuid` , `wordbook_quiz_time`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_wordbook_quiz_entry2`
    FOREIGN KEY (`definition_id`)
    REFERENCES `definition` (`word_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `wordbook_entries_update_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wordbook_entries_update_date` (
  `wordbook_uuid` BINARY(16) NOT NULL,
  `wordbook_entry_update_date` DATETIME NOT NULL,
  PRIMARY KEY (`wordbook_uuid`),
  CONSTRAINT `fk_wordbook_entries_update_date`
    FOREIGN KEY (`wordbook_uuid`)
    REFERENCES `wordbook` (`wordbook_uuid`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `unknown_wordbook`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `unknown_wordbook` (
  `user_id` INT NOT NULL,
  `wordbook_uuid` BINARY(16) NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_unknown_wordbook2_idx` (`wordbook_uuid` ASC),
  CONSTRAINT `fk_unknown_wordbook`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_unknown_wordbook2`
    FOREIGN KEY (`wordbook_uuid`)
    REFERENCES `wordbook` (`wordbook_uuid`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `example`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `example` (
  `definition_id` INT NOT NULL,
  `foreign` VARCHAR(500) NOT NULL,
  `native` VARCHAR(500) NULL,
  PRIMARY KEY (`definition_id`),
  CONSTRAINT `fk_definition_example`
    FOREIGN KEY (`definition_id`)
    REFERENCES `definition` (`definition_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `table1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `table1` (
)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;