<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%
    // Se la lista dei prodotti è null significa che l'utente ha aperto direttamente la pagina .jsp 
    // bypassando la Servlet. Per rispettare l'MVC, lo reindirizziamo alla Servlet!
    if (request.getAttribute("prodotti") == null) {
        response.sendRedirect(request.getContextPath() + "/Catalogo");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Catalogo</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js?v=4" defer></script>
</head>
<body>

    <jsp:include page="fragments/header.jsp" />
    <jsp:include page="fragments/navbar.jsp" />

    <main>
        <section class="catalog-header">
            <div class="catalog-title">
                <h1>Catalogo <span>Prodotti</span></h1>
                <p>Mostrando <%= ((java.util.List<model.Prodotto>) request.getAttribute("prodotti")).size() %> tesori del passato</p>
            </div>
            <div class="catalog-sorting">
                <form action="Catalogo" method="GET" style="margin: 0;">
                    <label for="sort">Ordina per:</label>
                    <select id="sort" name="sort" onchange="this.form.submit()">
                        <option value="relevance" <%= "relevance".equals(request.getParameter("sort")) ? "selected" : "" %>>Rilevanza</option>
                        <option value="price-asc" <%= "price-asc".equals(request.getParameter("sort")) ? "selected" : "" %>>Prezzo: Crescente</option>
                        <option value="price-desc" <%= "price-desc".equals(request.getParameter("sort")) ? "selected" : "" %>>Prezzo: Decrescente</option>
                        <option value="newest" <%= "newest".equals(request.getParameter("sort")) ? "selected" : "" %>>Più recenti</option>
                    </select>
                </form>
            </div>
        </section>

        <section class="catalog-content">
            <aside class="filters">
                <div class="filter-header">
                    <h3>Filtra per</h3>
                    <button type="button" class="btn-reset">Reset</button>
                </div>
                
                <div class="filter-group">
                    <h4>Categoria</h4>
                    <ul class="custom-checkboxes">
                        <li>
                            <input type="checkbox" id="cat-console">
                            <label for="cat-console">Console <span>(24)</span></label>
                        </li>
                        <li>
                            <input type="checkbox" id="cat-giochi">
                            <label for="cat-giochi">Videogiochi <span>(86)</span></label>
                        </li>
                        <li>
                            <input type="checkbox" id="cat-accessori">
                            <label for="cat-accessori">Accessori <span>(40)</span></label>
                        </li>
                    </ul>
                </div>

                <div class="filter-group">
                    <h4>Prezzo Massimo</h4>
                    <div class="range-container">
                        <input type="range" min="0" max="1000" step="50" value="500" class="styled-range">
                        <div class="range-values">
                            <span>€0</span>
                            <span class="current-val">€500</span>
                        </div>
                    </div>
                </div>

                <div class="filter-group">
                    <h4>Piattaforma</h4>
                    <ul class="custom-checkboxes">
                        <li><input type="checkbox" id="plat-nintendo"> <label for="plat-nintendo">Nintendo</label></li>
                        <li><input type="checkbox" id="plat-sega"> <label for="plat-sega">SEGA</label></li>
                        <li><input type="checkbox" id="plat-sony"> <label for="plat-sony">Sony</label></li>
                    </ul>
                </div>
            </aside>

            <div class="product-grid">
                <% 
                    // Recupero la lista di prodotti salvata dalla Servlet
                    List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("prodotti");
                    
                    if (prodotti != null && !prodotti.isEmpty()) {
                        for (Prodotto p : prodotti) { 
                %>
                <div class="product-card">
                    <!-- Simuliamo le immagini: in futuro potrebbero derivare da un campo DB o da un percorso formattato col nome -->
                    <img src="<%= p.getUrlImmagine() != null ? p.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= p.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/200x150?text=Retropia'">
                    <h3><%= p.getNome() %></h3>
                    <div class="price-wishlist-container" style="display: flex; justify-content: space-between; align-items: center; padding: 0 25px 25px;">
                        <p class="price" style="padding: 0; margin: 0;">€<%= String.format("%.2f", p.getPrezzo()) %></p>
                        <button class="wishlist-btn <%= p.isInWishlist() ? "active" : "" %>" onclick="toggleWishlist(<%= p.getId() %>, this)" style="position: static; margin-left: auto;">
                            <span class="heart-icon"><%= p.isInWishlist() ? "♥" : "♡" %></span>
                            <span class="wishlist-count"><%= p.getWishlistCount() %></span>
                        </button>
                    </div>
                    <div style="display:flex; gap:10px; margin-top:10px;">
                        <a href="prodotto.jsp?id=<%= p.getId() %>" class="btn">Dettagli</a>
                        <form action="CarrelloServlet" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="id" value="<%= p.getId() %>">
                            <input type="hidden" name="quantita" value="1">
                            <% if (p.getQuantitaMagazzino() > 0) { %>
                                <button type="submit" class="btn" style="background-color:#2ecc71;">Aggiungi</button>
                            <% } else { %>
                                <button type="button" class="btn" style="background-color:#95a5a6; cursor:not-allowed;" disabled>Esaurito</button>
                            <% } %>
                        </form>
                    </div>
                </div>
                <% 
                        } 
                    } else { 
                %>
                    <p>Nessun prodotto disponibile nel catalogo.</p>
                <% 
                    } 
                %>
            </div>
        </section>
    </main>

    <jsp:include page="fragments/footer.jsp" />

</body>
</html>
