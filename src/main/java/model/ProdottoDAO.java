package model;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    public List<Prodotto> doRetrieveAll(String sort) {
        return doRetrieveAll(sort, -1);
    }

    public List<Prodotto> doRetrieveAll(String sort, int idUtente) {
        List<Prodotto> prodotti = new ArrayList<>();
        // Usa una subquery per prendere la prima immagine associata al prodotto (se esiste)
        String query = "SELECT p.*, " +
                       "(SELECT url_immagine FROM immagine i WHERE i.id_prodotto = p.id_prodotto LIMIT 1) AS url_immagine, " +
                       "(SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto) AS wishlist_count ";
                       
        if (idUtente > 0) {
            query += ", (SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto AND w.id_utente = ?) AS in_wishlist ";
        } else {
            query += ", 0 AS in_wishlist ";
        }
        
        query += "FROM prodotto p";
        
        if (sort != null) {
            switch (sort) {
                case "price-asc":
                    query += " ORDER BY p.prezzo_base ASC";
                    break;
                case "price-desc":
                    query += " ORDER BY p.prezzo_base DESC";
                    break;
                case "newest":
                    query += " ORDER BY p.id_prodotto DESC";
                    break;
                case "relevance":
                default:
                    query += " ORDER BY p.nome_prodotto ASC";
                    break;
            }
        } else {
            query += " ORDER BY p.nome_prodotto ASC";
        }
        
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            if (idUtente > 0) {
                ps.setInt(1, idUtente);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setId(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome_prodotto"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setPrezzo(rs.getBigDecimal("prezzo_base"));
                    p.setQuantitaMagazzino(rs.getInt("quantita_stock"));
                    p.setIva(new BigDecimal("22.00")); // Costante visto che non c'è nel DB attuale
                    p.setUrlImmagine(rs.getString("url_immagine"));
                    p.setWishlistCount(rs.getInt("wishlist_count"));
                    p.setInWishlist(rs.getInt("in_wishlist") > 0);
                    prodotti.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return prodotti;
    }

    public Prodotto doRetrieveById(int id) {
        return doRetrieveById(id, -1);
    }

    public Prodotto doRetrieveById(int id, int idUtente) {
        String query = "SELECT p.*, " +
                       "(SELECT url_immagine FROM immagine i WHERE i.id_prodotto = p.id_prodotto LIMIT 1) AS url_immagine, " +
                       "(SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto) AS wishlist_count ";
                       
        if (idUtente > 0) {
            query += ", (SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto AND w.id_utente = ?) AS in_wishlist ";
        } else {
            query += ", 0 AS in_wishlist ";
        }
        
        query += "FROM prodotto p WHERE p.id_prodotto = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            int paramIndex = 1;
            if (idUtente > 0) {
                ps.setInt(paramIndex++, idUtente);
            }
            ps.setInt(paramIndex, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setId(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome_prodotto"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setPrezzo(rs.getBigDecimal("prezzo_base"));
                    p.setQuantitaMagazzino(rs.getInt("quantita_stock"));
                    p.setIva(new BigDecimal("22.00"));
                    p.setUrlImmagine(rs.getString("url_immagine"));
                    p.setWishlistCount(rs.getInt("wishlist_count"));
                    p.setInWishlist(rs.getInt("in_wishlist") > 0);
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Aggiunge o rimuove un prodotto dalla wishlist.
    // Ritorna un array int[] dove l'indice 0 è il nuovo stato (1 se aggiunto, 0 se rimosso) 
    // e l'indice 1 è il nuovo conteggio totale dei wishlist per quel prodotto.
    public int[] toggleWishlist(int idProdotto, int idUtente) {
        int[] result = new int[2];
        try (Connection con = ConPool.getConnection()) {
            
            // 1. Controlliamo se esiste già
            String checkQuery = "SELECT COUNT(*) FROM wishlist WHERE id_prodotto = ? AND id_utente = ?";
            boolean exists = false;
            try (PreparedStatement psCheck = con.prepareStatement(checkQuery)) {
                psCheck.setInt(1, idProdotto);
                psCheck.setInt(2, idUtente);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        exists = true;
                    }
                }
            }
            
            // 2. Facciamo il toggle
            if (exists) {
                // Rimuoviamo
                String deleteQuery = "DELETE FROM wishlist WHERE id_prodotto = ? AND id_utente = ?";
                try (PreparedStatement psDel = con.prepareStatement(deleteQuery)) {
                    psDel.setInt(1, idProdotto);
                    psDel.setInt(2, idUtente);
                    psDel.executeUpdate();
                }
                result[0] = 0; // rimosso
            } else {
                // Inseriamo
                String insertQuery = "INSERT INTO wishlist (id_prodotto, id_utente) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insertQuery)) {
                    psIns.setInt(1, idProdotto);
                    psIns.setInt(2, idUtente);
                    psIns.executeUpdate();
                }
                result[0] = 1; // aggiunto
            }
            
            // 3. Contiamo il totale
            String countQuery = "SELECT COUNT(*) FROM wishlist WHERE id_prodotto = ?";
            try (PreparedStatement psCount = con.prepareStatement(countQuery)) {
                psCount.setInt(1, idProdotto);
                try (ResultSet rs = psCount.executeQuery()) {
                    if (rs.next()) {
                        result[1] = rs.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
