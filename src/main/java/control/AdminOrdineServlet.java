package control;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Ordine;
import model.OrdineDAO;
import model.Utente;

@WebServlet("/admin/ordini")
public class AdminOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String action = request.getParameter("action");
        OrdineDAO dao = new OrdineDAO();

        try {
            if (action == null || action.equalsIgnoreCase("list")) {
                // Legge i parametri di filtro se presenti
                String emailCliente = request.getParameter("cliente");
                String dataDa = request.getParameter("dataDa");
                String dataA = request.getParameter("dataA");
                
                // Recupera gli ordini filtrati
                List<Ordine> ordini = dao.doRetrieveAllAdmin(emailCliente, dataDa, dataA);
                
                // Salva filtri e lista nella request per ripopolare la vista
                request.setAttribute("ordini", ordini);
                request.setAttribute("filtroCliente", emailCliente);
                request.setAttribute("filtroDataDa", dataDa);
                request.setAttribute("filtroDataA", dataA);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/ordini.jsp");
                dispatcher.forward(request, response);
                
            } else if (action.equalsIgnoreCase("view")) {
                // Visualizza il dettaglio dell'ordine
                int id = Integer.parseInt(request.getParameter("id"));
                Ordine ordine = dao.doRetrieveByIdAdmin(id);
                
                if (ordine != null) {
                    request.setAttribute("ordine", ordine);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/ordine_dettaglio.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/ordini?error=notfound");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/ordini");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/ordini?error=invalid_id");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirige al metodo GET per evitare form resubmission
        doGet(request, response);
    }
}
