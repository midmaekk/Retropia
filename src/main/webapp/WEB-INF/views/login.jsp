<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Login</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js" defer></script>
    <script src="scripts/validation.js" defer></script>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main class="auth-page">
        <section class="auth-container">
            <div class="auth-header">
                <h1>Bentornato su <span>Retropia</span></h1>
                <p>Accedi per gestire i tuoi ordini e il tuo profilo.</p>
            </div>
            
            <% String errore = (String) request.getAttribute("erroreLogin"); 
               if (errore != null) { %>
               <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
                   <strong>Attenzione:</strong> <%= errore %>
               </div>
            <% } %>
            
            <form action="LoginServlet" method="POST" class="auth-form" id="loginForm">
                <div class="form-group">
                    <label for="login-email">Indirizzo Email</label>
                    <input type="email" id="login-email" name="email" placeholder="esempio@email.it" required>
                    <span id="loginEmailError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input type="password" id="login-password" name="password" placeholder="••••••••" required>
                    <span id="loginPasswordError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                
                <div class="auth-options">
                    <label><input type="checkbox"> Ricordami</label>
                    <a href="#">Password dimenticata?</a>
                </div>
                
                <button type="submit" class="btn-auth">Accedi al Team</button>
            </form>


            <div class="auth-footer">
                <p>Nuovo recluta? <a href="${pageContext.request.contextPath}/RegistrationServlet">Crea un account ora</a></p>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
