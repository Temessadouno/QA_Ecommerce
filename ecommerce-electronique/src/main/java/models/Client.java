package models;


import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Entité JPA représentant un utilisateur du système (Client ou Administrateur).
 */
@Entity
@Table(name = "client")
public class Client  implements Serializable {

    public enum Role { CLIENT, ADMIN }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nom;

    @Column(nullable = false, length = 100)
    private String prenom;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "mot_de_passe_hash", nullable = false, length = 255)
    private String motDePasseHash;

    @Column(name = "adresse_livraison", columnDefinition = "TEXT")
    private String adresseLivraison;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private Role role = Role.CLIENT;

    @Column(nullable = false)
    private boolean actif = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "client", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Commande> commandes = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // ── Constructeurs ────────────────────────────────────────
    public Client() {}

    public Client(String nom, String prenom, String email, String motDePasseHash, String adresseLivraison) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasseHash = motDePasseHash;
        this.adresseLivraison = adresseLivraison;
    }

    // ── Méthodes utilitaires ─────────────────────────────────
    public String getNomComplet() {
        return prenom + " " + nom;
    }

    public boolean isAdmin() {
        return Role.ADMIN.equals(this.role);
    }

    // ── Getters / Setters ────────────────────────────────────
    public Integer getId()                          { return id; }
    public void setId(Integer id)                   { this.id = id; }
    public String getNom()                          { return nom; }
    public void setNom(String nom)                  { this.nom = nom; }
    public String getPrenom()                       { return prenom; }
    public void setPrenom(String prenom)            { this.prenom = prenom; }
    public String getEmail()                        { return email; }
    public void setEmail(String email)              { this.email = email; }
    public String getMotDePasseHash()               { return motDePasseHash; }
    public void setMotDePasseHash(String h)         { this.motDePasseHash = h; }
    public String getAdresseLivraison()             { return adresseLivraison; }
    public void setAdresseLivraison(String adr)     { this.adresseLivraison = adr; }
    public Role getRole()                           { return role; }
    public void setRole(Role role)                  { this.role = role; }
    public boolean isActif()                        { return actif; }
    public void setActif(boolean actif)             { this.actif = actif; }
    public LocalDateTime getCreatedAt()             { return createdAt; }
    public List<Commande> getCommandes()            { return commandes; }
    public void setCommandes(List<Commande> c)      { this.commandes = c; }

    @Override
    public String toString() {
        return "Client{id=" + id + ", email='" + email + "', role=" + role + "}";
    }
}