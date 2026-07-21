<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%
    List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
    if (prodotti == null) {
        response.sendRedirect(request.getContextPath() + "/admin/prodotti?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Prodotti - Admin - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .admin-table th, .admin-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .admin-table th {
            background-color: #2c3e50;
            color: white;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 4px;
            color: white;
            font-size: 0.9em;
            font-weight: bold;
        }
        .badge-active { background-color: #27ae60; }
        .badge-hidden { background-color: #e74c3c; }
        .action-btns {
            display: flex;
            gap: 10px;
        }
        .btn-edit { background-color: #f39c12; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px;}
        .btn-hide { background-color: #c0392b; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;}
        .btn-add { background-color: #2980b9; color: white; padding: 10px 15px; text-decoration: none; border-radius: 4px; font-weight: bold;}
    </style>
</head>
<body style="background-color: #f4f6f9;">

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main style="max-width: 1200px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2>Gestione Catalogo Prodotti</h2>
            <a href="${pageContext.request.contextPath}/admin/prodotti?action=add" class="btn-add">+ Nuovo Prodotto</a>
        </div>
        
        <% 
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if ("inserted".equals(msg)) { out.print("<p style='color:green'>Prodotto inserito con successo!</p>"); }
            if ("updated".equals(msg)) { out.print("<p style='color:green'>Prodotto aggiornato con successo!</p>"); }
            if ("deleted".equals(msg)) { out.print("<p style='color:green'>Prodotto nascosto con successo!</p>"); }
            if ("insert_failed".equals(error)) { out.print("<p style='color:red'>Errore durante l'inserimento.</p>"); }
            if ("update_failed".equals(error)) { out.print("<p style='color:red'>Errore durante l'aggiornamento.</p>"); }
            if ("delete_failed".equals(error)) { out.print("<p style='color:red'>Errore durante il nascondimento.</p>"); }
        %>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Immagine</th>
                    <th>Nome</th>
                    <th>Prezzo</th>
                    <th>Magazzino</th>
                    <th>Stato</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% for (Prodotto p : prodotti) { %>
                <tr>
                    <td><%= p.getId() %></td>
                    <td>
                        <% if(p.getUrlImmagine() != null) { %>
                            <img src="${pageContext.request.contextPath}/<%= p.getUrlImmagine() %>" alt="img" width="50">
                        <% } else { %>
                            N/A
                        <% } %>
                    </td>
                    <td><%= p.getNome() %></td>
                    <td>&euro; <%= p.getPrezzo() %></td>
                    <td><%= p.getQuantitaMagazzino() %></td>
                    <td>
                        <% if(p.isAttivo()) { %>
                            <span class="badge badge-active">Attivo</span>
                        <% } else { %>
                            <span class="badge badge-hidden">Nascosto</span>
                        <% } %>
                    </td>
                    <td>
                        <div class="action-btns">
                            <a href="${pageContext.request.contextPath}/admin/prodotti?action=edit&id=<%= p.getId() %>" class="btn-edit">Modifica</a>
                            <% if(p.isAttivo()) { %>
                            <form action="${pageContext.request.contextPath}/admin/prodotti" method="post" onsubmit="return confirm('Sei sicuro di voler nascondere questo prodotto dal catalogo?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= p.getId() %>">
                                <button type="submit" class="btn-hide">Nascondi</button>
                            </form>
                            <% } %>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div style="margin-top: 2rem;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: #2c3e50;">← Torna al Pannello di Controllo</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
