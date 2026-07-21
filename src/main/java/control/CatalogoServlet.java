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
        
        // 2. Recupero il parametro di ordinamento e di categoria (se presenti)
        String sort = request.getParameter("sort");
        // Accetto sia "cat" (dalla homepage) che "category" (dalla navbar)
        String categoria = request.getParameter("cat");
        if (categoria == null) {
            categoria = request.getParameter("category");
        }
        
        // 3. Recupero l'utente loggato per la wishlist
        model.Utente utente = (model.Utente) request.getSession().getAttribute("utenteLoggato");
        int idUtente = (utente != null) ? utente.getId() : -1;
        
        // 4. Recupero i prodotti filtrati per categoria e ordinati
        List<Prodotto> catalogo = prodottoDAO.doRetrieveAll(sort, idUtente, categoria);
        
        // 5. Salvo la lista e il filtro nella request per la JSP
        request.setAttribute("prodotti", catalogo);
        request.setAttribute("categoriaAttiva", categoria);
        
        // 6. Faccio un forward alla pagina JSP del catalogo
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/catalogo.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
