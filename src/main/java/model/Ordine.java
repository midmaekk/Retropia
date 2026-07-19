package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Ordine implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int idUtente;
    private Timestamp dataOrdine;
    private BigDecimal totale;
    private String indirizzoSpedizione; // Es. "Via Roma 1, Milano 20100"
    private List<RigaOrdine> righe;

    public Ordine() {
        this.righe = new ArrayList<>();
    }

    public Ordine(int id, int idUtente, Timestamp dataOrdine, BigDecimal totale) {
        this.id = id;
        this.idUtente = idUtente;
        this.dataOrdine = dataOrdine;
        this.totale = totale;
        this.righe = new ArrayList<>();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public Timestamp getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(Timestamp dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public BigDecimal getTotale() {
        return totale;
    }

    public void setTotale(BigDecimal totale) {
        this.totale = totale;
    }

    public List<RigaOrdine> getRighe() {
        return righe;
    }

    public void setRighe(List<RigaOrdine> righe) {
        this.righe = righe;
    }
    
    public String getIndirizzoSpedizione() {
        return indirizzoSpedizione;
    }

    public void setIndirizzoSpedizione(String indirizzoSpedizione) {
        this.indirizzoSpedizione = indirizzoSpedizione;
    }

    public void addRiga(RigaOrdine riga) {
        this.righe.add(riga);
    }
}
