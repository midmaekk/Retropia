<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Area Amministratore - Retropia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="background-color: #f4f6f9;">

    <header style="background-color: #2c3e50; color: white; padding: 1rem; text-align: center;">
        <h1>Pannello di Controllo Amministratore</h1>
    </header>

    <main style="max-width: 1000px; margin: 2rem auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        <h2>Benvenuto, Amministratore!</h2>
        <p>Questa è un'area riservata. Se riesci a vedere questa pagina significa che il Filtro Servlet ha validato con successo la tua sessione come amministratore.</p>
        
        <div style="margin-top: 2rem; display: flex; gap: 1rem;">
            <div style="flex: 1; padding: 1rem; border: 1px solid #ddd; border-radius: 4px;">
                <h3>Gestione Catalogo</h3>
                <p>Inserisci, modifica o elimina prodotti dal database.</p>
                <a href="${pageContext.request.contextPath}/admin/prodotti" 
                   style="display: block; text-align: center; text-decoration: none; box-sizing: border-box; width: 100%; margin-top: 10px; background-color: #2c3e50; color: white; padding: 0.6rem; border-radius: 4px; font-weight: bold;">
                   Gestisci Prodotti
                </a>
            </div>
            
            <div style="flex: 1; padding: 1rem; border: 1px solid #ddd; border-radius: 4px;">
                <h3>Gestione Ordini</h3>
                <p>Visualizza e filtra gli ordini dei clienti.</p>
                <a href="${pageContext.request.contextPath}/admin/ordini"
                   style="display: block; text-align: center; text-decoration: none; box-sizing: border-box; width: 100%; margin-top: 10px; background-color: #27ae60; color: white; padding: 0.6rem; border-radius: 4px; font-weight: bold;">
                   Visualizza Ordini
                </a>
            </div>
        </div>
        
        <div style="margin-top: 2rem; text-align: center;">
            <a href="${pageContext.request.contextPath}/Catalogo" class="btn-secondary">Torna al Sito Pubblico</a>
        </div>
    </main>

</body>
</html>
