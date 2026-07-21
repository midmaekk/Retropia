<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Home</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js?v=4" defer></script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <section class="hero">
            <h1>Benvenuti su <span>Retropia</span></h1>
            <p>Il nuovo punto di riferimento per il collezionismo e il retrogaming. Dai floppy disk alle console HD.</p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary">Esplora Catalogo</a>
            </div>
        </section>

        <section class="home-section featured-products">
            <h2>Prodotti in <span>Evidenza</span></h2>
            <div class="product-grid">
                <% 
                    // Recupero 4 prodotti in evidenza dal DB
                    model.ProdottoDAO dao = new model.ProdottoDAO();
                    model.Utente utenteHome = (model.Utente) request.getSession().getAttribute("utenteLoggato");
                    int idUtenteHome = (utenteHome != null) ? utenteHome.getId() : -1;
                    
                    java.util.List<model.Prodotto> vetrina = dao.doRetrieveAll(null, idUtenteHome);
                    int count = 0;
                    for(model.Prodotto p : vetrina) {
                        if(count >= 6) break;
                        count++;
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
                    </div>
                </div>
                <% } %>
            </div>
        </section>

        <!-- Newsletter Section -->
        <section class="home-section" style="background: #2D2D30; color: white; padding: 40px; border-radius: 16px; text-align: center; margin: 40px auto; max-width: 800px; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
            <h2 style="color: white; margin-bottom: 15px;">Iscriviti alla <span>Newsletter</span></h2>
            <p style="color: #AAA; margin-bottom: 25px;">Iscriviti per ricevere sconti esclusivi, nuovi arrivi e promozioni speciali direttamente nella tua casella email.</p>
            <form style="display: flex; gap: 10px; justify-content: center;">
                <input type="email" placeholder="La tua email..." required style="padding: 12px 20px; border-radius: 8px; border: none; width: 60%; font-size: 1rem;">
                <button type="submit" class="btn-primary" style="padding: 12px 25px; border-radius: 8px;">Iscriviti</button>
            </form>
        </section>

    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
