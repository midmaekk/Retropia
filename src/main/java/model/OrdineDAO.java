package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    /**
     * Salva un ordine nel DB in modo transazionale.
     * Inserisce prima in 'ordine' e poi in 'dettagli_ordine' per ogni riga.
     */
    public boolean doSave(Ordine ordine, int idIndirizzo) {
        String queryOrdine = "INSERT INTO ordine (totale_ordine, id_utente, id_indirizzo) VALUES (?, ?, ?)";
        String queryDettagli = "INSERT INTO dettagli_ordine (quantita, prezzo_vendita, iva_applicata, id_ordine, id_prodotto) VALUES (?, ?, ?, ?, ?)";
        String queryStock = "UPDATE prodotto SET quantita_stock = quantita_stock - ? WHERE id_prodotto = ?";
        
        Connection con = null;
        try {
            con = ConPool.getConnection();
            // Inizio Transazione
            con.setAutoCommit(false);
            
            // 1. Salva l'ordine
            int idOrdineGenerato = -1;
            try (PreparedStatement psOrdine = con.prepareStatement(queryOrdine, Statement.RETURN_GENERATED_KEYS)) {
                psOrdine.setBigDecimal(1, ordine.getTotale());
                psOrdine.setInt(2, ordine.getIdUtente());
                psOrdine.setInt(3, idIndirizzo);
                
                psOrdine.executeUpdate();
                
                try (ResultSet rs = psOrdine.getGeneratedKeys()) {
                    if (rs.next()) {
                        idOrdineGenerato = rs.getInt(1);
                        ordine.setId(idOrdineGenerato);
                    }
                }
            }
            
            if (idOrdineGenerato == -1) {
                con.rollback();
                return false;
            }
            
            // 2. Salva le singole righe (dettagli) e decrementa lo stock
            try (PreparedStatement psDettagli = con.prepareStatement(queryDettagli);
                 PreparedStatement psStock = con.prepareStatement(queryStock)) {
                 
                for (RigaOrdine riga : ordine.getRighe()) {
                    // Dettagli Ordine
                    psDettagli.setInt(1, riga.getQuantita());
                    psDettagli.setBigDecimal(2, riga.getPrezzoAcquisto()); // Prezzo bloccato
                    psDettagli.setBigDecimal(3, riga.getIvaAcquisto());    // IVA bloccata
                    psDettagli.setInt(4, idOrdineGenerato);
                    psDettagli.setInt(5, riga.getIdProdotto());
                    psDettagli.addBatch();
                    
                    // Decremento Stock
                    psStock.setInt(1, riga.getQuantita());
                    psStock.setInt(2, riga.getIdProdotto());
                    psStock.addBatch();
                }
                psDettagli.executeBatch();
                psStock.executeBatch();
            }
            
            // Conferma tutto (Commit)
            con.commit();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback(); // Se qualcosa va male, annulla tutto
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Recupera lo storico degli ordini di un cliente (inclusi i dettagli).
     */
    public List<Ordine> doRetrieveByUser(int idUtente) {
        List<Ordine> ordini = new ArrayList<>();
        String query = "SELECT * FROM ordine WHERE id_utente = ? ORDER BY data_ordine DESC";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setId(rs.getInt("id_ordine"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setTotale(rs.getBigDecimal("totale_ordine"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    
                    // Recuperiamo anche i dettagli (le righe)
                    ordine.setRighe(getRigheByOrdineId(ordine.getId(), con));
                    
                    ordini.add(ordine);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ordini;
    }
    
    /**
     * Recupera un singolo ordine per ID, verificando che appartenga all'utente specificato.
     * Usato dalla FatturaServlet per impedire che un utente veda la fattura di un altro.
     * Recupera anche l'indirizzo di spedizione tramite JOIN con la tabella indirizzo.
     */
    public Ordine doRetrieveById(int idOrdine, int idUtente) {
        String query = "SELECT o.*, CONCAT(i.via, ', ', i.citta, ' ', i.cap) AS indirizzo_completo " +
                       "FROM ordine o " +
                       "LEFT JOIN indirizzo i ON o.id_indirizzo = i.id_indirizzo " +
                       "WHERE o.id_ordine = ? AND o.id_utente = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idOrdine);
            ps.setInt(2, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setId(rs.getInt("id_ordine"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setTotale(rs.getBigDecimal("totale_ordine"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_completo"));
                    ordine.setRighe(getRigheByOrdineId(ordine.getId(), con));
                    return ordine;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Recupera un singolo ordine per ID senza filtro sull'utente.
     * Riservato all'area admin.
     */
    public Ordine doRetrieveByIdAdmin(int idOrdine) {
        String query = "SELECT o.*, CONCAT(i.via, ', ', i.citta, ' ', i.cap) AS indirizzo_completo " +
                       "FROM ordine o " +
                       "LEFT JOIN indirizzo i ON o.id_indirizzo = i.id_indirizzo " +
                       "WHERE o.id_ordine = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idOrdine);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setId(rs.getInt("id_ordine"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setTotale(rs.getBigDecimal("totale_ordine"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_completo"));
                    ordine.setRighe(getRigheByOrdineId(ordine.getId(), con));
                    return ordine;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<RigaOrdine> getRigheByOrdineId(int idOrdine, Connection con) throws SQLException {
        List<RigaOrdine> righe = new ArrayList<>();
        // Facciamo una JOIN per recuperare anche il nome del prodotto che all'epoca era stato acquistato
        String query = "SELECT d.*, p.nome_prodotto FROM dettagli_ordine d JOIN prodotto p ON d.id_prodotto = p.id_prodotto WHERE id_ordine = ?";
        
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, idOrdine);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RigaOrdine riga = new RigaOrdine();
                    riga.setIdOrdine(idOrdine);
                    riga.setIdProdotto(rs.getInt("id_prodotto"));
                    riga.setNomeProdotto(rs.getString("nome_prodotto"));
                    riga.setQuantita(rs.getInt("quantita"));
                    riga.setPrezzoAcquisto(rs.getBigDecimal("prezzo_vendita"));
                    riga.setIvaAcquisto(rs.getBigDecimal("iva_applicata"));
                    
                    righe.add(riga);
                }
            }
        }
        return righe;
    }
}
