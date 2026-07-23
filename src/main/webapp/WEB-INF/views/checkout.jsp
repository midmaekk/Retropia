<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Carrello" %>
<%
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        // L'utente deve essere loggato per fare il checkout
        response.sendRedirect("LoginServlet");
        return;
    }
    
    Carrello carrello = (Carrello) session.getAttribute("carrello");
    if (carrello == null || carrello.getElementi().isEmpty()) {
        // Se non ha niente nel carrello, torna indietro
        response.sendRedirect("CarrelloServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Checkout</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js" defer></script>
    <script src="scripts/validation.js" defer></script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <section class="auth-container" style="max-width: 800px; margin: 2rem auto;">
            <h1>Checkout</h1>
            <p>Completa il tuo ordine inserendo l'indirizzo di spedizione.</p>

            <form action="${pageContext.request.contextPath}/CheckoutServlet" method="POST" class="auth-form" style="margin-top: 1rem;" id="checkoutForm">
                <fieldset style="border: 1px solid #ccc; padding: 1rem; margin-bottom: 1rem; border-radius: 8px;">
                    <legend style="padding: 0 10px; font-weight: bold; color: var(--primary-color);">Dati di Spedizione</legend>
                    
                    <div class="form-group">
                        <label for="via">Indirizzo (Via e Civico) *</label>
                        <input type="text" id="via" name="via" required placeholder="Es. Via Roma, 1">
                        <span id="viaError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                    </div>
                    
                    <div class="form-group" style="display: flex; gap: 1rem;">
                        <div style="flex: 2;">
                            <label for="citta">Città *</label>
                            <input type="text" id="citta" name="citta" required placeholder="Es. Milano">
                            <span id="cittaError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                        </div>
                        <div style="flex: 1;">
                            <label for="cap">CAP *</label>
                            <input type="text" id="cap" name="cap" required placeholder="Es. 20100">
                            <span id="capError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                        </div>
                    </div>
                </fieldset>

                <fieldset style="border: 1px solid #ccc; padding: 1rem; margin-bottom: 1rem; border-radius: 8px;">
                    <legend style="padding: 0 10px; font-weight: bold; color: var(--primary-color);">Metodo di Pagamento</legend>
                    <div class="form-group">
                        <label>Seleziona un metodo (Fittizio)</label>
                        <select name="pagamento" required style="width: 100%; padding: 0.8rem; border-radius: 4px; border: 1px solid #ccc;">
                            <option value="carta">Carta di Credito / Debito</option>
                            <option value="paypal">PayPal</option>
                            <option value="bonifico">Bonifico Bancario</option>
                        </select>
                    </div>
                </fieldset>

                <div class="cart-summary" style="margin-bottom: 1.5rem; background-color: var(--light-bg); padding: 1rem; border-radius: 8px;">
                    <h3 style="margin-bottom: 1rem; color: var(--dark-text);">Riepilogo Ordine</h3>
                    <div style="display: flex; justify-content: space-between; font-size: 1.2rem; font-weight: bold;">
                        <span>Totale da Pagare:</span>
                        <span style="color: var(--primary-color);">€<%= String.format("%.2f", carrello.getPrezzoTotale()) %></span>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; font-size: 1.1rem; padding: 1rem;">Conferma Ordine e Paga</button>
            </form>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
