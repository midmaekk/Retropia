package control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Ordine;
import model.OrdineDAO;
import model.Utente;

/**
 * Servlet che recupera i dati di un ordine e li passa alla fattura.jsp.
 * L'accesso e' protetto da AuthFilter (/Fattura).
 * Verifica inoltre che l'ordine appartenga all'utente loggato (sicurezza a doppio strato).
 */
@WebServlet("/Fattura")
public class FatturaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        // Doppia protezione: AuthFilter dovrebbe gia' bloccare, ma meglio verificare
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Recupero e validazione del parametro idOrdine
        String idParam = request.getParameter("idOrdine");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametro idOrdine mancante.");
            return;
        }

        int idOrdine;
        try {
            idOrdine = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametro idOrdine non valido.");
            return;
        }

        // Recupero l'ordine verificando che appartenga all'utente loggato
        OrdineDAO ordineDAO = new OrdineDAO();
        Ordine ordine = ordineDAO.doRetrieveById(idOrdine, utente.getId());

        if (ordine == null) {
            // L'ordine non esiste oppure non appartiene a questo utente
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Non sei autorizzato a visualizzare questa fattura.");
            return;
        }

        // Passo i dati alla JSP e faccio il forward
        request.setAttribute("ordine", ordine);
        request.setAttribute("utente", utente);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/fattura.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
