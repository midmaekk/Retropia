<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Prodotto" %>
<%
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    boolean isEdit = (prodotto != null);
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Modifica" : "Aggiungi" %> Prodotto - Admin - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; /* Importante per non far uscire gli input */
        }
        .form-group input[type="file"] {
            margin-top: 5px;
        }
        .btn-submit {
            background-color: #27ae60;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            width: 100%;
            margin-top: 10px;
        }
        .img-preview {
            max-width: 200px;
            margin-top: 10px;
            display: block;
        }
    </style>
</head>
<body style="background-color: #f4f6f9;">

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />

    <main style="max-width: 800px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        
        <h2><%= isEdit ? "Modifica Prodotto" : "Nuovo Prodotto" %></h2>
        
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/admin/prodotti" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">
                <% if(isEdit) { %>
                    <input type="hidden" name="id" value="<%= prodotto.getId() %>">
                <% } %>

                <div class="form-group">
                    <label for="nome">Nome Prodotto *</label>
                    <input type="text" id="nome" name="nome" value="<%= isEdit ? prodotto.getNome() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="descrizione">Descrizione</label>
                    <textarea id="descrizione" name="descrizione" rows="4"><%= isEdit && prodotto.getDescrizione() != null ? prodotto.getDescrizione() : "" %></textarea>
                </div>
                
                <div style="display: flex; gap: 15px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="prezzo">Prezzo Base (€) *</label>
                        <input type="number" id="prezzo" name="prezzo" step="0.01" min="0.01" value="<%= isEdit ? prodotto.getPrezzo() : "" %>" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="iva">IVA (%) *</label>
                        <input type="number" id="iva" name="iva" step="0.01" min="0" value="<%= isEdit ? prodotto.getIva() : "22.00" %>" required>
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="quantita">Quantità Stock *</label>
                        <input type="number" id="quantita" name="quantita" min="0" value="<%= isEdit ? prodotto.getQuantitaMagazzino() : "0" %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="condizione">Condizione</label>
                    <input type="text" id="condizione" name="condizione" value="<%= isEdit && prodotto.getCondizione() != null ? prodotto.getCondizione() : "Nuovo" %>">
                </div>
                
                <div class="form-group">
                    <label for="categoria">Categoria *</label>
                    <select id="categoria" name="categoria" required>
                        <option value="">-- Seleziona --</option>
                        <option value="1" <%= isEdit && prodotto.getIdCategoria() == 1 ? "selected" : "" %>>Giochi</option>
                        <option value="2" <%= isEdit && prodotto.getIdCategoria() == 2 ? "selected" : "" %>>Console</option>
                        <option value="3" <%= isEdit && prodotto.getIdCategoria() == 3 ? "selected" : "" %>>Accessori</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="immagine">Immagine Prodotto <%= isEdit ? "(lascia vuoto per non modificare)" : "*" %></label>
                    <input type="file" id="immagine" name="immagine" accept="image/*" <%= isEdit ? "" : "required" %>>
                    <% if(isEdit && prodotto.getUrlImmagine() != null) { %>
                        <img src="${pageContext.request.contextPath}/<%= prodotto.getUrlImmagine() %>" alt="Current Image" class="img-preview">
                    <% } %>
                </div>

                <div class="form-group" style="margin-top: 20px;">
                    <label style="display: inline-flex; align-items: center; gap: 8px; cursor: pointer;">
                        <input type="checkbox" name="attivo" value="1" <%= (!isEdit || prodotto.isAttivo()) ? "checked" : "" %>>
                        Prodotto Attivo (Visibile nel catalogo)
                    </label>
                </div>

                <button type="submit" class="btn-submit"><%= isEdit ? "Salva Modifiche" : "Inserisci Prodotto" %></button>
            </form>
        </div>

        <div style="margin-top: 2rem; text-align: center;">
            <a href="${pageContext.request.contextPath}/admin/prodotti" style="color: #2c3e50;">← Annulla e torna alla lista</a>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
