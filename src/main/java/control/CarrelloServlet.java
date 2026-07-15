package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Carrello;
import model.Prodotto;
import model.ProdottoDAO;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        
        // Se il carrello non esiste in sessione, ne creo uno nuovo
        if (carrello == null) {
            carrello = new Carrello();
            session.setAttribute("carrello", carrello);
        }

        String action = request.getParameter("action");

        if (action != null) {
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            try {
                if (action.equals("add")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    int quantita = 1; // Default
                    if(request.getParameter("quantita") != null) {
                    	quantita = Integer.parseInt(request.getParameter("quantita"));
                    }
                    
                    Prodotto p = prodottoDAO.doRetrieveById(id);
                    if (p != null) {
                        carrello.aggiungiProdotto(p, quantita);
                    }
                } 
                else if (action.equals("remove")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    carrello.rimuoviProdotto(id);
                } 
                else if (action.equals("update")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    int quantita = Integer.parseInt(request.getParameter("quantita"));
                    carrello.setQuantita(id, quantita);
                } 
                else if (action.equals("empty")) {
                    carrello.svuota();
                }
            } catch (NumberFormatException e) {
                // In caso di parametri invalidi, ignoriamo l'azione
            }
        }

        // Reindirizziamo sempre alla pagina del carrello dopo un'azione
        // (Uso sendRedirect per evitare che l'utente ricaricando la pagina ripeta l'azione)
        response.sendRedirect(request.getContextPath() + "/carrello.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
