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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=4">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages/fattura.css?v=4">
    <script src="${pageContext.request.contextPath}/scripts/main.js" defer></script>
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
                <p>Retropia &mdash; P.IVA 00000000000 &mdash; retropia@esempio.it</p>
            </div>

        </div><!-- fine .fattura-document -->
    </div><!-- fine .fattura-page-wrapper -->

    <jsp:include page="/WEB-INF/views/fragments/footer.jsp" />

</body>
</html>
