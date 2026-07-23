<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Ordine" %>
<%@ page import="model.RigaOrdine" %>
<%@ page import="model.Utente" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Ordine ordine = (Ordine) request.getAttribute("ordine");
    Utente utente = (Utente) request.getAttribute("utente");

    if (ordine == null || utente == null) {
        response.sendRedirect(request.getContextPath() + "/StoricoOrdiniServlet");
        return;
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String dataEmissione = sdf.format(new java.util.Date());
    String dataOrdine = sdf.format(ordine.getDataOrdine());
    String numeroFattura = String.format("FAT-%d-%04d", java.util.Calendar.getInstance().get(java.util.Calendar.YEAR), ordine.getId());

    // Calcolo imponibile: scorporo IVA dal totale lordo usando la prima aliquota disponibile
    // Se righe diverse hanno IVA diversa, si sommano le singole basi imponibili
    BigDecimal totaleImponibile = BigDecimal.ZERO;
    BigDecimal totaleIva = BigDecimal.ZERO;
    for (RigaOrdine riga : ordine.getRighe()) {
        BigDecimal aliquota = riga.getIvaAcquisto() != null ? riga.getIvaAcquisto() : new BigDecimal("22.00");
        BigDecimal divisore = BigDecimal.ONE.add(aliquota.divide(new BigDecimal("100")));
        BigDecimal totaleLordo = riga.getPrezzoAcquisto().multiply(new BigDecimal(riga.getQuantita()));
        BigDecimal imponibileRiga = totaleLordo.divide(divisore, 2, java.math.RoundingMode.HALF_UP);
        BigDecimal ivaRiga = totaleLordo.subtract(imponibileRiga);
        totaleImponibile = totaleImponibile.add(imponibileRiga);
        totaleIva = totaleIva.add(ivaRiga);
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retropia - Fattura <%= numeroFattura %></title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <script src="scripts/main.js" defer></script>
    <style>
/* ===================================================
   STILI A SCHERMO (visualizzazione normale nel browser)
   =================================================== */
.fattura-page-wrapper {
    max-width: 860px;
    margin: 2rem auto;
    padding: 0 1rem;
}

.fattura-actions {
    display: flex;
    gap: 1rem;
    margin-bottom: 1.5rem;
    justify-content: flex-end;
}

.fattura-document {
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 3rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
}

/* Intestazione fattura */
.fattura-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 3px solid var(--primary-color, #e74c3c);
    padding-bottom: 1.5rem;
    margin-bottom: 2rem;
}

.fattura-brand h2 {
    font-size: 2rem;
    font-weight: 800;
    color: var(--primary-color, #e74c3c);
    margin: 0;
    letter-spacing: -1px;
}

.fattura-brand p {
    font-size: 0.85rem;
    color: #666;
    margin: 0.2rem 0 0;
}

.fattura-meta {
    text-align: right;
}

.fattura-meta h3 {
    font-size: 1.3rem;
    font-weight: 700;
    color: #333;
    margin: 0 0 0.5rem;
}

.fattura-meta p {
    font-size: 0.9rem;
    color: #555;
    margin: 0.1rem 0;
}

.fattura-numero {
    display: inline-block;
    background-color: var(--primary-color, #e74c3c);
    color: #fff;
    padding: 0.3rem 0.8rem;
    border-radius: 4px;
    font-weight: 700;
    font-size: 0.95rem;
    margin-bottom: 0.5rem;
}

/* Sezione dati cliente, spedizione e pagamento */
.fattura-parties {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.fattura-party h4 {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #999;
    margin: 0 0 0.5rem;
    font-weight: 600;
}

.fattura-party p {
    font-size: 0.95rem;
    color: #333;
    margin: 0.15rem 0;
}

.fattura-party p strong {
    font-weight: 700;
}

/* Tabella prodotti */
.fattura-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 2rem;
    font-size: 0.92rem;
}

.fattura-table thead tr {
    background-color: #f5f5f5;
    border-bottom: 2px solid #ddd;
}

.fattura-table th {
    padding: 0.75rem 1rem;
    text-align: left;
    font-weight: 600;
    color: #444;
    font-size: 0.82rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.fattura-table th:last-child,
.fattura-table td:last-child {
    text-align: right;
}

.fattura-table td {
    padding: 0.8rem 1rem;
    border-bottom: 1px solid #eee;
    color: #333;
}

.fattura-table tbody tr:hover {
    background-color: #fafafa;
}

/* Riepilogo totali */
.fattura-totals {
    margin-left: auto;
    width: 300px;
}

.fattura-totals table {
    width: 100%;
    border-collapse: collapse;
}

.fattura-totals td {
    padding: 0.5rem 0.75rem;
    font-size: 0.93rem;
    color: #444;
}

.fattura-totals td:last-child {
    text-align: right;
    font-weight: 500;
}

.fattura-totals .total-row {
    border-top: 2px solid var(--primary-color, #e74c3c);
    font-size: 1.1rem;
    font-weight: 700;
    color: #111;
}

.fattura-totals .total-row td {
    padding-top: 0.75rem;
}

/* Footer legale della fattura */
.fattura-footer-legal {
    margin-top: 3rem;
    padding-top: 1.5rem;
    border-top: 1px solid #eee;
    font-size: 0.78rem;
    color: #999;
    text-align: center;
}

/* ===================================================
   @media print — Ottimizzazione per la stampa / PDF
   =================================================== */
@media print {
    /* Nasconde tutti gli elementi dell'interfaccia del sito */
    header,
    nav,
    footer,
    .fattura-actions,
    .navbar,
    .site-header {
        display: none !important;
    }

    /* Sfondo bianco, testo nero per risparmio inchiostro */
    body {
        background: white !important;
        color: black !important;
        font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    }

    /* Il documento fattura occupa tutta la pagina */
    .fattura-page-wrapper {
        max-width: 100%;
        margin: 0;
        padding: 0;
    }

    .fattura-document {
        border: none;
        border-radius: 0;
        box-shadow: none;
        padding: 1cm;
    }

    /* Evita interruzioni di pagina nel mezzo della tabella */
    .fattura-table {
        page-break-inside: avoid;
    }

    .fattura-table tr {
        page-break-inside: avoid;
    }

    /* Colore brand adattato alla stampa */
    .fattura-brand h2,
    .fattura-numero {
        color: #000 !important;
    }

    .fattura-numero {
        background: #000 !important;
        color: #fff !important;
    }

    .fattura-header {
        border-bottom-color: #000 !important;
    }

    a {
        text-decoration: none !important;
    }

    /* Definizione pagina A4 con margini adeguati */
    @page {
        size: A4 portrait;
        margin: 1cm 1.5cm;
    }
}
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/header.jsp" />
    <jsp:include page="/WEB-INF/views/fragments/navbar.jsp" />

    <div class="fattura-page-wrapper">

        <!-- Bottoni visibili solo a schermo, nascosti in stampa -->
        <div class="fattura-actions">
            <a href="StoricoOrdiniServlet" class="btn-secondary" style="text-decoration:none;">
                &larr; Torna agli Ordini
            </a>
            <button onclick="window.print()" class="btn-primary" style="cursor:pointer; border:none;">
                🖨️ Stampa / Salva PDF
            </button>
        </div>

        <!-- ===== DOCUMENTO FATTURA ===== -->
        <div class="fattura-document">

            <!-- Intestazione: brand + meta -->
            <div class="fattura-header">
                <div class="fattura-brand">
                    <h2>RETROPIA</h2>
                    <p>Il tuo negozio di retrogaming</p>
                    <p>retropia@esempio.it</p>
                </div>
                <div class="fattura-meta">
                    <span class="fattura-numero"><%= numeroFattura %></span>
                    <p><strong>Data emissione:</strong> <%= dataEmissione %></p>
                    <p><strong>Data ordine:</strong> <%= dataOrdine %></p>
                    <p><strong>N. Ordine:</strong> #<%= ordine.getId() %></p>
                </div>
            </div>

            <!-- Dati cliente, spedizione e pagamento -->
            <div class="fattura-parties">
                <div class="fattura-party">
                    <h4>Intestata a</h4>
                    <p><strong><%= utente.getNome() %> <%= utente.getCognome() %></strong></p>
                    <p><%= utente.getEmail() %></p>
                </div>
                <div class="fattura-party">
                    <h4>Indirizzo di Spedizione</h4>
                    <% if (ordine.getIndirizzoSpedizione() != null && !ordine.getIndirizzoSpedizione().trim().isEmpty()) { %>
                        <p><%= ordine.getIndirizzoSpedizione() %></p>
                    <% } else { %>
                        <p style="color:#999;">Non disponibile</p>
                    <% } %>
                </div>
                <div class="fattura-party">
                    <h4>Metodo di Pagamento</h4>
                    <p><strong><%= ordine.getMetodoPagamento() != null ? ordine.getMetodoPagamento() : "Carta di Credito" %></strong></p>
                </div>
            </div>

            <!-- Tabella prodotti -->
            <table class="fattura-table">
                <thead>
                    <tr>
                        <th>Prodotto</th>
                        <th>Qtà</th>
                        <th>Prezzo Unit. (IVA incl.)</th>
                        <th>Aliquota IVA</th>
                        <th>Totale Riga</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (RigaOrdine riga : ordine.getRighe()) { %>
                    <tr>
                        <td><%= riga.getNomeProdotto() != null ? riga.getNomeProdotto() : "Prodotto #" + riga.getIdProdotto() %></td>
                        <td><%= riga.getQuantita() %></td>
                        <td>€<%= String.format("%.2f", riga.getPrezzoAcquisto()) %></td>
                        <td><%= riga.getIvaAcquisto() != null ? String.format("%.0f", riga.getIvaAcquisto()) : "22" %>%</td>
                        <td>€<%= String.format("%.2f", riga.getTotaleRiga()) %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <!-- Riepilogo totali -->
            <div class="fattura-totals">
                <table>
                    <tr>
                        <td>Imponibile</td>
                        <td>€<%= String.format("%.2f", totaleImponibile) %></td>
                    </tr>
                    <tr>
                        <td>IVA</td>
                        <td>€<%= String.format("%.2f", totaleIva) %></td>
                    </tr>
                    <tr class="total-row">
                        <td><strong>Totale (IVA incl.)</strong></td>
                        <td><strong>€<%= String.format("%.2f", ordine.getTotale()) %></strong></td>
                    </tr>
                </table>
            </div>

            <!-- Footer legale -->
            <div class="fattura-footer-legal">
                <p>Questo documento è emesso a fini informativi e non costituisce fattura fiscale ai sensi del D.P.R. 633/1972.</p>
                <p>Retropia &mdash; P.IVA 00000000000 &mdash; retropia@esempio.it</p>
            </div>

        </div><!-- fine .fattura-document -->
    </div><!-- fine .fattura-page-wrapper -->

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
