package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Prodotto prodotto;
    private int quantita;

    public CartItem() {
    }

    public CartItem(Prodotto prodotto, int quantita) {
        this.prodotto = prodotto;
        this.quantita = quantita;
    }

    public Prodotto getProdotto() {
        return prodotto;
    }

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    // Metodo helper per calcolare il prezzo totale per questa riga
    // Moltiplica il prezzo (ivato) del prodotto per la quantità
    public BigDecimal getTotale() {
        if (prodotto == null || prodotto.getPrezzo() == null) {
            return BigDecimal.ZERO;
        }
        
        // Calcolo base per semplificare, l'IVA potrebbe essere aggiunta qui o gestita in base al requisito
        // Assumiamo che prodotto.getPrezzo() sia il prezzo netto e l'IVA sia una percentuale (es. 22.0)
        BigDecimal prezzoNetto = prodotto.getPrezzo();
        BigDecimal iva = prodotto.getIva() != null ? prodotto.getIva() : BigDecimal.ZERO;
        
        BigDecimal moltiplicatoreIva = BigDecimal.ONE.add(iva.divide(new BigDecimal("100")));
        BigDecimal prezzoLordo = prezzoNetto.multiply(moltiplicatoreIva);
        
        return prezzoLordo.multiply(new BigDecimal(quantita));
    }
}
