<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prodotto" %>
<%
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    // Se la pagina è stata aperta direttamente senza passare per la Servlet, si passa l'id se c'è, altrimenti si va al catalogo.
    if (prodotto == null) {
        String id = request.getParameter("id");
        if (id != null) {
            response.sendRedirect(request.getContextPath() + "/DettaglioProdotto?id=" + id);
        } else {
            response.sendRedirect(request.getContextPath() + "/Catalogo");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Dettaglio Prodotto</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="scripts/main.js?v=3" defer></script>
</head>
<body>

    <jsp:include page="fragments/header.jsp" />
    <jsp:include page="fragments/navbar.jsp" />

    <main>
        <div class="breadcrumb">
            <a href="index.jsp">Home</a> > <a href="catalogo.jsp">Catalogo</a> > <span>Dettaglio Prodotto</span>
        </div>

        <section class="product-detail">
            <div class="product-image">
                <img src="<%= prodotto.getUrlImmagine() != null ? prodotto.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= prodotto.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/400x300?text=Retropia'">
            </div>
            
            <div class="product-info">
                <h1><%= prodotto.getNome() %></h1>
                <p class="product-id">Codice Prodotto: #<%= String.format("%04d", prodotto.getId()) %></p>
                <p class="price">€<%= String.format("%.2f", prodotto.getPrezzo()) %> <span class="iva">(IVA Inclusa <%= prodotto.getIva() %>%)</span></p>
                
                <div class="product-description">
                    <h3>Descrizione</h3>
                    <p><%= prodotto.getDescrizione() != null ? prodotto.getDescrizione() : "Nessuna descrizione disponibile." %></p>
                </div>

                <div class="purchase-options" style="display: flex; flex-direction: column; align-items: flex-start; gap: 15px; width: 100%;">
                    <div class="wishlist-detail-container" style="display: flex; align-items: center; gap: 10px;">
                        <button class="wishlist-btn <%= prodotto.isInWishlist() ? "active" : "" %>" onclick="toggleWishlist(<%= prodotto.getId() %>, this)" style="position: static; padding: 0 15px; width: auto; height: 45px; display: inline-flex; border-radius: 25px; border: 1px solid rgba(0,0,0,0.1);">
                            <span class="heart-icon" style="font-size: 1.4rem;"><%= prodotto.isInWishlist() ? "♥" : "♡" %></span>
                            <span class="wishlist-count" style="margin-left: 5px;"><%= prodotto.getWishlistCount() %></span>
                        </button>
                        <span style="font-size: 0.95rem; color: #7f8c8d; font-weight: 500;">Aggiungi alla tua Wishlist</span>
                    </div>
                    
                    <form action="CarrelloServlet" method="post" style="display: flex; flex-direction: column; align-items: flex-start; gap: 15px;">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="<%= prodotto.getId() %>">
                        <div class="quantity-selector">
                            <label for="quantity">Quantità:</label>
                            <input type="number" id="quantity" name="quantita" value="1" min="1" max="<%= prodotto.getQuantitaMagazzino() > 0 ? prodotto.getQuantitaMagazzino() : 1 %>">
                        </div>
                        <div>
                            <% if (prodotto.getQuantitaMagazzino() > 0) { %>
                                <button type="submit" class="btn-add-cart">Aggiungi al Carrello</button>
                            <% } else { %>
                                <button type="button" class="btn-add-cart" style="background-color: #95a5a6; cursor: not-allowed;" disabled>Esaurito</button>
                            <% } %>
                        </div>
                    </form>
                </div>

                <div class="extra-info">
                    <p><strong>Disponibilità:</strong> 
                        <% if (prodotto.getQuantitaMagazzino() > 0) { %>
                            <span class="stock-status" style="color: #2ecc71;">Disponibile (<%= prodotto.getQuantitaMagazzino() %> in magazzino)</span>
                        <% } else { %>
                            <span class="stock-status" style="color: #e74c3c;">Non Disponibile</span>
                        <% } %>
                    </p>
                    <p><strong>Spedizione:</strong> Consegna stimata in 3-5 giorni lavorativi.</p>
                </div>
            </div>
        </section>

        <section class="related-products">
            <h2>Prodotti Correlati</h2>
            <div class="product-grid">
                <% 
                    java.util.List<Prodotto> correlati = (java.util.List<Prodotto>) request.getAttribute("correlati");
                    if (correlati != null) {
                        for (Prodotto pCorrelato : correlati) {
                %>
                <div class="product-card">
                    <img src="<%= pCorrelato.getUrlImmagine() != null ? pCorrelato.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= pCorrelato.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/200x150?text=Retropia'">
                    <h3><%= pCorrelato.getNome() %></h3>
                    <div class="price-wishlist-container" style="display: flex; justify-content: space-between; align-items: center; padding: 0 25px 25px;">
                        <p class="price" style="padding: 0; margin: 0;">€<%= String.format("%.2f", pCorrelato.getPrezzo()) %></p>
                        <button class="wishlist-btn <%= pCorrelato.isInWishlist() ? "active" : "" %>" onclick="toggleWishlist(<%= pCorrelato.getId() %>, this)" style="position: static; margin-left: auto;">
                            <span class="heart-icon"><%= pCorrelato.isInWishlist() ? "♥" : "♡" %></span>
                            <span class="wishlist-count"><%= pCorrelato.getWishlistCount() %></span>
                        </button>
                    </div>
                    <div style="display:flex; gap:10px; margin-top:10px;">
                        <a href="prodotto.jsp?id=<%= pCorrelato.getId() %>" class="btn">Dettagli</a>
                    </div>
                </div>
                <%      }
                    }
                %>
            </div>
        </section>
    </main>

    <jsp:include page="fragments/footer.jsp" />

</body>
</html>
