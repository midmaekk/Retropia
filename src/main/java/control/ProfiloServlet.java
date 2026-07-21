package control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.UtenteDAO;
import utils.SecurityUtils;

/**
 * Servlet per la pagina profilo: mostra i dati anagrafici (GET)
 * e gestisce l aggiornamento dei dati / cambio password (POST).
 */
@WebServlet("/Profilo")
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** GET: mostra la pagina profilo con i dati della sessione. */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/WEB-INF/views/login.jsp");
            return;
        }

        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/profilo.jsp");
        rd.forward(request, response);
    }

    /** POST: aggiorna dati anagrafici OPPURE cambia password, in base al parametro "action". */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Utente utente = (session != null) ? (Utente) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        UtenteDAO dao = new UtenteDAO();

        if ("updateDati".equals(action)) {
            // --- Aggiornamento dati anagrafici ---
            String nome    = request.getParameter("nome");
            String cognome = request.getParameter("cognome");
            String email   = request.getParameter("email");

            // Validazione minimale server-side
            if (nome == null || nome.trim().isEmpty() ||
                cognome == null || cognome.trim().isEmpty() ||
                email == null || !email.contains("@")) {
                request.setAttribute("erroreDati", "Dati non validi. Controlla i campi e riprova.");
                doGet(request, response);
                return;
            }

            // Se l email cambia, verifica che non sia gia in uso da un altro utente
            if (!email.equalsIgnoreCase(utente.getEmail()) && dao.checkEmailExists(email)) {
                request.setAttribute("erroreDati", "L email inserita e' gia' in uso da un altro account.");
                doGet(request, response);
                return;
            }

            utente.setNome(nome.trim());
            utente.setCognome(cognome.trim());
            utente.setEmail(email.trim());

            boolean ok = dao.doUpdate(utente);
            if (ok) {
                // Aggiorna anche il bean in sessione
                session.setAttribute("utenteLoggato", utente);
                request.setAttribute("successoDati", "Dati aggiornati con successo!");
            } else {
                request.setAttribute("erroreDati", "Errore durante il salvataggio. Riprova.");
            }

        } else if ("updatePassword".equals(action)) {
            // --- Cambio password ---
            String vecchiaPassword = request.getParameter("vecchiaPassword");
            String nuovaPassword   = request.getParameter("nuovaPassword");
            String confermaPassword = request.getParameter("confermaPassword");

            if (vecchiaPassword == null || nuovaPassword == null || confermaPassword == null
                    || nuovaPassword.trim().isEmpty()) {
                request.setAttribute("errorePassword", "Compila tutti i campi.");
                doGet(request, response);
                return;
            }

            if (nuovaPassword.length() < 8) {
                request.setAttribute("errorePassword", "La nuova password deve essere di almeno 8 caratteri.");
                doGet(request, response);
                return;
            }

            if (!nuovaPassword.equals(confermaPassword)) {
                request.setAttribute("errorePassword", "Le due password non coincidono.");
                doGet(request, response);
                return;
            }

            String vecchioHash = SecurityUtils.hashPassword(vecchiaPassword);
            String nuovoHash   = SecurityUtils.hashPassword(nuovaPassword);

            boolean ok = dao.doUpdatePassword(utente.getId(), vecchioHash, nuovoHash);
            if (ok) {
                utente.setPasswordHash(nuovoHash);
                session.setAttribute("utenteLoggato", utente);
                request.setAttribute("successoPassword", "Password aggiornata con successo!");
            } else {
                request.setAttribute("errorePassword", "La password attuale non e' corretta.");
            }
        }

        // In entrambi i casi ri-mostriamo la pagina profilo
        doGet(request, response);
    }
}
