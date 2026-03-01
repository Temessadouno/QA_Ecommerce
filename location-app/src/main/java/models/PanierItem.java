package models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entité JPA représentant un article dans le panier d'un client.
 * Le panier est persisté en base pour être conservé entre les sessions.
 */
@Entity
@Table(name = "panier_item",
       uniqueConstraints = @UniqueConstraint(columnNames = {"client_id", "produit_id"}))
public class PanierItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "produit_id", nullable = false)
    private Produit produit;

    @Column(nullable = false)
    private int quantite = 1;

    @Column(name = "added_at", updatable = false)
    private LocalDateTime addedAt;

    @PrePersist
    protected void onCreate() {
        addedAt = LocalDateTime.now();
    }

    // ── Constructeurs ────────────────────────────────────────
    public PanierItem() {}

    public PanierItem(Client client, Produit produit, int quantite) {
        this.client = client;
        this.produit = produit;
        this.quantite = quantite;
    }

    // ── Méthodes utilitaires ─────────────────────────────────
    public java.math.BigDecimal getSousTotal() {
        return produit.getPrix().multiply(java.math.BigDecimal.valueOf(quantite));
    }

    // ── Getters / Setters ────────────────────────────────────
    public Integer getId()                          { return id; }
    public void setId(Integer id)                   { this.id = id; }
    public Client getClient()                       { return client; }
    public void setClient(Client client)            { this.client = client; }
    public Produit getProduit()                     { return produit; }
    public void setProduit(Produit produit)         { this.produit = produit; }
    public int getQuantite()                        { return quantite; }
    public void setQuantite(int quantite)           { this.quantite = quantite; }
    public LocalDateTime getAddedAt()               { return addedAt; }
}
