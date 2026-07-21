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
import model.Utente;

@WebServlet("/WishlistPage")
public class WishlistPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Utente utente = (Utente) request.getSession().getAttribute("utenteLoggato");
        
        // Controllo se l'utente è loggato
        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        ProdottoDAO dao = new ProdottoDAO();
        List<Prodotto> wishlist = dao.doRetrieveWishlist(utente.getId());
        
        request.setAttribute("wishlist", wishlist);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/wishlist.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
