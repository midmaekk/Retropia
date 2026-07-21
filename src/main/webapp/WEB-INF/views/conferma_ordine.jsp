<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    String idOrdine = request.getParameter("idOrdine");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Ordine Confermato</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js" defer></script>
    <style>
        .success-container {
            text-align: center;
            max-width: 600px;
            margin: 4rem auto;
            padding: 3rem;
            background-color: var(--light-bg);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .success-icon {
            font-size: 5rem;
            color: #2ecc71;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <section class="success-container">
            <div class="success-icon">✔️</div>
            <h1>Ordine Confermato!</h1>
            <p style="font-size: 1.2rem; margin-top: 1rem;">Grazie per il tuo acquisto, <strong><%= utente.getNome() %></strong>.</p>
            
            <% if (idOrdine != null) { %>
                <p style="margin-top: 1rem; color: var(--dark-text);">
                    Il tuo numero d'ordine è: <strong>#<%= idOrdine %></strong>
                </p>
            <% } %>
            
            <p style="margin-top: 1rem;">Riceverai a breve un'email con i dettagli della spedizione.</p>

            <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <a href="StoricoOrdiniServlet" class="btn-primary" style="text-decoration: none;">Vedi i tuoi Ordini</a>
                <% if (idOrdine != null) { %>
                    <a href="Fattura?idOrdine=<%= idOrdine %>" class="btn-secondary" style="text-decoration: none;">🖨️ Scarica Fattura</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/Catalogo" class="btn-secondary" style="text-decoration: none;">Torna al Catalogo</a>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
