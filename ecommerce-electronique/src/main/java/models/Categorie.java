package models;

import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entité JPA représentant une catégorie de produits électroniques.
 */
@Entity
@Table(name = "categorie")
public class Categorie  implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 100)
    private String nom;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "categorie", fetch = FetchType.LAZY)
    private List<Produit> produits = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // ── Constructeurs ────────────────────────────────────────
    public Categorie() {}

    public Categorie(String nom, String description) {
        this.nom = nom;
        this.description = description;
    }

    // ── Getters / Setters ────────────────────────────────────
    public Integer getId()                      { return id; }
    public void setId(Integer id)               { this.id = id; }
    public String getNom()                      { return nom; }
    public void setNom(String nom)              { this.nom = nom; }
    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }
    public LocalDateTime getCreatedAt()         { return createdAt; }
    public List<Produit> getProduits()          { return produits; }
    public void setProduits(List<Produit> p)    { this.produits = p; }

    @Override
    public String toString() {
        return "Categorie{id=" + id + ", nom='" + nom + "'}";
    }
}