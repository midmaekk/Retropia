package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConPool {
    
    // Configurazione del Database
    private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_db?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "Admin123!";
    
    public static Connection getConnection() throws SQLException {
        try {
            // Assicuriamoci che il driver sia caricato (necessario su alcune versioni vecchie di Tomcat)
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("DRIVER MYSQL NON TROVATO! " + e.getMessage());
        }
        
        // Creiamo la connessione usando le librerie standard di Java, senza dipendere da quelle di Tomcat!
        return DriverManager.getConnection(URL, USER, PASS);
    }
}