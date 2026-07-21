<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Prodotto" %>
<%
    List<Prodotto> wishlist = (List<Prodotto>) request.getAttribute("wishlist");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La mia Wishlist - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/scripts/main.js" defer></script>
    <style>
        .wishlist-empty {
            text-align: center;
            padding: 100px 20px;
        }
        .wishlist-empty h2 {
            font-size: 2rem;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }
        .wishlist-empty p {
            color: var(--text-light);
            margin-bottom: 30px;
        }
        .wishlist-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .wishlist-header {
            margin-bottom: 40px;
            border-bottom: 2px solid #EEE;
            padding-bottom: 20px;
        }
        .wishlist-header h1 {
            font-size: 2.5rem;
            color: var(--secondary-color);
        }
        .wishlist-header h1 span {
            color: var(--primary-color);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main class="wishlist-container">
        
        <div class="wishlist-header">
            <h1>La mia <span>Wishlist</span></h1>
            <p>I prodotti che ami e che vorresti avere nella tua collezione.</p>
        </div>

        <% if (wishlist == null || wishlist.isEmpty()) { %>
            <div class="wishlist-empty">
                <h2>La tua wishlist è vuota.</h2>
                <p>Non hai ancora aggiunto alcun prodotto alla tua lista dei desideri.</p>
                <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary">Scopri il Catalogo</a>
            </div>
        <% } else { %>
            <div class="product-grid">
                <% for (Prodotto p : wishlist) { %>
                    <div class="product-card" id="wishlist-card-<%= p.getId() %>">
                        <img src="<%= p.getUrlImmagine() != null ? p.getUrlImmagine() : "images/placeholder.jpg" %>" alt="<%= p.getNome() %>" onerror="this.onerror=null;this.src='https://via.placeholder.com/200x150?text=Retropia'">
                        
                        <h3 style="flex-grow: 1;"><%= p.getNome() %></h3>
                        
                        <div class="price-wishlist-container" style="display: flex; justify-content: space-between; align-items: center; padding: 0 25px 15px;">
                            <p class="price" style="padding: 0; margin: 0;">€<%= String.format("%.2f", p.getPrezzo()) %></p>
                            
                            <!-- Nel contesto della wishlist, rimuovendo il prodotto nascondiamo la card per UX fluida -->
                            <button class="wishlist-btn active" onclick="removeFromWishlistPage(<%= p.getId() %>, this)" style="position: static; margin-left: auto; width: auto; padding: 0 12px; border-radius: 20px;">
                                <span class="heart-icon">♥</span>
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
                <% } %>
            </div>
            
            <script>
                function removeFromWishlistPage(idProdotto, btnElement) {
                    // Chiama la logica esistente di toggle
                    fetch('Wishlist?idProdotto=' + idProdotto, {
                        method: 'POST'
                    })
                    .then(response => {
                        if(response.ok) return response.json();
                        throw new Error('Errore nella richiesta');
                    })
                    .then(data => {
                        if(!data.inWishlist) {
                            // Rimuovi la card dal DOM con una piccola animazione
                            const card = document.getElementById('wishlist-card-' + idProdotto);
                            if(card) {
                                card.style.transition = 'opacity 0.3s, transform 0.3s';
                                card.style.opacity = '0';
                                card.style.transform = 'scale(0.9)';
                                setTimeout(() => {
                                    card.remove();
                                    // Se non ci sono più card, potremmo mostrare l'empty state ricaricando
                                    if(document.querySelectorAll('.product-card').length === 0) {
                                        window.location.reload();
                                    }
                                }, 300);
                            }
                            if(typeof showToast === 'function') {
                                showToast("Prodotto rimosso dalla wishlist", "info");
                            }
                        }
                    })
                    .catch(error => {
                        console.error('Errore:', error);
                    });
                }
            </script>
        <% } %>

    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
