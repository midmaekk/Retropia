package control;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Prodotto;
import model.ProdottoDAO;

@WebServlet("/RicercaAjax")
public class RicercaAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (query != null && query.trim().length() > 0) {
            ProdottoDAO dao = new ProdottoDAO();
            List<Prodotto> risultati = dao.searchByNome(query.trim());
            
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (int i = 0; i < risultati.size(); i++) {
                Prodotto p = risultati.get(i);
                json.append("{");
                json.append("\"id\": ").append(p.getId()).append(",");
                // Escape quotes in name just in case
                String nomeEscaped = p.getNome().replace("\"", "\\\"");
                json.append("\"nome\": \"").append(nomeEscaped).append("\",");
                String img = p.getUrlImmagine() != null ? p.getUrlImmagine() : "images/placeholder.jpg";
                json.append("\"immagine\": \"").append(img).append("\"");
                json.append("}");
                if (i < risultati.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            
            response.getWriter().write(json.toString());
        } else {
            response.getWriter().write("[]");
        }
    }
}
