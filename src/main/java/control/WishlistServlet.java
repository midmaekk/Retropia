package control;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.ProdottoDAO;
import model.Utente;

@WebServlet("/Wishlist")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        Utente utente = (Utente) request.getSession().getAttribute("utenteLoggato");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (utente == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Non autorizzato\"}");
            return;
        }
        
        try {
            int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
            ProdottoDAO dao = new ProdottoDAO();
            int[] result = dao.toggleWishlist(idProdotto, utente.getId());
            
            boolean inWishlist = (result[0] == 1);
            int newCount = result[1];
            
            // Ritorniamo il JSON "a mano" senza librerie esterne
            String json = String.format("{\"inWishlist\": %b, \"wishlistCount\": %d}", inWishlist, newCount);
            response.getWriter().write(json);
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"ID Prodotto non valido\"}");
        }
    }
}
