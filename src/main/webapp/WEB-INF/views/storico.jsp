<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Ordine" %>
<%@ page import="model.RigaOrdine" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("ordini");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Storico Ordini</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js" defer></script>
    <style>
        .order-card {
            background-color: var(--light-bg);
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #ddd;
            padding-bottom: 1rem;
            margin-bottom: 1rem;
            font-weight: bold;
        }
        .order-details table {
            width: 100%;
            border-collapse: collapse;
        }
        .order-details th, .order-details td {
            text-align: left;
            padding: 0.8rem;
            border-bottom: 1px solid #eee;
        }
        .order-details th {
            background-color: #f9f9f9;
            color: var(--dark-text);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <section style="max-width: 900px; margin: 2rem auto;">
            <h1>I Miei Ordini</h1>
            <p style="margin-bottom: 2rem;">Storico completo degli acquisti effettuati sul tuo account.</p>

            <% if (ordini == null || ordini.isEmpty()) { %>
                <div class="order-card" style="text-align: center;">
                    <p>Non hai ancora effettuato nessun ordine.</p>
                    <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary" style="margin-top: 1rem; display: inline-block;">Inizia lo Shopping</a>
                </div>
            <% } else { 
                for (Ordine ordine : ordini) {
            %>
                <div class="order-card">
                    <div class="order-header">
                        <span>Ordine #<%= ordine.getId() %> del <%= sdf.format(ordine.getDataOrdine()) %></span>
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <span style="color: var(--primary-color);">Totale: €<%= String.format("%.2f", ordine.getTotale()) %></span>
                            <a href="Fattura?idOrdine=<%= ordine.getId() %>"
                               style="font-size: 0.85rem; color: #555; text-decoration: none; border: 1px solid #ccc; padding: 0.3rem 0.7rem; border-radius: 4px; white-space: nowrap;"
                               title="Visualizza e stampa la fattura di questo ordine">
                               🖨️ Stampa Fattura
                            </a>
                        </div>
                    </div>
                    <div class="order-details">
                        <table>
                            <thead>
                                <tr>
                                    <th>Prodotto</th>
                                    <th>Prezzo Unitario (IVA incl.)</th>
                                    <th>Quantità</th>
                                    <th>Subtotale</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (RigaOrdine riga : ordine.getRighe()) { %>
                                    <tr>
                                        <td><%= riga.getNomeProdotto() != null ? riga.getNomeProdotto() : "Prodotto #" + riga.getIdProdotto() %></td>
                                        <td>€<%= String.format("%.2f", riga.getPrezzoAcquisto()) %></td>
                                        <td><%= riga.getQuantita() %></td>
                                        <td>€<%= String.format("%.2f", riga.getPrezzoAcquisto().multiply(new java.math.BigDecimal(riga.getQuantita()))) %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% 
                }
            } %>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
