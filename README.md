# Retropia - E-Commerce Retrogaming

Progetto sviluppato per l'esame di Tecnologie Software per il Web.
Il sito e' un e-commerce completo dedicato alla vendita di videogiochi, console e accessori per il retrogaming, sviluppato seguendo rigorosamente il pattern MVC.

## Tecnologie e Architettura

- **Linguaggio Base:** Java SE 11.0 (Standard Edition)
- **Application Server:** Apache Tomcat 9.0.115
- **Database:** MySQL Community Server 8.0.45 (con MySQL Connector/J 8.0.19)
- **IDE Sviluppo:** Eclipse IDE for Enterprise Java Developers (2022-06)
- **Frontend:** HTML5, CSS3, JavaScript (Vanilla), chiamate AJAX tramite Fetch API
- **Pattern:** Model-View-Controller (MVC) con pattern DAO per l'accesso ai dati tramite Connection Pool (DataSource).

## Struttura del Database (Tabelle e Chiavi Primarie)

Il database `ecommerce_db` e' strutturato per garantire integrita' referenziale. I prodotti eliminati subiscono un soft-delete (tramite il campo booleano 'attivo') per non corrompere lo storico ordini.

- `utente` (PK: id_utente) - Dati anagrafici di base per tutti gli utenti.
- `utente_registrato` (PK: id_utente) - Dati aggiuntivi (tra cui l'hash SHA-256 della password) per i clienti registrati.
- `utente_admin` (PK: id_utente) - Tabella per assegnare privilegi di amministratore.
- `categoria` (PK: id_categoria) - Categorie dei prodotti (Console, Videogiochi, Accessori).
- `piattaforma` (PK: id_piattaforma) - Piattaforme hardware (SNES, PS1, ecc).
- `prodotto` (PK: id_prodotto) - Informazioni sul prodotto, giacenza, iva e prezzi base.
- `immagine` (PK: id_immagine) - Link relativi per le immagini dei prodotti.
- `carrello` (PK: id_carrello) - Contenitore temporaneo per gli acquisti (salvato anche in sessione).
- `voce_carrello` (PK: id_voce) - Righe del carrello collegate ai singoli prodotti.
- `ordine` (PK: id_ordine) - Testata degli ordini completati (data, totale, stato).
- `dettagli_ordine` (PK: id_dettaglio) - Dettagli "congelati" al momento della transazione (prezzo e iva d'acquisto).
- `indirizzo` (PK: id_indirizzo) - Indirizzi di spedizione inseriti in fase di checkout.
- `fattura` (PK: id_fattura) - Riferimenti per la fatturazione (visivamente formattata con media print in CSS).
- `wishlist` (PK composta: id_utente, id_prodotto) - Lista dei desideri asincrona gestita via AJAX.
- Tabelle secondarie/espansioni: `pagamento` (PK: id_pagamento).

## Installazione e Avvio

1. Creare il database locale `ecommerce_db` nel proprio MySQL.
2. Importare i file `DB.sql` per lo schema e `popola_db.sql` per i dati mock.
3. Aprire Eclipse (o IDE simile) e importare il progetto come "Dynamic Web Project".
4. Verificare che il server target sia configurato su Apache Tomcat 9.
5. Inserire le credenziali del proprio DB in `META-INF/context.xml` (username, password).
6. Run on Server -> `http://localhost:8080/Retropia`

## Account di test pre-configurati

Il file popola_db.sql inserisce gia' alcuni utenti nel sistema
**La password per tutti gli account elencati di seguito e':** `Admin123!`

- Amministratore: `admin@retropia.it`
- Cliente test 1: `mario.rossi@email.it`
- Cliente test 2: `luigi.verdi@email.it`
