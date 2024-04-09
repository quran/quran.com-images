SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS `mydb` ;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
DROP SCHEMA IF EXISTS `nextgen` ;
CREATE SCHEMA IF NOT EXISTS `nextgen` DEFAULT CHARACTER SET utf8 ;

-- -----------------------------------------------------
-- Table `nextgen`.`glyph_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph_type` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph_type` (
  `glyph_type_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `description` TEXT NULL ,
  `parent_id` INT(11) NULL ,
  PRIMARY KEY (`glyph_type_id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `UNIQUE` ON `nextgen`.`glyph_type` (`name` ASC, `parent_id` ASC) ;

CREATE INDEX `INDEX` ON `nextgen`.`glyph_type` (`name` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`glyph`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph` (
  `glyph_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `font_file` VARCHAR(255) NOT NULL ,
  `glyph_code` INT(11) NOT NULL ,
  `page_number` INT(11) NOT NULL ,
  `glyph_type_id` INT(11) NULL DEFAULT NULL ,
  `glyph_type_meta` INT(11) NULL DEFAULT NULL ,
  `description` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`glyph_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 98140
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `UNIQUE1` ON `nextgen`.`glyph` (`font_file` ASC, `glyph_code` ASC) ;

CREATE UNIQUE INDEX `UNIQUE2` ON `nextgen`.`glyph` (`glyph_code` ASC, `page_number` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`glyph_ayah`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph_ayah` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph_ayah` (
  `glyph_ayah_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `glyph_id` INT(11) NOT NULL ,
  `sura_number` INT(11) NOT NULL ,
  `ayah_number` INT(11) NOT NULL ,
  `position` INT(11) NOT NULL ,
  PRIMARY KEY (`glyph_ayah_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 88247
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `UNIQUE` ON `nextgen`.`glyph_ayah` (`sura_number` ASC, `ayah_number` ASC, `position` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`glyph_ayah_bbox`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph_ayah_bbox` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph_ayah_bbox` (
  `glyph_ayah_bbox_id` INT(11) NOT NULL COMMENT '\n\n' ,
  `glyph_ayah_id` INT(11) NOT NULL ,
  `img_width` INT(11) NOT NULL ,
  `min_x` INT(11) NOT NULL ,
  `max_x` INT(11) NOT NULL ,
  `min_y` INT(11) NOT NULL ,
  `max_y` INT(11) NOT NULL ,
  PRIMARY KEY (`glyph_ayah_bbox_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `nextgen`.`glyph_page_line`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph_page_line` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph_page_line` (
  `glyph_page_line_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `glyph_id` INT(11) NOT NULL ,
  `page_number` INT(11) NOT NULL ,
  `line_number` INT(11) NOT NULL ,
  `position` INT(11) NOT NULL ,
  `line_type` ENUM('sura-header','bismillah','ayah-text') NULL DEFAULT NULL ,
  PRIMARY KEY (`glyph_page_line_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 88812
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `UNIQUE` ON `nextgen`.`glyph_page_line` (`page_number` ASC, `line_number` ASC, `position` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`glyph_page_line_bbox`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`glyph_page_line_bbox` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`glyph_page_line_bbox` (
  `glyph_page_bbox_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `glyph_page_line_id` INT(11) NOT NULL ,
  `img_width` INT(11) NOT NULL ,
  `min_x` INT(11) NOT NULL ,
  `max_x` INT(11) NOT NULL ,
  `min_y` INT(11) NOT NULL ,
  `max_y` INT(11) NOT NULL ,
  PRIMARY KEY (`glyph_page_bbox_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `nextgen`.`language`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`language` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`language` (
  `language_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `language_code` VARCHAR(255) NOT NULL ,
  `english_name` VARCHAR(255) NOT NULL ,
  `native_name` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`language_id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE UNIQUE INDEX `UNIQUE` ON `nextgen`.`language` (`language_code` ASC) ;

CREATE INDEX `english_index` ON `nextgen`.`language` (`english_name` ASC) ;

CREATE INDEX `native_index` ON `nextgen`.`language` (`native_name` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_arabic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_arabic` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_arabic` (
  `word_arabic_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_arabic_id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 18995
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430
MIN_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_arabic` (`value` ASC) ;

CREATE FULLTEXT INDEX `value_fulltext` ON `nextgen`.`word_arabic` (`value`) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_lemma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_lemma` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_lemma` (
  `word_lemma_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_lemma_id`) )
ENGINE = MyISAM
AUTO_INCREMENT = 3364
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_lemma` (`value` ASC) ;

CREATE FULLTEXT INDEX `value_fulltext` ON `nextgen`.`word_lemma` (`value`) ;

-- -----------------------------------------------------
-- Table `nextgen`.`word_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_root` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_root` (
  `word_root_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_root_id`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_root` (`value` ASC) ;

CREATE FULLTEXT INDEX `value_fulltext` ON `nextgen`.`word_root` (`value`) ;

-- -----------------------------------------------------
-- Table `nextgen`.`word_stem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_stem` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_stem` (
  `word_stem_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `value` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`word_stem_id`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430;

CREATE UNIQUE INDEX `value` ON `nextgen`.`word_stem` (`value` ASC) ;

CREATE FULLTEXT INDEX `value_fulltext` ON `nextgen`.`word_stem` (`value`) ;

-- -----------------------------------------------------
-- Table `nextgen`.`word`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word` (
  `word_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `glyph_id` INT(11) NOT NULL ,
  `page_number` INT(11) NOT NULL ,
  `sura_number` INT(11) NOT NULL ,
  `ayah_number` INT(11) NOT NULL ,
  `position` INT(11) NOT NULL ,
  `word_arabic_id` INT(11) NOT NULL ,
  `word_stem_id` INT(11) NULL DEFAULT NULL ,
  `word_lemma_id` INT(11) NULL DEFAULT NULL ,
  `word_root_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`word_id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 77431
DEFAULT CHARACTER SET = utf8
MAX_ROWS = 77430
MIN_ROWS = 77430;

CREATE UNIQUE INDEX `sura_ayah_position_index` ON `nextgen`.`word` (`sura_number` ASC, `ayah_number` ASC, `position` ASC) ;

CREATE UNIQUE INDEX `glyph_unique` ON `nextgen`.`word` (`glyph_id` ASC) ;

CREATE INDEX `page_index` ON `nextgen`.`word` (`page_number` ASC) ;

CREATE INDEX `sura_index` ON `nextgen`.`word` (`sura_number` ASC) ;

CREATE INDEX `sura_ayah_index` ON `nextgen`.`word` (`ayah_number` ASC, `sura_number` ASC) ;

CREATE INDEX `page_ayah_index` ON `nextgen`.`word` (`page_number` ASC, `ayah_number` ASC) ;


-- -----------------------------------------------------
-- Table `nextgen`.`word_translation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `nextgen`.`word_translation` ;

CREATE  TABLE IF NOT EXISTS `nextgen`.`word_translation` (
  `word_translation_id` INT(11) NOT NULL AUTO_INCREMENT ,
  `language_id` INT(11) NOT NULL ,
  `word_id` INT(11) NOT NULL ,
  `value` VARCHAR(255) NOT NULL ,
  `strength` DOUBLE NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`word_translation_id`) )
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `value_index` ON `nextgen`.`word_translation` (`value` ASC) ;

CREATE INDEX `language_value_index` ON `nextgen`.`word_translation` (`value` ASC, `language_id` ASC) ;

CREATE FULLTEXT INDEX `value_fulltext` ON `nextgen`.`word_translation` (`value`) ;

CREATE UNIQUE INDEX `UNIQUE` ON `nextgen`.`word_translation` (`word_id` ASC, `language_id` ASC, `value` ASC) ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
