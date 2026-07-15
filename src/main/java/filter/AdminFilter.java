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
 * Filtro di sicurezza per l'Area Amministratore.
 * Intercetta tutte le richieste indirizzate alla cartella /admin/
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    public AdminFilter() {
    }

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        boolean isLoggedInAsAdmin = false;
        
        // Controlliamo se esiste una sessione e se c'è un utente loggato con permessi di amministratore
        if (session != null) {
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            if (utente != null && utente.isAdmin()) {
                isLoggedInAsAdmin = true;
            }
        }
        
        if (isLoggedInAsAdmin) {
            // L'utente è autorizzato! Lasciamo proseguire la richiesta verso la pagina desiderata
            chain.doFilter(request, response);
        } else {
            // L'utente NON è autorizzato. Lo reindirizziamo alla pagina di errore 403 (Accesso Negato)
            // in alternativa si potrebbe mandare alla login.jsp
            res.sendRedirect(req.getContextPath() + "/error403.jsp");
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {
    }
}
