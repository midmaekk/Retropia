package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Carrello implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<CartItem> elementi;

    public Carrello() {
        this.elementi = new ArrayList<>();
    }

    public List<CartItem> getElementi() {
        return elementi;
    }

    // Aggiungi o incrementa la quantità di un prodotto
    public void aggiungiProdotto(Prodotto prodotto, int quantita) {
        if (prodotto == null || quantita <= 0) return;

        for (CartItem item : elementi) {
            if (item.getProdotto().getId() == prodotto.getId()) {
                item.setQuantita(item.getQuantita() + quantita);
                return;
            }
        }
        // Se non è già nel carrello, lo aggiungo
        elementi.add(new CartItem(prodotto, quantita));
    }

    // Rimuove completamente il prodotto dal carrello
    public void rimuoviProdotto(int idProdotto) {
        elementi.removeIf(item -> item.getProdotto().getId() == idProdotto);
    }

    // Imposta una quantità specifica (se 0 o minore, lo rimuove)
    public void setQuantita(int idProdotto, int nuovaQuantita) {
        if (nuovaQuantita <= 0) {
            rimuoviProdotto(idProdotto);
            return;
        }
        for (CartItem item : elementi) {
            if (item.getProdotto().getId() == idProdotto) {
                item.setQuantita(nuovaQuantita);
                return;
            }
        }
    }

    // Svuota l'intero carrello
    public void svuota() {
        elementi.clear();
    }

    // Calcola il totale complessivo di tutto il carrello
    public BigDecimal getPrezzoTotale() {
        BigDecimal totale = BigDecimal.ZERO;
        for (CartItem item : elementi) {
            totale = totale.add(item.getTotale());
        }
        return totale;
    }

    // Ritorna il numero totale di articoli (somma delle quantità)
    public int getNumeroTotaleArticoli() {
        return elementi.stream().mapToInt(CartItem::getQuantita).sum();
    }
}
