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
            <a href="index.jsp"><h1><span>R</span>etropia</h1></a>
        </div>
        <div class="search-bar">
            <input type="text" placeholder="Cerca giochi o console...">
            <button type="button">Cerca</button>
        </div>
        <div class="user-actions">
            <% if (utenteLoggato != null) { %>
                <span style="color:white; margin-right: 15px;">Ciao, <%= utenteLoggato.getNome() %>!</span>
                <% if (utenteLoggato.isAdmin()) { %>
                    <a href="${pageContext.request.contextPath}/admin/index.jsp" style="color: #f1c40f; margin-right: 10px;">Area Admin</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/Logout">Esci</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
            <% } %>
            
            <a href="${pageContext.request.contextPath}/carrello.jsp">
                Carrello <% if(oggettiCarrello > 0) { %>(<%= oggettiCarrello %>)<% } %>
            </a>
        </div>
    </div>
</header>
