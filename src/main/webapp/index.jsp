<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Home</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="scripts/main.js?v=3" defer></script>
</head>
<body>

    <jsp:include page="fragments/header.jsp" />
    <jsp:include page="fragments/navbar.jsp" />

    <main>
        <section class="hero">
            <h1>Benvenuti su <span>Retropia</span></h1>
            <p>Il nuovo punto di riferimento per il collezionismo e il retrogaming. Dai floppy disk alle console HD.</p>
            <div class="hero-actions">
                <a href="catalogo.jsp" class="btn-primary">Esplora Catalogo</a>
            </div>
        </section>

        <!-- Categories Section -->
        <section class="home-section categories">
            <h2>Esplora per <span>Categoria</span></h2>
            <div class="category-grid">
                <a href="catalogo.jsp?cat=console" class="category-card">
                    <div class="category-icon">🎮</div>
                    <h3>Console</h3>
                </a>
                <a href="catalogo.jsp?cat=giochi" class="category-card">
                    <div class="category-icon">💿</div>
                    <h3>Videogiochi</h3>
                </a>
                <a href="catalogo.jsp?cat=accessori" class="category-card">
                    <div class="category-icon">🔌</div>
                    <h3>Accessori</h3>
                </a>
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
                        if(count >= 4) break;
                        count++;
                %>
                <div class="product-card">
                    <img src="<%= p.getUrlImmagine() != null ? p.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= p.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/200x150?text=Retropia'">
                    <h3><%= p.getNome() %></h3>
                    <div class="price-wishlist-container" style="display: flex; justify-content: space-between; align-items: center; padding: 0 25px 25px;">
                        <p class="price" style="padding: 0; margin: 0;">€<%= String.format("%.2f", p.getPrezzo()) %></p>
                        <button class="wishlist-btn <%= p.isInWishlist() ? "active" : "" %>" onclick="toggleWishlist(<%= p.getId() %>, this)" style="position: static; margin-left: auto;">
                            <span class="heart-icon"><%= p.isInWishlist() ? "♥" : "♡" %></span>
                            <span class="wishlist-count"><%= p.getWishlistCount() %></span>
                        </button>
                    </div>
                    <a href="prodotto.jsp?id=<%= p.getId() %>" class="btn">Dettagli</a>
                </div>
                <% } %>
            </div>
        </section>

        <!-- Trade-in & Loyalty Info -->
        <div class="home-grid-info">
            <section class="home-section info-box trade-in">
                <div class="info-content">
                    <h2>Servizio <span>Trade-in</span></h2>
                    <p>Hai dei vecchi giochi in soffitta? Inviaci foto e descrizione, i nostri esperti ti faranno una valutazione gratuita in 24 ore!</p>
                    <a href="tradein.jsp" class="btn-small">Richiedi Valutazione</a>
                </div>
            </section>
            
            <section class="home-section info-box loyalty">
                <div class="info-content">
                    <h2>Rocket <span>Coins</span></h2>
                    <p>Unisciti al nostro programma fedeltà. Accumula punti con ogni acquisto e riscattali per sconti esclusivi e rarità.</p>
                    <a href="registrazione.jsp" class="btn-small">Inizia ad Accumulare</a>
                </div>
            </section>
        </div>
    </main>

    <jsp:include page="fragments/footer.jsp" />

</body>
</html>
