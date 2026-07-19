<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Registrazione</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/validation.js" defer></script>
</head>
<body>

    <jsp:include page="fragments/header.jsp" />
    <jsp:include page="fragments/navbar.jsp" />

    <main class="auth-page">
        <section class="auth-container">
            <div class="auth-header">
                <h1>Unisciti al <span>Team</span></h1>
                <p>Crea un account per iniziare a collezionare.</p>
            </div>

            <form action="RegistrationServlet" method="POST" class="auth-form" id="registrationForm">
                <% 
                    String error = request.getParameter("error");
                    String msg = request.getParameter("msg");
                    if ("db".equals(error)) { 
                %>
                    <div style="color: #e74c3c; background: #fadbd8; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">
                        Errore durante il salvataggio sul database.<br>
                        <strong>Dettaglio:</strong> <%= msg != null ? msg : "Errore sconosciuto" %>
                    </div>
                <% } else if ("invalid".equals(error)) { %>
                    <div style="color: #e74c3c; background: #fadbd8; padding: 10px; border-radius: 5px; margin-bottom: 15px; text-align: center;">I dati inseriti non sono validi.</div>
                <% } %>
                <div class="form-group">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" placeholder="Il tuo nome" required>
                    <span id="nomeError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <div class="form-group">
                    <label for="cognome">Cognome</label>
                    <input type="text" id="cognome" name="cognome" placeholder="Il tuo cognome" required>
                    <span id="cognomeError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <div class="form-group">
                    <label for="reg-email">Indirizzo Email</label>
                    <input type="email" id="reg-email" name="email" placeholder="esempio@email.it" required>
                    <span id="emailError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <div class="form-group">
                    <label for="reg-password">Password</label>
                    <input type="password" id="reg-password" name="password" placeholder="Minimo 8 caratteri" required>
                    <span id="passwordError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <div class="form-group">
                    <label for="conferma-password">Conferma Password</label>
                    <input type="password" id="conferma-password" name="conferma-password" placeholder="Ripeti la password" required>
                    <span id="confirmError" class="error-msg" style="color: #e74c3c; font-size: 0.85rem; display: none; margin-top: 5px;"></span>
                </div>
                <button type="submit" class="btn-auth">Entra nel Team</button>
            </form>

            <div class="social-auth">
                <p>Oppure registrati con</p>
                <div class="social-buttons">
                    <button class="btn-social">Google</button>
                    <button class="btn-social">Discord</button>
                </div>
            </div>

            <div class="auth-footer">
                <p>Sei già un membro? <a href="login.jsp">Accedi qui</a></p>
            </div>
        </section>
    </main>

    <jsp:include page="fragments/footer.jsp" />

</body>
</html>
