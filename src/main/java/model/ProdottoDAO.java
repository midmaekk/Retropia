package model;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    public List<Prodotto> doRetrieveAll(String sort) {
        return doRetrieveAll(sort, -1);
    }

    public List<Prodotto> doRetrieveAll(String sort, int idUtente) {
        return doRetrieveAll(sort, idUtente, null);
    }
    
    public List<Prodotto> doRetrieveAll(String sort, int idUtente, String categoria) {
        return retrieveProdotti(sort, idUtente, true, categoria);
    }
    
    public List<Prodotto> doRetrieveAllAdmin(String sort) {
        return retrieveProdotti(sort, -1, false, null); // tutti i prodotti
    }

    private List<Prodotto> retrieveProdotti(String sort, int idUtente, boolean onlyActive, String categoria) {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT p.*, " +
                       "(SELECT url_immagine FROM immagine i WHERE i.id_prodotto = p.id_prodotto LIMIT 1) AS url_immagine, " +
                       "(SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto) AS wishlist_count ";
                       
        if (idUtente > 0) {
            query += ", (SELECT COUNT(*) FROM wishlist w WHERE w.id_prodotto = p.id_prodotto AND w.id_utente = ?) AS in_wishlist ";
        } else {
            query += ", 0 AS in_wishlist ";
        }
        
        query += "FROM prodotto p ";
        
        // Filtro per categoria (JOIN con la tabella categoria)
        boolean hasCategoria = (categoria != null && !categoria.trim().isEmpty());
        if (hasCategoria) {
            query += "JOIN categoria c ON p.id_categoria = c.id_categoria ";
        }
        
        // Clausola WHERE
        if (onlyActive && hasCategoria) {
            query += "WHERE p.attivo = 1 AND LOWER(c.nome_categoria) LIKE ? ";
        } else if (onlyActive) {
            query += "WHERE p.attivo = 1 ";
        } else if (hasCategoria) {
            query += "WHERE LOWER(c.nome_categoria) LIKE ? ";
        }
        
        if (sort != null) {
            switch (sort) {
                case "price-asc": query += "ORDER BY p.prezzo_base ASC"; break;
                case "price-desc": query += "ORDER BY p.prezzo_base DESC"; break;
                case "relevance":
                default: query += "ORDER BY wishlist_count DESC, p.nome_prodotto ASC"; break;
            }
        } else {
            query += "ORDER BY wishlist_count DESC, p.nome_prodotto ASC";
        }
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
             
            int paramIndex = 1;
            if (idUtente > 0) {
                ps.setInt(paramIndex++, idUtente);
            }
            if (hasCategoria) {
                ps.setString(paramIndex++, "%" + categoria.toLowerCase() + "%");
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    prodotti.add(mapResultSetToProdotto(rs, true));
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
                    return mapResultSetToProdotto(rs, true);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Prodotto> searchByNome(String keyword) {
        List<Prodotto> prodotti = new ArrayList<>();
        String query = "SELECT p.*, " +
                       "(SELECT url_immagine FROM immagine i WHERE i.id_prodotto = p.id_prodotto LIMIT 1) AS url_immagine " +
                       "FROM prodotto p WHERE p.nome_prodotto LIKE ? AND p.attivo = 1 ORDER BY p.nome_prodotto ASC LIMIT 5";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, "%" + keyword + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setId(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome_prodotto"));
                    p.setUrlImmagine(rs.getString("url_immagine"));
                    prodotti.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return prodotti;
    }

    public List<Prodotto> doRetrieveWishlist(int idUtente) {
        List<Prodotto> wishlist = new ArrayList<>();
        String query = "SELECT p.*, "
                     + "(SELECT url_immagine FROM immagine WHERE id_prodotto = p.id_prodotto LIMIT 1) AS url_immagine, "
                     + "(SELECT COUNT(*) FROM wishlist WHERE id_prodotto = p.id_prodotto) AS count_wishlist "
                     + "FROM prodotto p "
                     + "JOIN wishlist w ON p.id_prodotto = w.id_prodotto "
                     + "WHERE w.id_utente = ? AND p.attivo = 1";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Prodotto p = new Prodotto();
                    p.setId(rs.getInt("id_prodotto"));
                    p.setNome(rs.getString("nome_prodotto"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setPrezzo(rs.getBigDecimal("prezzo_base"));
                    p.setQuantitaMagazzino(rs.getInt("quantita_stock"));
                    p.setIva(rs.getBigDecimal("iva"));
                    p.setUrlImmagine(rs.getString("url_immagine"));
                    
                    p.setCondizione(rs.getString("condizione"));
                    p.setAttivo(rs.getInt("attivo") == 1);
                    p.setIdCategoria(rs.getInt("id_categoria"));
                    
                    p.setWishlistCount(rs.getInt("count_wishlist"));
                    p.setInWishlist(true); // Se è qui, è sicuramente nella sua wishlist
                    
                    wishlist.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return wishlist;
    }

    public int[] toggleWishlist(int idProdotto, int idUtente) {
        int[] result = new int[2];
        try (Connection con = ConPool.getConnection()) {
            String checkQuery = "SELECT COUNT(*) FROM wishlist WHERE id_prodotto = ? AND id_utente = ?";
            boolean exists = false;
            try (PreparedStatement psCheck = con.prepareStatement(checkQuery)) {
                psCheck.setInt(1, idProdotto);
                psCheck.setInt(2, idUtente);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) exists = true;
                }
            }
            if (exists) {
                String deleteQuery = "DELETE FROM wishlist WHERE id_prodotto = ? AND id_utente = ?";
                try (PreparedStatement psDel = con.prepareStatement(deleteQuery)) {
                    psDel.setInt(1, idProdotto);
                    psDel.setInt(2, idUtente);
                    psDel.executeUpdate();
                }
                result[0] = 0;
            } else {
                String insertQuery = "INSERT INTO wishlist (id_prodotto, id_utente) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insertQuery)) {
                    psIns.setInt(1, idProdotto);
                    psIns.setInt(2, idUtente);
                    psIns.executeUpdate();
                }
                result[0] = 1;
            }
            String countQuery = "SELECT COUNT(*) FROM wishlist WHERE id_prodotto = ?";
            try (PreparedStatement psCount = con.prepareStatement(countQuery)) {
                psCount.setInt(1, idProdotto);
                try (ResultSet rs = psCount.executeQuery()) {
                    if (rs.next()) result[1] = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    // --- NUOVI METODI CRUD PER L'ADMIN ---
    
    public boolean doSave(Prodotto p, String urlImmagine) {
        String query = "INSERT INTO prodotto (nome_prodotto, descrizione, prezzo_base, quantita_stock, iva, condizione, attivo, id_categoria, id_piattaforma) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = null;
        try {
            con = ConPool.getConnection();
            con.setAutoCommit(false);
            
            int idGenerato = -1;
            try (PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, p.getNome());
                ps.setString(2, p.getDescrizione());
                ps.setBigDecimal(3, p.getPrezzo());
                ps.setInt(4, p.getQuantitaMagazzino());
                ps.setBigDecimal(5, p.getIva());
                ps.setString(6, p.getCondizione() != null ? p.getCondizione() : "Nuovo");
                ps.setInt(7, p.isAttivo() ? 1 : 0);
                if (p.getIdCategoria() > 0) {
                    ps.setInt(8, p.getIdCategoria());
                } else {
                    ps.setNull(8, java.sql.Types.INTEGER);
                }
                ps.setNull(9, java.sql.Types.INTEGER); // Piattaforma
                
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGenerato = rs.getInt(1);
                        p.setId(idGenerato);
                    }
                }
            }
            
            if (idGenerato > 0 && urlImmagine != null && !urlImmagine.isEmpty()) {
                String imgQuery = "INSERT INTO immagine (url_immagine, id_prodotto) VALUES (?, ?)";
                try (PreparedStatement psImg = con.prepareStatement(imgQuery)) {
                    psImg.setString(1, urlImmagine);
                    psImg.setInt(2, idGenerato);
                    psImg.executeUpdate();
                }
            }
            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean doUpdate(Prodotto p, String urlImmagine) {
        String query = "UPDATE prodotto SET nome_prodotto=?, descrizione=?, prezzo_base=?, quantita_stock=?, iva=?, condizione=?, attivo=?, id_categoria=? WHERE id_prodotto=?";
        Connection con = null;
        try {
            con = ConPool.getConnection();
            con.setAutoCommit(false);
            
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setString(1, p.getNome());
                ps.setString(2, p.getDescrizione());
                ps.setBigDecimal(3, p.getPrezzo());
                ps.setInt(4, p.getQuantitaMagazzino());
                ps.setBigDecimal(5, p.getIva());
                ps.setString(6, p.getCondizione() != null ? p.getCondizione() : "Nuovo");
                ps.setInt(7, p.isAttivo() ? 1 : 0);
                if (p.getIdCategoria() > 0) {
                    ps.setInt(8, p.getIdCategoria());
                } else {
                    ps.setNull(8, java.sql.Types.INTEGER);
                }
                ps.setInt(9, p.getId());
                ps.executeUpdate();
            }
            
            // Se c'è una nuova immagine, sovrascriviamo le precedenti
            if (urlImmagine != null && !urlImmagine.isEmpty()) {
                String delImg = "DELETE FROM immagine WHERE id_prodotto = ?";
                try (PreparedStatement psDel = con.prepareStatement(delImg)) {
                    psDel.setInt(1, p.getId());
                    psDel.executeUpdate();
                }
                
                String insImg = "INSERT INTO immagine (url_immagine, id_prodotto) VALUES (?, ?)";
                try (PreparedStatement psIns = con.prepareStatement(insImg)) {
                    psIns.setString(1, urlImmagine);
                    psIns.setInt(2, p.getId());
                    psIns.executeUpdate();
                }
            }
            
            con.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean doDeleteLogico(int id) {
        String query = "UPDATE prodotto SET attivo = 0 WHERE id_prodotto = ?";
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Helper Method per mappare i ResultSet in oggetti Prodotto.
    private Prodotto mapResultSetToProdotto(ResultSet rs, boolean complete) throws SQLException {
        Prodotto p = new Prodotto();
        p.setId(rs.getInt("id_prodotto"));
        p.setNome(rs.getString("nome_prodotto"));
        p.setDescrizione(rs.getString("descrizione"));
        p.setPrezzo(rs.getBigDecimal("prezzo_base"));
        p.setQuantitaMagazzino(rs.getInt("quantita_stock"));
        p.setIva(rs.getBigDecimal("iva"));
        
        // Verifica se le colonne aggiunte o opzionali esistono (invece di usare eccezioni, 
        // per sicurezza nel caso in cui il DB non sia stato ancora aggiornato).
        try { p.setAttivo(rs.getInt("attivo") > 0); } catch(SQLException ex) {}
        try { p.setCondizione(rs.getString("condizione")); } catch(SQLException ex) {}
        
        if (complete) {
            try { p.setUrlImmagine(rs.getString("url_immagine")); } catch (SQLException ex) {}
            try { p.setWishlistCount(rs.getInt("wishlist_count")); } catch (SQLException ex) {}
            try { p.setInWishlist(rs.getInt("in_wishlist") > 0); } catch (SQLException ex) {}
        }
        
        return p;
    }
}
