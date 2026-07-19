package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;

/**
 * Filtro di autenticazione per le pagine riservate ai clienti loggati.
 * Intercetta le richieste verso il checkout e lo storico ordini,
 * reindirizzando a login.jsp se l'utente non e' autenticato.
 */
@WebFilter(urlPatterns = {
    "/checkout.jsp",
    "/CheckoutServlet",
    "/storico.jsp",
    "/StoricoOrdiniServlet",
    "/Fattura",
    "/Profilo",
    "/profilo.jsp"
})
public class AuthFilter implements Filter {

    public AuthFilter() {
    }

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = false;

        // Controlliamo se esiste una sessione con un utente autenticato
        if (session != null) {
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente != null) {
                isLoggedIn = true;
            }
        }

        if (isLoggedIn) {
            // L'utente e' autenticato: lasciamo proseguire la richiesta
            chain.doFilter(request, response);
        } else {
            // L'utente non e' loggato: reindirizziamo al login
            // Salviamo l'URL originale nella sessione cosi' dopo il login possiamo tornare qui
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("redirectAfterLogin", req.getRequestURI());
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {
    }
}
