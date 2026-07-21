<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Utente" %>
<%
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    // Messaggi di feedback dalla servlet
    String successoDati     = (String) request.getAttribute("successoDati");
    String erroreDati       = (String) request.getAttribute("erroreDati");
    String successoPassword = (String) request.getAttribute("successoPassword");
    String errorePassword   = (String) request.getAttribute("errorePassword");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Il Mio Profilo</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js?v=4" defer></script>
    <style>
        .profilo-wrapper {
            max-width: 760px;
            margin: 0 auto;
        }

        .profilo-avatar-large {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 900;
            color: #fff;
            text-transform: uppercase;
            flex-shrink: 0;
            box-shadow: 0 4px 15px rgba(238,21,21,0.3);
        }

        /* Card sezione */
        .profilo-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.07);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .profilo-card-header {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1.25rem 1.75rem;
            background: #fafafa;
            border-bottom: 1px solid #f0f0f0;
        }

        .profilo-card-header h2 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .profilo-card-header span {
            font-size: 1.2rem;
        }

        .profilo-card-body {
            padding: 1.75rem;
        }

        /* Grid due colonne per i campi anagrafici */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem 1.5rem;
        }

        .form-grid .form-group--full {
            grid-column: 1 / -1;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
        }

        .form-group label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #888;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            padding: 0.65rem 0.9rem;
            border: 1.5px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
            color: var(--text-color);
            transition: border-color 0.2s;
            background: #fff;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .form-group input[readonly] {
            background: #f8f8f8;
            color: #aaa;
            cursor: not-allowed;
        }

        /* Messaggi di feedback */
        .alert {
            padding: 0.85rem 1.1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .alert--success {
            background: #eafaf1;
            color: #1e8449;
            border: 1px solid #a9dfbf;
        }

        .alert--error {
            background: #fdf2f2;
            color: #c0392b;
            border: 1px solid #f5b7b1;
        }

        /* Pulsante salva */
        .btn-save {
            margin-top: 1.25rem;
            padding: 0.7rem 2rem;
            background: var(--primary-color);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            font-family: inherit;
            transition: background 0.2s, transform 0.15s;
        }

        .btn-save:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-save:active {
            transform: translateY(0);
        }

        .field-hint {
            font-size: 0.76rem;
            color: #aaa;
            margin-top: 0.15rem;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .profilo-hero { flex-direction: column; text-align: center; }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <main>
        <div class="profilo-wrapper">

            <!-- Intestazione profilo -->
            <div style="display: flex; align-items: center; gap: 1.25rem; margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #eee;">
                <div class="profilo-avatar-large"><%= utente.getNome().charAt(0) %></div>
                <div>
                    <h1 style="font-size: 1.6rem; font-weight: 800; color: var(--secondary-color); margin: 0 0 0.2rem;">
                        <%= utente.getNome() %> <%= utente.getCognome() %>
                    </h1>
                    <p style="color: #888; font-size: 0.95rem; margin: 0;"><%= utente.getEmail() %></p>
                    <% if (utente.isAdmin()) { %>
                        <span style="display:inline-block; background:#f1c40f; color:#1a1a1d; font-size:0.72rem; font-weight:700; padding:2px 10px; border-radius:20px; margin-top:5px; text-transform:uppercase; letter-spacing:1px;">&#9881; Amministratore</span>
                    <% } %>
                </div>
            </div>

            <!-- Sezione 1: Dati Anagrafici -->
            <div class="profilo-card">
                <div class="profilo-card-header">
                    <span>&#128100;</span>
                    <h2>Dati Anagrafici</h2>
                </div>
                <div class="profilo-card-body">

                    <% if (successoDati != null) { %>
                        <div class="alert alert--success">&#10003; <%= successoDati %></div>
                    <% } %>
                    <% if (erroreDati != null) { %>
                        <div class="alert alert--error">&#9888; <%= erroreDati %></div>
                    <% } %>

                    <form action="Profilo" method="POST">
                        <input type="hidden" name="action" value="updateDati">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nome">Nome</label>
                                <input type="text" id="nome" name="nome"
                                       value="<%= utente.getNome() %>" required
                                       minlength="2" maxlength="50">
                            </div>
                            <div class="form-group">
                                <label for="cognome">Cognome</label>
                                <input type="text" id="cognome" name="cognome"
                                       value="<%= utente.getCognome() %>" required
                                       minlength="2" maxlength="50">
                            </div>
                            <div class="form-group form-group--full">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email"
                                       value="<%= utente.getEmail() %>" required>
                            </div>
                            <div class="form-group form-group--full">
                                <label>ID Account</label>
                                <input type="text" value="#<%= String.format("%04d", utente.getId()) %>" readonly>
                                <span class="field-hint">L'ID account non e' modificabile.</span>
                            </div>
                        </div>
                        <button type="submit" class="btn-save">Salva Modifiche</button>
                    </form>
                </div>
            </div>

            <!-- Sezione 2: Cambio Password -->
            <div class="profilo-card">
                <div class="profilo-card-header">
                    <span>&#128274;</span>
                    <h2>Cambio Password</h2>
                </div>
                <div class="profilo-card-body">

                    <% if (successoPassword != null) { %>
                        <div class="alert alert--success">&#10003; <%= successoPassword %></div>
                    <% } %>
                    <% if (errorePassword != null) { %>
                        <div class="alert alert--error">&#9888; <%= errorePassword %></div>
                    <% } %>

                    <form action="Profilo" method="POST" id="passwordForm">
                        <input type="hidden" name="action" value="updatePassword">
                        <div class="form-grid">
                            <div class="form-group form-group--full">
                                <label for="vecchiaPassword">Password Attuale</label>
                                <input type="password" id="vecchiaPassword" name="vecchiaPassword"
                                       placeholder="Inserisci la password attuale" required>
                            </div>
                            <div class="form-group">
                                <label for="nuovaPassword">Nuova Password</label>
                                <input type="password" id="nuovaPassword" name="nuovaPassword"
                                       placeholder="Minimo 8 caratteri" required minlength="8">
                            </div>
                            <div class="form-group">
                                <label for="confermaPassword">Conferma Password</label>
                                <input type="password" id="confermaPassword" name="confermaPassword"
                                       placeholder="Ripeti la nuova password" required minlength="8">
                                <span id="passwordMatchError" class="field-hint" style="color:#c0392b; display:none;">
                                    Le password non coincidono.
                                </span>
                            </div>
                        </div>
                        <button type="submit" class="btn-save">Aggiorna Password</button>
                    </form>
                </div>
            </div>

        </div><!-- fine profilo-wrapper -->
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

    <script>
        // Validazione client-side: le due password devono coincidere
        (function() {
            const form       = document.getElementById('passwordForm');
            const nuova      = document.getElementById('nuovaPassword');
            const conferma   = document.getElementById('confermaPassword');
            const errSpan    = document.getElementById('passwordMatchError');

            function check() {
                if (conferma.value && nuova.value !== conferma.value) {
                    errSpan.style.display = 'block';
                    conferma.style.borderColor = '#e74c3c';
                } else {
                    errSpan.style.display = 'none';
                    conferma.style.borderColor = '';
                }
            }

            nuova.addEventListener('input', check);
            conferma.addEventListener('input', check);

            form.addEventListener('submit', function(e) {
                if (nuova.value !== conferma.value) {
                    e.preventDefault();
                    check();
                }
            });
        })();
    </script>

</body>
</html>
