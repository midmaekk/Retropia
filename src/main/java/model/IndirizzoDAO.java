package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class IndirizzoDAO {

    public int doSave(Indirizzo indirizzo) {
        String query = "INSERT INTO indirizzo (via, citta, cap, id_utente) VALUES (?, ?, ?, ?)";
        int idGenerato = -1;
        
        try (Connection con = ConPool.getConnection();
             PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, indirizzo.getVia());
            ps.setString(2, indirizzo.getCitta());
            ps.setString(3, indirizzo.getCap());
            ps.setInt(4, indirizzo.getIdUtente());
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    idGenerato = rs.getInt(1);
                    indirizzo.setId(idGenerato);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return idGenerato;
    }
}
