package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.UtenteDAO;

@WebServlet("/CheckEmail")
public class EmailCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        // Impostiamo il formato di risposta come JSON (richiesto dalla checklist)
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (email != null && !email.trim().isEmpty()) {
            UtenteDAO dao = new UtenteDAO();
            boolean esiste = dao.checkEmailExists(email);
            
            // Restituiamo il JSON finto: {"esiste": true} o {"esiste": false}
            response.getWriter().write("{\"esiste\": " + esiste + "}");
        } else {
            response.getWriter().write("{\"esiste\": false}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
