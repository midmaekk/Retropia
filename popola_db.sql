USE `ecommerce_db`;

-- -----------------------------------------------------
-- 1. Popolamento Categorie
-- -----------------------------------------------------
INSERT INTO `categoria` (`id_categoria`, `nome_categoria`) VALUES
(1, 'Console'),
(2, 'Videogiochi'),
(3, 'Accessori');

-- -----------------------------------------------------
-- 2. Popolamento Piattaforme
-- -----------------------------------------------------
INSERT INTO `piattaforma` (`id_piattaforma`, `nome_piattaforma`) VALUES
(1, 'Super Nintendo (SNES)'),
(2, 'Game Boy'),
(3, 'Sega Mega Drive'),
(4, 'PlayStation 1'),
(5, 'Nintendo 64'),
(6, 'NES');

-- -----------------------------------------------------
-- 3. Popolamento Prodotti
-- -----------------------------------------------------
INSERT INTO `prodotto` (`id_prodotto`, `nome_prodotto`, `descrizione`, `prezzo_base`, `quantita_stock`, `condizione`, `iva`, `id_categoria`, `id_piattaforma`) VALUES
(1, 'Chrono Trigger', 'Uno dei migliori JRPG mai creati, in condizioni perfette e box originale.', 150.00, 2, 'Usato - Ottimo', 22.00, 2, 1),
(2, 'Cavo Link Game Boy', 'Cavo link originale per Nintendo Game Boy. Perfetto per gli scambi di Pokémon.', 15.00, 10, 'Nuovo', 22.00, 3, 2),
(3, 'Controller Sega Mega Drive 6 Tasti', 'Controller originale a 6 tasti per Sega Mega Drive, perfetto per i picchiaduro.', 30.00, 5, 'Usato - Buono', 22.00, 3, 3),
(4, 'Controller SNES Originale', 'Controller originale per Super Nintendo Entertainment System.', 25.00, 8, 'Usato - Ottimo', 22.00, 3, 1),
(5, 'Crash Bandicoot 3: Warped', 'Terzo capitolo delle avventure di Crash, versione PAL.', 45.00, 3, 'Usato - Buono', 22.00, 2, 4),
(6, 'Donkey Kong Country 2', 'Il capolavoro platform di Rare per SNES, cartuccia perfettamente funzionante.', 55.00, 4, 'Usato - Ottimo', 22.00, 2, 1),
(7, 'Final Fantasy VII - Black Label', 'L\'originale Final Fantasy 7 per PlayStation 1, ricercata edizione Black Label.', 90.00, 1, 'Usato - Perfetto', 22.00, 2, 4),
(8, 'Game Boy Color', 'Console portatile Nintendo Game Boy Color originale, scocca perfettamente conservata.', 75.00, 2, 'Usato - Buono', 22.00, 1, 2),
(9, 'The Legend of Zelda: Ocarina of Time', 'L\'epica avventura di Link su Nintendo 64. Solo cartuccia.', 65.00, 3, 'Usato - Ottimo', 22.00, 2, 5),
(10, 'Sega Mega Drive II', 'Console Sega Mega Drive versione 2 con cavi e un controller inclusi.', 85.00, 2, 'Usato - Buono', 22.00, 1, 3),
(11, 'Super Nintendo (SNES)', 'Console Super Nintendo Entertainment System. Lievi segni di ingiallimento.', 110.00, 1, 'Usato - Ottimo', 22.00, 1, 1),
(12, 'Super Mario Bros. 3', 'Il classico platform intramontabile per NES.', 40.00, 5, 'Usato - Buono', 22.00, 2, 6);

-- -----------------------------------------------------
-- 4. Popolamento Immagini
-- -----------------------------------------------------
INSERT INTO `immagine` (`id_immagine`, `url_immagine`, `id_prodotto`) VALUES
(1, 'images/Chrono_Trigger.jpg', 1),
(2, 'images/Nintendo-Game-Boy-Link-Cable-Dual.jpg', 2),
(3, 'images/controllerSegaSei.jpg', 3),
(4, 'images/controllerSnes.jpg', 4),
(5, 'images/crashBandicoot3Warped.jpg', 5),
(6, 'images/donkeyKongContry2.jpg', 6),
(7, 'images/ff7blackLabel.jpg', 7),
(8, 'images/gameboyColor.jpg', 8),
(9, 'images/nintendoOcarinaoftime.jpg', 9),
(10, 'images/segamegadrive2.jpg', 10),
(11, 'images/snes.jpg', 11),
(12, 'images/supermarioNES.jpg', 12);
