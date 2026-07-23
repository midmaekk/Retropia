package control;

import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.RequestDispatcher;
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
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        String action = request.getParameter("action");
        if ("conferma".equalsIgnoreCase(action)) {
            if (utente == null) {
                response.sendRedirect(request.getContextPath() + "/LoginServlet");
                return;
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/conferma_ordine.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Controllo autenticazione per accedere al checkout
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        Carrello carrello = (Carrello) session.getAttribute("carrello");
        if (carrello == null || carrello.getElementi().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CarrelloServlet");
            return;
        }

        // Inoltro alla pagina di checkout protetta in WEB-INF/views/
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/checkout.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        Carrello carrello = (Carrello) session.getAttribute("carrello");

        // Controllo validità
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        if (carrello == null || carrello.getElementi().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CarrelloServlet");
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
        String metodoParam = request.getParameter("pagamento");
        String metodoPagamento = "Carta di Credito";
        if ("paypal".equalsIgnoreCase(metodoParam)) {
            metodoPagamento = "PayPal";
        } else if ("bonifico".equalsIgnoreCase(metodoParam)) {
            metodoPagamento = "Bonifico Bancario";
        } else if ("carta".equalsIgnoreCase(metodoParam)) {
            metodoPagamento = "Carta di Credito / Debito";
        } else if (metodoParam != null && !metodoParam.trim().isEmpty()) {
            metodoPagamento = metodoParam.trim();
        }

        Ordine ordine = new Ordine();
        ordine.setIdUtente(utente.getId());
        ordine.setTotale(carrello.getPrezzoTotale());
        ordine.setMetodoPagamento(metodoPagamento);

        // 3. Converto gli articoli del carrello in Righe Ordine (congelando prezzo e IVA)
        for (CartItem item : carrello.getElementi()) {
            RigaOrdine riga = new RigaOrdine();
            riga.setIdProdotto(item.getProdotto().getId());
            riga.setQuantita(item.getQuantita());
            riga.setPrezzoAcquisto(item.getProdotto().getPrezzo()); 
            riga.setIvaAcquisto(new BigDecimal("22.00"));
            
            ordine.addRiga(riga);
        }

        // 4. Salvo l'ordine e i dettagli nel database (transazionalmente)
        OrdineDAO ordineDAO = new OrdineDAO();
        boolean success = ordineDAO.doSave(ordine, idIndirizzo);

        if (success) {
            // Svuoto il carrello
            carrello.svuota();
            // Reindirizzo alla Servlet per mostrare la conferma dell'ordine
            response.sendRedirect(request.getContextPath() + "/CheckoutServlet?action=conferma&idOrdine=" + ordine.getId());
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore nel salvataggio dell'ordine");
        }
    }
}
