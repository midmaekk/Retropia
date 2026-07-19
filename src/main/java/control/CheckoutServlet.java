package control;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Carrello;
import model.CartItem;
import model.Indirizzo;
import model.IndirizzoDAO;
import model.Ordine;
import model.OrdineDAO;
import model.RigaOrdine;
import model.Utente;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("checkout.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        Carrello carrello = (Carrello) session.getAttribute("carrello");

        // Controllo validità
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        if (carrello == null || carrello.getElementi().isEmpty()) {
            response.sendRedirect("carrello.jsp");
            return;
        }

        // Recupero parametri dal form
        String via = request.getParameter("via");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");

        // 1. Salvo l'indirizzo nel database
        Indirizzo indirizzo = new Indirizzo();
        indirizzo.setVia(via);
        indirizzo.setCitta(citta);
        indirizzo.setCap(cap);
        indirizzo.setIdUtente(utente.getId());

        IndirizzoDAO indirizzoDAO = new IndirizzoDAO();
        int idIndirizzo = indirizzoDAO.doSave(indirizzo);

        if (idIndirizzo == -1) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel salvataggio dell'indirizzo");
            return;
        }

        // 2. Costruisco l'ordine in memoria
        Ordine ordine = new Ordine();
        ordine.setIdUtente(utente.getId());
        ordine.setTotale(carrello.getPrezzoTotale()); // Il totale è già pre-calcolato dal carrello

        // 3. Converto gli articoli del carrello in Righe Ordine (congelando prezzo e IVA)
        for (CartItem item : carrello.getElementi()) {
            RigaOrdine riga = new RigaOrdine();
            riga.setIdProdotto(item.getProdotto().getId());
            riga.setQuantita(item.getQuantita());
            
            // I prezzi a schermo includono già l'IVA, ma noi la salviamo esplicitamente come aliquota 22
            riga.setPrezzoAcquisto(item.getProdotto().getPrezzo()); 
            riga.setIvaAcquisto(new BigDecimal("22.00")); // IVA al 22% fissa (da scorporare commercialmente, ma noi la memorizziamo a fini storici)
            
            ordine.addRiga(riga);
        }

        // 4. Salvo l'ordine e i dettagli nel database (transazionalmente)
        OrdineDAO ordineDAO = new OrdineDAO();
        boolean success = ordineDAO.doSave(ordine, idIndirizzo);

        if (success) {
            // Svuoto il carrello
            carrello.svuota();
            // Reindirizzo alla pagina di conferma passando l'ID dell'ordine (come parametro get o in sessione)
            response.sendRedirect("conferma_ordine.jsp?idOrdine=" + ordine.getId());
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel salvataggio dell'ordine");
        }
    }
}
