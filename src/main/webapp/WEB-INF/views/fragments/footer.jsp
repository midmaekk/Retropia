<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer>
    <div class="footer-content">
        <div class="footer-section about">
            <h3><span>R</span>etropia</h3>
            <p>Il nuovo punto di riferimento per il mondo del retrogaming e del collezionismo. Rivivi la storia dei videogiochi con noi.</p>

        </div>
        
        <div class="footer-section links">
            <h3>Navigazione</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/Home">Home Page</a></li>
                <li><a href="${pageContext.request.contextPath}/Catalogo">Catalogo Prodotti</a></li>
            </ul>
        </div>

        <div class="footer-section links">
            <h3>Chi Siamo</h3>
            <ul>
                <li><a href="#">La Nostra Storia</a></li>
                <li><a href="#">Il Team Rocket</a></li>
                <li><a href="#">Lavora con noi</a></li>
            </ul>
        </div>

    </div>
    
    <div class="footer-bottom">
        <div class="footer-bottom-content">
            <p>&copy; 2026 <strong>Retropia</strong> - Team Rocket</p>
            <div class="footer-legal">
                <a href="#">Privacy Policy</a>
                <a href="#">Termini e Condizioni</a>
            </div>
        </div>
    </div>
</footer>

<!-- Toast Notification Container -->
<div id="toast-container" class="toast-container"></div>

<%
    String toastMsg = (String) session.getAttribute("toastMessage");
    if (toastMsg != null) {
%>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            showToast("<%= toastMsg.replace("\"", "\\\"") %>", "info");
        });
    </script>
<%
        session.removeAttribute("toastMessage");
    }
%>
