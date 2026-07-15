package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.UtenteDAO;

@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confermaPassword = request.getParameter("conferma-password");
        
        // Semplice validazione server-side
        if (nome == null || cognome == null || email == null || password == null || !password.equals(confermaPassword)) {
            response.sendRedirect(request.getContextPath() + "/registrazione.jsp?error=invalid");
            return;
        }

        UtenteDAO dao = new UtenteDAO();
        
        // Verifica se l'email esiste già
        if (dao.checkEmailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/registrazione.jsp?error=exists");
            return;
        }

        Utente u = new Utente();
        u.setNome(nome);
        u.setCognome(cognome);
        u.setEmail(email);
        u.setPasswordHash(password); // N.B. andrebbe hashata

        // Salvataggio nel DB
        try {
            if (dao.doSave(u)) {
                // Autologin dopo la registrazione
                HttpSession session = request.getSession();
                session.setAttribute("utenteLoggato", u);
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/registrazione.jsp?error=db");
            }
        } catch (RuntimeException e) {
            String msg = e.getMessage() != null ? java.net.URLEncoder.encode(e.getMessage(), "UTF-8") : "Errore Sconosciuto";
            response.sendRedirect(request.getContextPath() + "/registrazione.jsp?error=db&msg=" + msg);
        }
    }
}
