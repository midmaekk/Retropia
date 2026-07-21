package control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Prodotto;
import model.ProdottoDAO;

@WebServlet("/DettaglioProdotto")
public class ProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
        
        // Recupero utente loggato per wishlist
        model.Utente utente = (model.Utente) request.getSession().getAttribute("utenteLoggato");
        int idUtente = (utente != null) ? utente.getId() : -1;
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        Prodotto p = prodottoDAO.doRetrieveById(id, idUtente);
                
                if (p != null) {
                    // Recupero anche una lista di "prodotti correlati" per la sezione in basso
                    java.util.List<Prodotto> tuttiIProdotti = prodottoDAO.doRetrieveAll(null, idUtente);
                    // Rimuoviamo il prodotto corrente dalla lista
                    tuttiIProdotti.removeIf(prod -> prod.getId() == p.getId());
                    // Prendiamo al massimo i primi 3
                    java.util.List<Prodotto> correlati = tuttiIProdotti.size() > 3 ? tuttiIProdotti.subList(0, 3) : tuttiIProdotti;
                    
                    // Prodotto trovato, lo passiamo alla JSP
                    request.setAttribute("prodotto", p);
                    request.setAttribute("correlati", correlati);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/prodotto.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Formato ID non valido
            }
        }
        
        // Se arriviamo qui, l'ID non c'era o non è valido o il prodotto non esiste.
        // Reindirizziamo l'utente al catalogo (o a una pagina di errore 404)
        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
