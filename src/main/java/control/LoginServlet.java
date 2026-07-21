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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forward interno per mostrare la JSP nascosta in WEB-INF
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Hashing della password per confrontarla con quella nel DB
        String hash = SecurityUtils.hashPassword(password);
        
        UtenteDAO utenteDAO = new UtenteDAO();
        Utente utente = utenteDAO.doRetrieveByEmailAndPassword(email, hash);
        
        if (utente != null) {
            // Login riuscito! Creiamo (o recuperiamo) la sessione
            HttpSession session = request.getSession();
            // Salviamo l'utente intero nella sessione
            session.setAttribute("utenteLoggato", utente);
            
            // Reindirizziamo in base al ruolo
            if (utente.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard"); // L'admin va nella dashboard (il filtro ora lo fa passare)
            } else {
                response.sendRedirect(request.getContextPath() + "/Home"); // Il cliente va in Home
            }
        } else {
            // Login fallito (email o password errati)
            request.setAttribute("erroreLogin", "Email o password errati.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
