package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Prodotto implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String nome;
    private String descrizione;
    private BigDecimal prezzo;
    private BigDecimal iva;
    private int quantitaMagazzino;
    private String urlImmagine;
    
    // Nuovi campi per CRUD
    private boolean attivo = true;
    private String condizione;
    private int idCategoria;
    
    // Campi per la Wishlist
    private int wishlistCount;
    private boolean inWishlist;
    
    // Costruttore vuoto (obbligatorio per i JavaBean)
    public Prodotto() {
    }

    public Prodotto(int id, String nome, String descrizione, BigDecimal prezzo, BigDecimal iva, int quantitaMagazzino, String urlImmagine) {
        this.id = id;
        this.nome = nome;
        this.descrizione = descrizione;
        this.prezzo = prezzo;
        this.iva = iva;
        this.quantitaMagazzino = quantitaMagazzino;
        this.urlImmagine = urlImmagine;
    }

    // Getter e Setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public BigDecimal getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(BigDecimal prezzo) {
        this.prezzo = prezzo;
    }

    public BigDecimal getIva() {
        return iva;
    }

    public void setIva(BigDecimal iva) {
        this.iva = iva;
    }

    public int getQuantitaMagazzino() {
        return quantitaMagazzino;
    }

    public void setQuantitaMagazzino(int quantitaMagazzino) {
        this.quantitaMagazzino = quantitaMagazzino;
    }

    public String getUrlImmagine() {
        return urlImmagine;
    }

    public void setUrlImmagine(String urlImmagine) {
        this.urlImmagine = urlImmagine;
    }

    public int getWishlistCount() {
        return wishlistCount;
    }

    public void setWishlistCount(int wishlistCount) {
        this.wishlistCount = wishlistCount;
    }

    public boolean isInWishlist() {
        return inWishlist;
    }

    public void setInWishlist(boolean inWishlist) {
        this.inWishlist = inWishlist;
    }

    public boolean isAttivo() {
        return attivo;
    }

    public void setAttivo(boolean attivo) {
        this.attivo = attivo;
    }

    public String getCondizione() {
        return condizione;
    }

    public void setCondizione(String condizione) {
        this.condizione = condizione;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    @Override
    public String toString() {
        return "Prodotto{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", prezzo=" + prezzo +
                ", iva=" + iva +
                ", magazzino=" + quantitaMagazzino +
                '}';
    }
}
