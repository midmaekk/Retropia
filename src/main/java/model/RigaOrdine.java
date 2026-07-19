package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class RigaOrdine implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idProdotto;
    private String nomeProdotto; // Salvato per integrità storica
    private BigDecimal prezzoAcquisto; // Prezzo al momento dell'acquisto
    private BigDecimal ivaAcquisto; // IVA al momento dell'acquisto
    private int quantita;

    public RigaOrdine() {
    }

    public RigaOrdine(int idOrdine, int idProdotto, String nomeProdotto, BigDecimal prezzoAcquisto, BigDecimal ivaAcquisto, int quantita) {
        this.idOrdine = idOrdine;
        this.idProdotto = idProdotto;
        this.nomeProdotto = nomeProdotto;
        this.prezzoAcquisto = prezzoAcquisto;
        this.ivaAcquisto = ivaAcquisto;
        this.quantita = quantita;
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public String getNomeProdotto() {
        return nomeProdotto;
    }

    public void setNomeProdotto(String nomeProdotto) {
        this.nomeProdotto = nomeProdotto;
    }

    public BigDecimal getPrezzoAcquisto() {
        return prezzoAcquisto;
    }

    public void setPrezzoAcquisto(BigDecimal prezzoAcquisto) {
        this.prezzoAcquisto = prezzoAcquisto;
    }

    public BigDecimal getIvaAcquisto() {
        return ivaAcquisto;
    }

    public void setIvaAcquisto(BigDecimal ivaAcquisto) {
        this.ivaAcquisto = ivaAcquisto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }
    
    // prezzoAcquisto è già il prezzo lordo (IVA inclusa) congelato al momento dell'ordine.
    // L'ivaAcquisto viene salvata solo per tracciabilità storica, non per ricalcolare il prezzo.
    public BigDecimal getTotaleRiga() {
        if (prezzoAcquisto == null) return BigDecimal.ZERO;
        return prezzoAcquisto.multiply(new BigDecimal(quantita));
    }
}
