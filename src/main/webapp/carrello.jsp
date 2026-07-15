<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Carrello" %>
<%@ page import="model.CartItem" %>
<%
    // Recupero il carrello dalla sessione, se non c'è, creo un finto carrello vuoto per evitare NullPointerException visivi
    Carrello carrello = (Carrello) session.getAttribute("carrello");
    if (carrello == null) {
        carrello = new Carrello();
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Il Tuo Carrello</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="scripts/main.js" defer></script>
</head>
<body>

    <jsp:include page="fragments/header.jsp" />
    <jsp:include page="fragments/navbar.jsp" />

    <main>
        <section class="cart-container">
            <h1>Il Mio Carrello</h1>

            <div class="cart-wrapper">
                <div class="cart-items">
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th>Prodotto</th>
                                <th>Prezzo</th>
                                <th>Quantità</th>
                                <th>Totale</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (carrello.getElementi().isEmpty()) {
                            %>
                                <tr><td colspan="5" style="text-align: center; padding: 2rem;">Il tuo carrello è vuoto.</td></tr>
                            <%
                                } else {
                                    for (CartItem item : carrello.getElementi()) {
                            %>
                            <tr>
                                <td class="product-cell" data-label="Prodotto">
                                    <img src="images/placeholder.jpg" alt="<%= item.getProdotto().getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/100x75?text=Retropia'">
                                    <div>
                                        <p class="product-name"><%= item.getProdotto().getNome() %></p>
                                    </div>
                                </td>
                                <td data-label="Prezzo">€<%= String.format("%.2f", item.getProdotto().getPrezzo()) %></td>
                                <td data-label="Quantità">
                                    <form action="CarrelloServlet" method="post" style="display:inline-flex; align-items:center; gap: 5px;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="<%= item.getProdotto().getId() %>">
                                        <input type="number" name="quantita" value="<%= item.getQuantita() %>" min="1" class="qty-input" onchange="this.form.submit()">
                                    </form>
                                </td>
                                <td data-label="Totale" class="item-total">€<%= String.format("%.2f", item.getTotale()) %></td>
                                <td>
                                    <a href="CarrelloServlet?action=remove&id=<%= item.getProdotto().getId() %>" class="btn-remove" style="text-decoration:none;">&times;</a>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    
                    <div class="cart-actions">
                        <a href="catalogo.jsp" class="btn-secondary">Continua lo Shopping</a>
                        <a href="CarrelloServlet?action=empty" class="btn-danger" style="text-decoration:none; display:inline-block; text-align:center;">Svuota Carrello</a>
                    </div>
                </div>

                <aside class="cart-summary">
                    <h3>Riepilogo Ordine</h3>
                    <div class="summary-line">
                        <span>Subtotale</span>
                        <span>€<%= String.format("%.2f", carrello.getPrezzoTotale()) %></span>
                    </div>
                    <div class="summary-line">
                        <span>Spedizione</span>
                        <span>€0.00</span>
                    </div>
                    <div class="summary-line total">
                        <span>Totale</span>
                        <span>€<%= String.format("%.2f", carrello.getPrezzoTotale()) %></span>
                    </div>
                    <p class="iva-notice">Tutti i prezzi includono l'IVA.</p>
                    <button class="btn-checkout">Procedi al Checkout</button>
                </aside>
            </div>
        </section>
    </main>

    <jsp:include page="fragments/footer.jsp" />

</body>
</html>
