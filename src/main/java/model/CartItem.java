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

    // Metodo helper per calcolare il prezzo totale per questa riga.
    // Il campo prezzo_base nel DB è già IVA inclusa (prezzo lordo),
    // quindi il totale è semplicemente prezzo * quantità.
    // Il campo iva del Prodotto viene usato solo per la tracciabilità storica
    // nella riga d'ordine (dettagli_ordine.iva_applicata), non per ricalcolare il prezzo.
    public BigDecimal getTotale() {
        if (prodotto == null || prodotto.getPrezzo() == null) {
            return BigDecimal.ZERO;
        }
        return prodotto.getPrezzo().multiply(new BigDecimal(quantita));
    }
}
