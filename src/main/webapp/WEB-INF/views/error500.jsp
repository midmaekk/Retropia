<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Errore del Server - Retropia</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <p>Qualcosa è andato storto nei nostri server. Riprova più tardi.</p>
        <a href="${pageContext.request.contextPath}/Home">Torna alla Home</a>
    </div>
</body>
</html>
