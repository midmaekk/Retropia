package control;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Prodotto;
import model.ProdottoDAO;

@WebServlet("/Catalogo")
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Instanzio il DAO
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        // 2. Recupero il parametro di ordinamento (se presente)
        String sort = request.getParameter("sort");
        
        // 3. Recupero l'utente loggato per la wishlist
        model.Utente utente = (model.Utente) request.getSession().getAttribute("utenteLoggato");
        int idUtente = (utente != null) ? utente.getId() : -1;
        
        // 4. Recupero i prodotti ordinati
        List<Prodotto> catalogo = prodottoDAO.doRetrieveAll(sort, idUtente);
        
        // 3. Salvo la lista nella "request" per renderla disponibile alla JSP
        request.setAttribute("prodotti", catalogo);
        
        // 4. Faccio un forward alla pagina JSP del catalogo
        RequestDispatcher dispatcher = request.getRequestDispatcher("/catalogo.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
