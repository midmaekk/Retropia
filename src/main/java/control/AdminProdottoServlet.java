package control;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.Prodotto;
import model.ProdottoDAO;
import model.Utente;

@WebServlet("/admin/prodotti")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AdminProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Directory dove verranno salvate le immagini (relativa al webapp root)
    private static final String UPLOAD_DIR = "images";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String action = request.getParameter("action");
        ProdottoDAO dao = new ProdottoDAO();

        try {
            if (action == null || action.equalsIgnoreCase("list")) {
                // Recupera tutti i prodotti, anche quelli nascosti
                List<Prodotto> prodotti = dao.doRetrieveAllAdmin(null);
                request.setAttribute("prodotti", prodotti);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/prodotti.jsp");
                dispatcher.forward(request, response);
                
            } else if (action.equalsIgnoreCase("add")) {
                // Mostra il form vuoto
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/prodotto_form.jsp");
                dispatcher.forward(request, response);
                
            } else if (action.equalsIgnoreCase("edit")) {
                // Mostra il form precompilato
                int id = Integer.parseInt(request.getParameter("id"));
                Prodotto p = dao.doRetrieveById(id);
                if (p != null) {
                    request.setAttribute("prodotto", p);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/admin/prodotto_form.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=notfound");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/prodotti");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=invalid_id");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String action = request.getParameter("action");
        ProdottoDAO dao = new ProdottoDAO();

        try {
            if (action != null && action.equalsIgnoreCase("delete")) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = dao.doDeleteLogico(id);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=delete_failed");
                }
                return;
            }
            
            // Per INSERT e UPDATE, leggiamo i campi del form
            String nome = request.getParameter("nome");
            String descrizione = request.getParameter("descrizione");
            BigDecimal prezzo = new BigDecimal(request.getParameter("prezzo"));
            int quantita = Integer.parseInt(request.getParameter("quantita"));
            BigDecimal iva = new BigDecimal(request.getParameter("iva"));
            String condizione = request.getParameter("condizione");
            boolean attivo = request.getParameter("attivo") != null; // checkbox

            Prodotto p = new Prodotto();
            p.setNome(nome);
            p.setDescrizione(descrizione);
            p.setPrezzo(prezzo);
            p.setQuantitaMagazzino(quantita);
            p.setIva(iva);
            p.setCondizione(condizione);
            p.setAttivo(attivo);
            try {
                String catStr = request.getParameter("categoria");
                if (catStr != null && !catStr.isEmpty()) {
                    p.setIdCategoria(Integer.parseInt(catStr));
                }
            } catch (Exception e) {}

            // Gestione Upload Immagine
            String urlImmagine = null;
            Part filePart = request.getPart("immagine");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // Percorso assoluto sul server dove salvare il file
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                
                // Crea la cartella se non esiste
                File uploadDirFile = new File(uploadFilePath);
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs();
                }
                
                // Salva il file
                filePart.write(uploadFilePath + File.separator + fileName);
                
                // Salva il path relativo nel DB (es. "images/nomefile.jpg")
                // Sostituiamo gli slash backslashati di windows con slash normali per il web
                urlImmagine = UPLOAD_DIR + "/" + fileName;
            }

            if (action != null && action.equalsIgnoreCase("insert")) {
                boolean success = dao.doSave(p, urlImmagine);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=inserted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=insert_failed");
                }
            } else if (action != null && action.equalsIgnoreCase("update")) {
                int id = Integer.parseInt(request.getParameter("id"));
                p.setId(id);
                
                // Se non carichiamo una nuova immagine, cerchiamo di mantenere la vecchia
                if (urlImmagine == null) {
                    Prodotto oldP = dao.doRetrieveById(id);
                    if (oldP != null) {
                        urlImmagine = oldP.getUrlImmagine();
                    }
                }
                
                boolean success = dao.doUpdate(p, urlImmagine);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=update_failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/prodotti?error=exception");
        }
    }
}
