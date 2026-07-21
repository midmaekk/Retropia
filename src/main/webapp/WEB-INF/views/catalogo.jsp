<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%
    if (request.getAttribute("prodotti") == null) {
        response.sendRedirect(request.getContextPath() + "/Catalogo");
        return;
    }
    String categoriaAttiva = (String) request.getAttribute("categoriaAttiva");
    String titoloPagina = "Tutti i Prodotti";
    if ("console".equalsIgnoreCase(categoriaAttiva)) titoloPagina = "Console";
    else if ("giochi".equalsIgnoreCase(categoriaAttiva)) titoloPagina = "Videogiochi";
    else if ("accessori".equalsIgnoreCase(categoriaAttiva)) titoloPagina = "Accessori";
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

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <section class="catalog-header">
            <div class="catalog-title">
                <h1><%= titoloPagina %> <span>Retropia</span></h1>
                <p>Mostrando <%= ((java.util.List<model.Prodotto>) request.getAttribute("prodotti")).size() %> prodotti</p>
            </div>
            <div class="catalog-sorting">
                <form action="${pageContext.request.contextPath}/Catalogo" method="GET" style="margin: 0;">
                    <% if (categoriaAttiva != null) { %>
                        <input type="hidden" name="cat" value="<%= categoriaAttiva %>">
                    <% } %>
                    <label for="sort">Ordina per:</label>
                    <select id="sort" name="sort" onchange="this.form.submit()">
                        <option value="relevance" <%= "relevance".equals(request.getParameter("sort")) ? "selected" : "" %>>Rilevanza</option>
                        <option value="price-asc" <%= "price-asc".equals(request.getParameter("sort")) ? "selected" : "" %>>Prezzo: Crescente</option>
                        <option value="price-desc" <%= "price-desc".equals(request.getParameter("sort")) ? "selected" : "" %>>Prezzo: Decrescente</option>

                    </select>
                </form>
            </div>
        </section>

        <section class="catalog-content">
            <aside class="filters">
                <div class="filter-header">
                    <h3>Filtra per</h3>
                </div>
                
                <div class="filter-group">
                    <h4>Categoria</h4>
                    <ul class="custom-checkboxes">
                        <li>
                            <a href="${pageContext.request.contextPath}/Catalogo" style="text-decoration:none; color: inherit; <%= (categoriaAttiva == null) ? "font-weight:bold;" : "" %>">Tutti</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/Catalogo?cat=console" style="text-decoration:none; color: inherit; <%= "console".equalsIgnoreCase(categoriaAttiva) ? "font-weight:bold;" : "" %>">Console</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/Catalogo?cat=giochi" style="text-decoration:none; color: inherit; <%= "giochi".equalsIgnoreCase(categoriaAttiva) ? "font-weight:bold;" : "" %>">Videogiochi</a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/Catalogo?cat=accessori" style="text-decoration:none; color: inherit; <%= "accessori".equalsIgnoreCase(categoriaAttiva) ? "font-weight:bold;" : "" %>">Accessori</a>
                        </li>
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
                    <img src="<%= p.getUrlImmagine() != null ? p.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= p.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/200x150?text=Retropia'">
                    <h3 style="flex-grow: 1;"><%= p.getNome() %></h3>
                    <div class="price-wishlist-container" style="display: flex; justify-content: space-between; align-items: center; padding: 0 25px 15px;">
                        <p class="price" style="padding: 0; margin: 0;">€<%= String.format("%.2f", p.getPrezzo()) %></p>
                        <button class="wishlist-btn <%= p.isInWishlist() ? "active" : "" %>" onclick="toggleWishlist(<%= p.getId() %>, this)" style="position: static; margin-left: auto; width: auto; padding: 0 12px; border-radius: 20px;">
                            <span class="heart-icon"><%= p.isInWishlist() ? "♥" : "♡" %></span>
                            <span class="wishlist-count"><%= p.getWishlistCount() %></span>
                        </button>
                    </div>
                    <div style="display:flex; gap:10px; margin: 0 25px 25px;">
                        <a href="${pageContext.request.contextPath}/DettaglioProdotto?id=<%= p.getId() %>" class="btn" style="flex:1; margin:0; padding:10px 5px;">Dettagli</a>
                        <form action="CarrelloServlet" method="post" style="margin:0; flex:1; display:flex;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="id" value="<%= p.getId() %>">
                            <input type="hidden" name="quantita" value="1">
                            <% if (p.getQuantitaMagazzino() > 0) { %>
                                <button type="submit" class="btn" style="flex:1; margin:0; padding:10px 5px; background-color:#2ecc71;">Aggiungi</button>
                            <% } else { %>
                                <button type="button" class="btn" style="flex:1; margin:0; padding:10px 5px; background-color:#95a5a6; cursor:not-allowed;" disabled>Esaurito</button>
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

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
