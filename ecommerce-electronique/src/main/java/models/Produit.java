package models;

import jakarta.persistence.*;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entité JPA représentant un produit électronique du catalogue.
 * La suppression est LOGIQUE : deleted = true (le produit reste en BDD).
 */
@Entity
@Table(name = "produit")
public class Produit  implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 200)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;

    @Column(nullable = false)
    private int stock;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(length = 100)
    private String marque;

    @Column(nullable = false)
    private boolean deleted = false;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "categorie_id", nullable = false)
    private Categorie categorie;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // ── Constructeurs ────────────────────────────────────────
    public Produit() {}

    public Produit(String nom, String description, BigDecimal prix, int stock,
                   String marque, String imageUrl, Categorie categorie) {
        this.nom = nom;
        this.description = description;
        this.prix = prix;
        this.stock = stock;
        this.marque = marque;
        this.imageUrl = imageUrl;
        this.categorie = categorie;
    }

    // ── Méthodes utilitaires ─────────────────────────────────
    public boolean isEnStock() {
        return !deleted && stock > 0;
    }

    public boolean isDisponible(int quantite) {
        return !deleted && stock >= quantite;
    }

    // ── Getters / Setters ────────────────────────────────────
    public Integer getId()                          { return id; }
    public void setId(Integer id)                   { this.id = id; }
    public String getNom()                          { return nom; }
    public void setNom(String nom)                  { this.nom = nom; }
    public String getDescription()                  { return description; }
    public void setDescription(String desc)         { this.description = desc; }
    public BigDecimal getPrix()                     { return prix; }
    public void setPrix(BigDecimal prix)            { this.prix = prix; }
    public int getStock()                           { return stock; }
    public void setStock(int stock)                 { this.stock = stock; }
    public String getImageUrl()                     { return imageUrl; }
    public void setImageUrl(String imageUrl)        { this.imageUrl = imageUrl; }
    public String getMarque()                       { return marque; }
    public void setMarque(String marque)            { this.marque = marque; }
    public boolean isDeleted()                      { return deleted; }
    public void setDeleted(boolean deleted)         { this.deleted = deleted; }
    public Categorie getCategorie()                 { return categorie; }
    public void setCategorie(Categorie categorie)   { this.categorie = categorie; }
    public LocalDateTime getCreatedAt()             { return createdAt; }
    public LocalDateTime getUpdatedAt()             { return updatedAt; }

    @Override
    public String toString() {
        return "Produit{id=" + id + ", nom='" + nom + "', prix=" + prix + ", stock=" + stock + "}";
    }
}