
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


CREATE SCHEMA IF NOT EXISTS `ecommerce_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ecommerce_db` ;

DROP TABLE IF EXISTS `ecommerce_db`.`utente` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`utente` (
  `id_utente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cognome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `tipo_utente` ENUM('ospite', 'registrato', 'admin') NOT NULL DEFAULT 'ospite',
  PRIMARY KEY (`id_utente`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`carrello` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`carrello` (
  `id_carrello` INT NOT NULL AUTO_INCREMENT,
  `id_utente` INT NOT NULL,
  PRIMARY KEY (`id_carrello`),
  UNIQUE INDEX `id_utente` (`id_utente` ASC) VISIBLE,
  CONSTRAINT `carrello_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`categoria` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`categoria` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nome_categoria` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE INDEX `nome_categoria` (`nome_categoria` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`indirizzo` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`indirizzo` (
  `id_indirizzo` INT NOT NULL AUTO_INCREMENT,
  `via` VARCHAR(255) NOT NULL,
  `citta` VARCHAR(100) NOT NULL,
  `cap` VARCHAR(10) NOT NULL,
  `id_utente` INT NOT NULL,
  PRIMARY KEY (`id_indirizzo`),
  INDEX `id_utente` (`id_utente` ASC) VISIBLE,
  CONSTRAINT `indirizzo_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`ordine` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`ordine` (
  `id_ordine` INT NOT NULL AUTO_INCREMENT,
  `data_ordine` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `stato_ordine` VARCHAR(50) NOT NULL DEFAULT 'In elaborazione',
  `totale_ordine` DECIMAL(10,2) NOT NULL,
  `metodo_pagamento` VARCHAR(50) NOT NULL DEFAULT 'Carta di Credito',
  `id_utente` INT NOT NULL,
  `id_indirizzo` INT NOT NULL,
  PRIMARY KEY (`id_ordine`),
  INDEX `id_utente` (`id_utente` ASC) VISIBLE,
  INDEX `id_indirizzo` (`id_indirizzo` ASC) VISIBLE,
  CONSTRAINT `ordine_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE RESTRICT,
  CONSTRAINT `ordine_ibfk_2`
    FOREIGN KEY (`id_indirizzo`)
    REFERENCES `ecommerce_db`.`indirizzo` (`id_indirizzo`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`piattaforma` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`piattaforma` (
  `id_piattaforma` INT NOT NULL AUTO_INCREMENT,
  `nome_piattaforma` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_piattaforma`),
  UNIQUE INDEX `nome_piattaforma` (`nome_piattaforma` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`prodotto` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`prodotto` (
  `id_prodotto` INT NOT NULL AUTO_INCREMENT,
  `nome_prodotto` VARCHAR(255) NOT NULL,
  `descrizione` TEXT NULL DEFAULT NULL,
  `prezzo_base` DECIMAL(10,2) NOT NULL,
  `quantita_stock` INT NOT NULL DEFAULT '0',
  `condizione` VARCHAR(50) NOT NULL,
  `iva` DECIMAL(5,2) NOT NULL DEFAULT '22.00',
  `attivo` TINYINT(1) NOT NULL DEFAULT '1',
  `id_categoria` INT NULL DEFAULT NULL,
  `id_piattaforma` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_prodotto`),
  INDEX `id_categoria` (`id_categoria` ASC) VISIBLE,
  INDEX `id_piattaforma` (`id_piattaforma` ASC) VISIBLE,
  CONSTRAINT `prodotto_ibfk_1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `ecommerce_db`.`categoria` (`id_categoria`)
    ON DELETE SET NULL,
  CONSTRAINT `prodotto_ibfk_2`
    FOREIGN KEY (`id_piattaforma`)
    REFERENCES `ecommerce_db`.`piattaforma` (`id_piattaforma`)
    ON DELETE SET NULL)
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`dettagli_ordine` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`dettagli_ordine` (
  `id_dettaglio` INT NOT NULL AUTO_INCREMENT,
  `quantita` INT NOT NULL DEFAULT '1',
  `prezzo_vendita` DECIMAL(10,2) NOT NULL,
  `iva_applicata` DECIMAL(5,2) NOT NULL,
  `id_ordine` INT NOT NULL,
  `id_prodotto` INT NOT NULL,
  PRIMARY KEY (`id_dettaglio`),
  INDEX `id_ordine` (`id_ordine` ASC) VISIBLE,
  INDEX `id_prodotto` (`id_prodotto` ASC) VISIBLE,
  CONSTRAINT `dettagli_ordine_ibfk_1`
    FOREIGN KEY (`id_ordine`)
    REFERENCES `ecommerce_db`.`ordine` (`id_ordine`)
    ON DELETE CASCADE,
  CONSTRAINT `dettagli_ordine_ibfk_2`
    FOREIGN KEY (`id_prodotto`)
    REFERENCES `ecommerce_db`.`prodotto` (`id_prodotto`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`fattura` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`fattura` (
  `id_fattura` INT NOT NULL AUTO_INCREMENT,
  `codice_fattura` VARCHAR(100) NOT NULL,
  `data_emissione` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `id_ordine` INT NOT NULL,
  PRIMARY KEY (`id_fattura`),
  UNIQUE INDEX `codice_fattura` (`codice_fattura` ASC) VISIBLE,
  UNIQUE INDEX `id_ordine` (`id_ordine` ASC) VISIBLE,
  CONSTRAINT `fattura_ibfk_1`
    FOREIGN KEY (`id_ordine`)
    REFERENCES `ecommerce_db`.`ordine` (`id_ordine`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`immagine` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`immagine` (
  `id_immagine` INT NOT NULL AUTO_INCREMENT,
  `url_immagine` VARCHAR(500) NOT NULL,
  `id_prodotto` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_immagine`),
  INDEX `id_prodotto` (`id_prodotto` ASC) VISIBLE,
  CONSTRAINT `immagine_ibfk_1`
    FOREIGN KEY (`id_prodotto`)
    REFERENCES `ecommerce_db`.`prodotto` (`id_prodotto`)
    ON DELETE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;






DROP TABLE IF EXISTS `ecommerce_db`.`utente_admin` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`utente_admin` (
  `id_utente` INT NOT NULL,
  `livello_accesso` VARCHAR(50) NULL DEFAULT 'standard_admin',
  PRIMARY KEY (`id_utente`),
  CONSTRAINT `utente_admin_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`utente_registrato` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`utente_registrato` (
  `id_utente` INT NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `newsletter` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id_utente`),
  CONSTRAINT `utente_registrato_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`voce_carrello` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`voce_carrello` (
  `id_voce` INT NOT NULL AUTO_INCREMENT,
  `quantita` INT NOT NULL DEFAULT '1',
  `id_carrello` INT NOT NULL,
  `id_prodotto` INT NOT NULL,
  PRIMARY KEY (`id_voce`),
  INDEX `id_carrello` (`id_carrello` ASC) VISIBLE,
  INDEX `id_prodotto` (`id_prodotto` ASC) VISIBLE,
  CONSTRAINT `voce_carrello_ibfk_1`
    FOREIGN KEY (`id_carrello`)
    REFERENCES `ecommerce_db`.`carrello` (`id_carrello`)
    ON DELETE CASCADE,
  CONSTRAINT `voce_carrello_ibfk_2`
    FOREIGN KEY (`id_prodotto`)
    REFERENCES `ecommerce_db`.`prodotto` (`id_prodotto`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `ecommerce_db`.`wishlist` ;

CREATE TABLE IF NOT EXISTS `ecommerce_db`.`wishlist` (
  `id_utente` INT NOT NULL,
  `id_prodotto` INT NOT NULL,
  PRIMARY KEY (`id_utente`, `id_prodotto`),
  INDEX `id_prodotto` (`id_prodotto` ASC) VISIBLE,
  CONSTRAINT `wishlist_ibfk_1`
    FOREIGN KEY (`id_utente`)
    REFERENCES `ecommerce_db`.`utente` (`id_utente`)
    ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2`
    FOREIGN KEY (`id_prodotto`)
    REFERENCES `ecommerce_db`.`prodotto` (`id_prodotto`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
