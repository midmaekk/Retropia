<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Ordine" %>
<%@ page import="model.RigaOrdine" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Ordine ordine = (Ordine) request.getAttribute("ordine");
    if (ordine == null) {
        response.sendRedirect(request.getContextPath() + "/admin/ordini");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dettaglio Ordine #<%= ordine.getId() %> - Admin - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .details-container {
            display: flex;
            gap: 20px;
            margin-bottom: 2rem;
        }
        .details-card {
            flex: 1;
            background: #f9f9f9;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .details-card h3 { margin-top: 0; color: #2c3e50; border-bottom: 2px solid #ddd; padding-bottom: 5px;}
        .details-card p { margin: 8px 0; }
        
        .admin-table { width: 100%; border-collapse: collapse; }
        .admin-table th, .admin-table td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        .admin-table th { background-color: #34495e; color: white; }
    </style>
</head>
<body style="background-color: #f4f6f9;">

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main style="max-width: 900px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2>Dettaglio Ordine #<%= ordine.getId() %></h2>
            <a href="${pageContext.request.contextPath}/admin/ordini" style="color: #2c3e50; font-weight: bold;">← Torna alla lista</a>
        </div>
        
        <div class="details-container">
            <div class="details-card">
                <h3>Informazioni Generali</h3>
                <p><strong>Data Registrazione:</strong> <%= sdf.format(ordine.getDataOrdine()) %></p>
                <p><strong>Totale Pagato:</strong> &euro; <%= ordine.getTotale() %></p>
                <p><strong>Stato Pagamento:</strong> <span style="color: green; font-weight: bold;">Confermato</span></p>
            </div>
            <div class="details-card">
                <h3>Dati Cliente e Spedizione</h3>
                <p><strong>Email Cliente:</strong> <%= ordine.getEmailUtente() != null ? ordine.getEmailUtente() : "Sconosciuta" %></p>
                <p><strong>Indirizzo Spedizione:</strong></p>
                <p style="margin-top: 0;"><%= ordine.getIndirizzoSpedizione() != null ? ordine.getIndirizzoSpedizione() : "Non specificato" %></p>
            </div>
        </div>

        <h3>Prodotti Acquistati</h3>
        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID Prodotto</th>
                    <th>Nome Prodotto</th>
                    <th>Quantità</th>
                    <th>Prezzo Unitario</th>
                    <th>IVA</th>
                    <th>Subtotale</th>
                </tr>
            </thead>
            <tbody>
                <% for (RigaOrdine riga : ordine.getRighe()) { 
                    java.math.BigDecimal sub = riga.getPrezzoAcquisto().multiply(new java.math.BigDecimal(riga.getQuantita()));
                %>
                <tr>
                    <td><%= riga.getIdProdotto() %></td>
                    <td><%= riga.getNomeProdotto() %></td>
                    <td><%= riga.getQuantita() %></td>
                    <td>&euro; <%= riga.getPrezzoAcquisto() %></td>
                    <td><%= riga.getIvaAcquisto() %>%</td>
                    <td><strong>&euro; <%= sub %></strong></td>
                </tr>
                <% } %>
            </tbody>
            <tfoot>
                <tr>
                    <td colspan="5" style="text-align: right; font-weight: bold;">TOTALE ORDINE:</td>
                    <td style="font-weight: bold; font-size: 1.1em; color: #c0392b;">&euro; <%= ordine.getTotale() %></td>
                </tr>
            </tfoot>
        </table>

    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
