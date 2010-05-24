SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DROP SCHEMA IF EXISTS `nextgen` ;
CREATE SCHEMA IF NOT EXISTS `nextgen` DEFAULT CHARACTER SET utf8 ;

-- -----------------------------------------------------
-- Table `nextgen`.`char_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char_type` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char_type` (
  `char_type_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `description` TEXT NULL DEFAULT NULL ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`char_type_id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `nextgen`.`char`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char` (
  `char_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `font_file` VARCHAR(255) NOT NULL ,
  `char_code` INT(11) NOT NULL ,
  `char_type_meta` VARCHAR(255) NULL DEFAULT NULL ,
  `page_number` INT(11) NOT NULL DEFAULT '0' ,
  `notes` TEXT NULL DEFAULT NULL ,
  `char_type_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`char_id`) ,
  CONSTRAINT `fk_char_1`
    FOREIGN KEY (`char_type_id` )
    REFERENCES `nextgen`.`char_type` (`char_type_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 98140
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `char_UNIQUE` ON `nextgen`.`char` (`font_file` ASC, `char_code` ASC) ;

CREATE UNIQUE INDEX `char_code` ON `nextgen`.`char` (`char_code` ASC, `page_number` ASC) ;

CREATE INDEX `fk_char_1` ON `nextgen`.`char` (`char_type_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`char_ayah`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char_ayah` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char_ayah` (
  `char_ayah_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `sura_number` INT(11) NULL DEFAULT NULL ,
  `ayah_number` INT(11) NOT NULL ,
  `char_position` INT(11) NOT NULL ,
  `char_id` INT(11) NOT NULL ,
  PRIMARY KEY (`char_ayah_id`) ,
  CONSTRAINT `fk_char_2`
    FOREIGN KEY (`char_id` )
    REFERENCES `nextgen`.`char` (`char_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 88247
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `sura_number` ON `nextgen`.`char_ayah` (`sura_number` ASC, `ayah_number` ASC, `char_position` ASC) ;

CREATE INDEX `fk_char_2` ON `nextgen`.`char_ayah` (`char_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`char_ayah_bbox`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char_ayah_bbox` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char_ayah_bbox` (
  `char_ayah_bbox_id` INT(11) NOT NULL COMMENT '\n\n' ,
  `char_ayah_id` INT(11) NOT NULL ,
  `ayah_width` INT(11) NOT NULL ,
  `min_x` INT(11) NOT NULL ,
  `max_x` INT(11) NOT NULL ,
  `min_y` INT(11) NOT NULL ,
  `max_y` INT(11) NOT NULL ,
  PRIMARY KEY (`char_ayah_bbox_id`) ,
  CONSTRAINT `fk_char_ayah_1`
    FOREIGN KEY (`char_ayah_id` )
    REFERENCES `nextgen`.`char_ayah` (`char_ayah_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `char_ayah_bbox_UNIQUE` ON `nextgen`.`char_ayah_bbox` (`char_ayah_id` ASC, `ayah_width` ASC) ;

CREATE INDEX `fk_char_ayah_1` ON `nextgen`.`char_ayah_bbox` (`char_ayah_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`char_page`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char_page` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char_page` (
  `char_page_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `page_number` INT(11) NOT NULL ,
  `line_number` INT(11) NOT NULL ,
  `line_type` ENUM('sura-header','bismillah','ayah-text') NULL DEFAULT NULL ,
  `char_position` INT(11) NOT NULL ,
  `char_id` INT(11) NOT NULL ,
  PRIMARY KEY (`char_page_id`) ,
  CONSTRAINT `fk_char_1`
    FOREIGN KEY (`char_id` )
    REFERENCES `nextgen`.`char` (`char_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 88812
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `char_page_UNIQUE` ON `nextgen`.`char_page` (`page_number` ASC, `line_number` ASC, `char_position` ASC) ;

CREATE INDEX `fk_char_1` ON `nextgen`.`char_page` (`char_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`char_page_bbox`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`char_page_bbox` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`char_page_bbox` (
  `char_page_bbox_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `char_page_id` INT(11) NOT NULL ,
  `page_width` INT(11) NOT NULL ,
  `min_x` INT(11) NOT NULL ,
  `max_x` INT(11) NOT NULL ,
  `min_y` INT(11) NOT NULL ,
  `max_y` INT(11) NOT NULL ,
  PRIMARY KEY (`char_page_bbox_id`) ,
  CONSTRAINT `fk_char_page_1`
    FOREIGN KEY (`char_page_id` )
    REFERENCES `nextgen`.`char_page` (`char_page_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `char_page_bbox_UNIQUE` ON `nextgen`.`char_page_bbox` (`char_page_id` ASC, `page_width` ASC) ;

CREATE INDEX `fk_char_page_1` ON `nextgen`.`char_page_bbox` (`char_page_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`language` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`language` (
  `language_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `language_code` VARCHAR(255) NOT NULL ,
  `english_name` VARCHAR(255) NULL DEFAULT NULL ,
  `native_name` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`language_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `language_UNIQUE` ON `nextgen`.`language` (`language_code` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_arabic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_arabic` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_arabic` (
  `word_arabic_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_arabic_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 18995
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430
MIN_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_arabic` (`value` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_lemma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_lemma` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_lemma` (
  `word_lemma_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_lemma_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 3364
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_lemma` (`value` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_root` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_root` (
  `word_root_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_root_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_root` (`value` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_stem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_stem` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_stem` (
  `word_stem_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_stem_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_stem` (`value` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word` (
  `word_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `page_number` INT(11) NOT NULL ,
  `sura_number` INT(11) NOT NULL ,
  `ayah_number` INT(11) NOT NULL ,
  `word_position` INT(11) NOT NULL ,
  `word_arabic_id` INT(11) NOT NULL ,
  `word_stem_id` INT(11) NULL DEFAULT NULL ,
  `word_lemma_id` INT(11) NULL DEFAULT NULL ,
  `word_root_id` INT(11) NULL DEFAULT NULL ,
  `char_id` INT(11) NOT NULL ,
  PRIMARY KEY (`word_id`) ,
  CONSTRAINT `fk_char_3`
    FOREIGN KEY (`char_id` )
    REFERENCES `nextgen`.`char` (`char_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_word_arabic_1`
    FOREIGN KEY (`word_arabic_id` )
    REFERENCES `nextgen`.`word_arabic` (`word_arabic_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_word_lemma_1`
    FOREIGN KEY (`word_lemma_id` )
    REFERENCES `nextgen`.`word_lemma` (`word_lemma_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_word_root_1`
    FOREIGN KEY (`word_root_id` )
    REFERENCES `nextgen`.`word_root` (`word_root_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_word_stem_1`
    FOREIGN KEY (`word_stem_id` )
    REFERENCES `nextgen`.`word_stem` (`word_stem_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 77431
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430
MIN_ROWS = 77430;

CREATE UNIQUE INDEX `word_UNIQUE` ON `nextgen`.`word` (`sura_number` ASC, `ayah_number` ASC, `word_position` ASC) ;

CREATE INDEX `fk_word_arabic_1` ON `nextgen`.`word` (`word_arabic_id` ASC) ;

CREATE INDEX `fk_word_lemma_1` ON `nextgen`.`word` (`word_lemma_id` ASC) ;

CREATE INDEX `fk_word_root_1` ON `nextgen`.`word` (`word_root_id` ASC) ;

CREATE INDEX `fk_word_stem_1` ON `nextgen`.`word` (`word_stem_id` ASC) ;

CREATE INDEX `fk_char_3` ON `nextgen`.`word` (`char_id` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_translation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_translation` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_translation` (
  `word_translation_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `language_id` INT(11) NOT NULL ,
  `word_id` INT(11) NOT NULL ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_translation_id`) ,
  CONSTRAINT `fk_language_1`
    FOREIGN KEY (`language_id` )
    REFERENCES `nextgen`.`language` (`language_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_word_1`
    FOREIGN KEY (`word_id` )
    REFERENCES `nextgen`.`word` (`word_id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `word_translation_UNIQUE` ON `nextgen`.`word_translation` (`language_id` ASC, `word_id` ASC) ;

CREATE INDEX `fk_language_1` ON `nextgen`.`word_translation` (`language_id` ASC) ;

CREATE INDEX `fk_word_1` ON `nextgen`.`word_translation` (`word_id` ASC) ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
