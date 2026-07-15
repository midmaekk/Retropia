package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UtenteDAO {

    public Utente doRetrieveByEmailAndPassword(String email, String password) {
        // Facciamo una JOIN tra utente e utente_registrato (dove si trova la password)
        String query = "SELECT u.id_utente, u.nome, u.cognome, u.email, u.tipo_utente, ur.password_hash " +
                       "FROM utente u " +
                       "JOIN utente_registrato ur ON u.id_utente = ur.id_utente " +
                       "WHERE u.email = ? AND ur.password_hash = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, password); // N.B. In futuro qui dovrai hashare la password in SHA-256
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Utente u = new Utente();
                    u.setId(rs.getInt("id_utente"));
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    
                    // Il ruolo ora è basato sull'ENUM tipo_utente
                    String tipo = rs.getString("tipo_utente");
                    u.setAdmin(tipo != null && tipo.equalsIgnoreCase("admin"));
                    
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Credenziali errate o errore DB
    }

    public boolean checkEmailExists(String email) {
        if (email == null) return false;
        
        String query = "SELECT id_utente FROM utente WHERE email = ?";
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Se c'è almeno un risultato, l'email esiste
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean doSave(Utente u) {
        String queryUtente = "INSERT INTO utente (nome, cognome, email) VALUES (?, ?, ?)";
        String queryRegistrato = "INSERT INTO utente_registrato (id_utente, password_hash) VALUES (?, ?)";
        
        Connection con = null;
        try {
            con = ConPool.getConnection();
            con.setAutoCommit(false);
            
            try (PreparedStatement psUtente = con.prepareStatement(queryUtente, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psUtente.setString(1, u.getNome());
                psUtente.setString(2, u.getCognome());
                psUtente.setString(3, u.getEmail());
                int rows = psUtente.executeUpdate();
                
                if (rows > 0) {
                    try (ResultSet rs = psUtente.getGeneratedKeys()) {
                        if (rs.next()) {
                            int idUtente = rs.getInt(1);
                            u.setId(idUtente);
                            
                            try (PreparedStatement psRegistrato = con.prepareStatement(queryRegistrato)) {
                                psRegistrato.setInt(1, idUtente);
                                psRegistrato.setString(2, u.getPasswordHash());
                                psRegistrato.executeUpdate();
                            }
                            
                            con.commit();
                            return true;
                        }
                    }
                }
            }
            con.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            throw new RuntimeException("DB_ERROR:" + e.getMessage());
        } finally {
            if (con != null) {
                try { 
                    con.setAutoCommit(true);
                    con.close(); 
                } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
        return false;
    }
}
