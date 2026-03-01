package controllers.services;


import java.util.List;
import java.util.Optional;

import dao.commande.*;
import dao.panier.*;
import dao.produit.*;
import models.*;

/**
 * Service de gestion des commandes.
 * Règles métier : RM-02 (stock), RM-03 (commande définitive), RM-05 (décrément stock).
 */
public class CommandeService {

    private final CommandeDAO commandeDAO;
    private final PanierDAO panierDAO;
    private final ProduitDAO produitDAO;

    public CommandeService() {
        this.commandeDAO = new CommandeDAOImplement();
        this.panierDAO   = new PanierDAOImplement();
        this.produitDAO  = new ProduitDAOImplement();
    }

    // Constructeur pour les tests (injection de dépendances)
    public CommandeService(CommandeDAO commandeDAO, PanierDAO panierDAO, ProduitDAO produitDAO) {
        this.commandeDAO = commandeDAO;
        this.panierDAO   = panierDAO;
        this.produitDAO  = produitDAO;
    }

    /**
     * Valide le panier du client et crée une commande.
     * RM-02 : vérifie le stock pour chaque article.
     * RM-05 : décrémente le stock après validation.
     */
    public Commande validerCommande(Client client, String adresseLivraison) {
        List<PanierItem> items = panierDAO.findByClientId(client.getId());

        if (items.isEmpty()) {
            throw new CommandeException("Le panier est vide");
        }

        // RM-02 : vérification des stocks AVANT toute modification
        for (PanierItem item : items) {
            Produit p = item.getProduit();
            if (!p.isDisponible(item.getQuantite())) {
                throw new StockInsuffisantException(
                    "Stock insuffisant pour « " + p.getNom() + " » " +
                    "(demandé : " + item.getQuantite() + ", disponible : " + p.getStock() + ")"
                );
            }
        }

        // Créer la commande
        Commande commande = new Commande(client,
            adresseLivraison != null && !adresseLivraison.isBlank()
                ? adresseLivraison
                : client.getAdresseLivraison());

        for (PanierItem item : items) {
            LigneCommande ligne = new LigneCommande(item.getProduit(), item.getQuantite());
            commande.addLigne(ligne);
        }

        Commande saved = commandeDAO.save(commande);

        // RM-05 : décrémenter le stock après validation réussie
        for (PanierItem item : items) {
            int newStock = item.getProduit().getStock() - item.getQuantite();
            produitDAO.updateStock(item.getProduit().getId(), newStock);
        }

        // Vider le panier
        panierDAO.deleteByClientId(client.getId());

        return saved;
    }

    /**
     * Change l'état d'une commande.
     * RM-03 : une commande VALIDEE est définitive.
     */
    public Commande changerStatut(Integer commandeId, Commande.Statut nouveauStatut) {
        Optional<Commande> opt = commandeDAO.findById(commandeId);
        if (opt.isEmpty()) {
            throw new CommandeException("Commande introuvable : " + commandeId);
        }

        Commande commande = opt.get();

        // RM-03 : commande VALIDEE est irréversible
        if (commande.isDefinitive()) {
            throw new CommandeException("Une commande validée ne peut plus être modifiée (règle RM-03)");
        }

        commande.setStatut(nouveauStatut);
        return commandeDAO.update(commande);
    }

    public List<Commande> getHistoriqueClient(Integer clientId) {
        return commandeDAO.findByClientId(clientId);
    }

    public List<Commande> getToutesLesCommandes() {
        return commandeDAO.findAll();
    }

    public Optional<Commande> getCommandeById(Integer id) {
        return commandeDAO.findById(id);
    }

    // ── Exceptions ───────────────────────────────────────────
    @SuppressWarnings("serial")
	public static class CommandeException extends RuntimeException {
        public CommandeException(String message) { super(message); }
    }

    @SuppressWarnings("serial")
	public static class StockInsuffisantException extends CommandeException {
        public StockInsuffisantException(String message) { super(message); }
    }
}