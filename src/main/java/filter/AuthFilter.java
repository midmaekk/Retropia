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
 * reindirizzando al login se l'utente non e' autenticato.
 */
@WebFilter(urlPatterns = {
    "/CheckoutServlet",
    "/StoricoOrdiniServlet",
    "/Fattura",
    "/Profilo"
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
            req.getSession(true).setAttribute("erroreLog", "Devi effettuare l'accesso per visualizzare questa pagina.");
            res.sendRedirect(req.getContextPath() + "/LoginServlet");
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {
    }
}
