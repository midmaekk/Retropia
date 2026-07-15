import java.sql.Connection;
import model.ConPool;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("Tentativo di connessione al database...");
        try {
            Connection con = ConPool.getConnection();
            if (con != null) {
                System.out.println("Connessione stabilita con successo!");
                con.close();
            } else {
                System.out.println("La connessione e null!");
            }
        } catch (Exception e) {
            System.out.println("ERRORE DURANTE LA CONNESSIONE:");
            e.printStackTrace();
        }
    }
}
