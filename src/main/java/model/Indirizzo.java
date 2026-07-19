package model;

import java.io.Serializable;

public class Indirizzo implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String via;
    private String citta;
    private String cap;
    private int idUtente;

    public Indirizzo() {
    }

    public Indirizzo(int id, String via, String citta, String cap, int idUtente) {
        this.id = id;
        this.via = via;
        this.citta = citta;
        this.cap = cap;
        this.idUtente = idUtente;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getVia() {
        return via;
    }

    public void setVia(String via) {
        this.via = via;
    }

    public String getCitta() {
        return citta;
    }

    public void setCitta(String citta) {
        this.citta = citta;
    }

    public String getCap() {
        return cap;
    }

    public void setCap(String cap) {
        this.cap = cap;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }
}
