<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%@ page import="model.Carrello" %>
<%
    // Recupero dati dalla sessione
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    Carrello carrelloHeader = (Carrello) session.getAttribute("carrello");
    int oggettiCarrello = (carrelloHeader != null) ? carrelloHeader.getNumeroTotaleArticoli() : 0;
%>
<header>
    <div class="header-content">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/Home"><h1><span>R</span>etropia</h1></a>
        </div>

        <!-- Barra di ricerca (nascosta su mobile di default, toggle via JS) -->
        <div class="search-bar" id="searchBar" style="position: relative;">
            <input type="text" id="searchInput" placeholder="Cerca giochi o console..." autocomplete="off">
            <button type="button" id="searchButton">Cerca</button>
            <ul id="searchSuggestions" class="suggestions-list" style="display: none;"></ul>
        </div>

        <!-- Controlli header destra -->
        <div class="user-actions">

            <!-- Bottone toggle search (solo mobile) -->
            <button class="search-toggle-btn" id="searchToggleBtn" aria-label="Apri ricerca">
                🔍
            </button>

            <% if (utenteLoggato != null) { %>
                <% if (utenteLoggato.isAdmin()) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-badge">&#9881; Admin</a>
                <% } %>

                <!-- Avatar dropdown utente -->
                <div class="user-dropdown" id="userDropdown">
                    <button class="user-avatar-btn" id="userAvatarBtn" aria-haspopup="true" aria-expanded="false">
                        <span class="avatar-initials"><%= utenteLoggato.getNome().charAt(0) %></span>
                    </button>
                    <div class="user-dropdown-menu" id="userDropdownMenu" role="menu">
                        <div class="dropdown-header">
                            <span class="dropdown-user-email"><%= utenteLoggato.getEmail() %></span>
                        </div>
                        <hr class="dropdown-divider">
                        <a href="${pageContext.request.contextPath}/Profilo" class="dropdown-item" role="menuitem">
                            <span class="dropdown-icon">&#128100;</span> Dati Anagrafici
                        </a>
                        <a href="${pageContext.request.contextPath}/StoricoOrdiniServlet" class="dropdown-item" role="menuitem">
                            <span class="dropdown-icon">&#128230;</span> Storico Ordini
                        </a>
                        <a href="${pageContext.request.contextPath}/WishlistPage" class="dropdown-item" role="menuitem">
                            <span class="dropdown-icon">&#10084;</span> La mia Wishlist
                        </a>
                        <hr class="dropdown-divider">
                        <a href="${pageContext.request.contextPath}/Logout" class="dropdown-item dropdown-item--danger" role="menuitem">
                            <span class="dropdown-icon">&#10148;</span> Esci
                        </a>
                    </div>
                </div>

            <% } else { %>
                <a href="${pageContext.request.contextPath}/LoginServlet">Login</a>
            <% } %>
            
            <a href="${pageContext.request.contextPath}/CarrelloServlet" class="cart-link">
                <span class="cart-icon">&#128722;</span>
                Carrello <% if(oggettiCarrello > 0) { %><span class="cart-badge"><%= oggettiCarrello %></span><% } %>
            </a>

            <!-- Bottone hamburger (solo mobile) -->
            <button class="hamburger-btn" id="hamburgerBtn" aria-label="Apri menu" aria-expanded="false">
                <span class="hamburger-line"></span>
                <span class="hamburger-line"></span>
                <span class="hamburger-line"></span>
            </button>
        </div>

    </div>
</header>
