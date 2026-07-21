<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("ordini");
    if (ordini == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ordini?action=list");
        return;
    }
    
    // Recupera il filtro per ripopolare l'input
    String filtroCliente = (String) request.getAttribute("filtroCliente");
    String filtroDataDa = (String) request.getAttribute("filtroDataDa");
    String filtroDataA = (String) request.getAttribute("filtroDataA");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini - Admin - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .admin-table th, .admin-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .admin-table th { background-color: #27ae60; color: white; }
        
        .filter-form {
            background-color: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 20px;
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }
        .filter-group { display: flex; flex-direction: column; gap: 5px; width: 220px; }
        .filter-group label { font-weight: bold; font-size: 0.9em; }
        .filter-group input { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        
        .btn-filter { background-color: #2c3e50; color: white; padding: 9px 15px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;}
        .btn-reset { background-color: #95a5a6; color: white; padding: 9px 15px; border: none; border-radius: 4px; text-decoration: none; font-weight: bold; text-align: center;}
        
        .btn-view { background-color: #3498db; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 0.9em; display: inline-block;}
    </style>
</head>
<body style="background-color: #f4f6f9;">

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main style="max-width: 1200px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        
        <h2>Gestione Ordini Clienti</h2>
        
        <% 
            String error = request.getParameter("error");
            if ("notfound".equals(error)) { out.print("<p style='color:red'>Ordine non trovato.</p>"); }
        %>
        
        <!-- Form di Filtraggio -->
        <form action="${pageContext.request.contextPath}/admin/ordini" method="get" class="filter-form">
            <input type="hidden" name="action" value="list">
            
            <div class="filter-group">
                <label for="cliente">Email Cliente</label>
                <input type="text" id="cliente" name="cliente" placeholder="Cerca email..." value="<%= filtroCliente != null ? filtroCliente : "" %>">
            </div>
            
            <div class="filter-group">
                <label for="dataDa">Data Da</label>
                <input type="date" id="dataDa" name="dataDa" value="<%= filtroDataDa != null ? filtroDataDa : "" %>">
            </div>
            
            <div class="filter-group">
                <label for="dataA">Data A</label>
                <input type="date" id="dataA" name="dataA" value="<%= filtroDataA != null ? filtroDataA : "" %>">
            </div>
            
            <button type="submit" class="btn-filter">Applica Filtro</button>
            <a href="${pageContext.request.contextPath}/admin/ordini" class="btn-reset">Azzera</a>
        </form>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>N. Ordine</th>
                    <th>Data</th>
                    <th>Email Cliente</th>
                    <th>Totale</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% if (ordini.isEmpty()) { %>
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 20px;">Nessun ordine trovato con i filtri attuali.</td>
                    </tr>
                <% } else { %>
                    <% for (Ordine o : ordini) { %>
                    <tr>
                        <td><strong>#<%= o.getId() %></strong></td>
                        <td><%= sdf.format(o.getDataOrdine()) %></td>
                        <td><%= o.getEmailUtente() != null ? o.getEmailUtente() : "Utente Rimosso" %></td>
                        <td><strong>&euro; <%= o.getTotale() %></strong></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/ordini?action=view&id=<%= o.getId() %>" class="btn-view">Vedi Dettagli</a>
                        </td>
                    </tr>
                    <% } %>
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
