package controllers;


import dao.categorie.*;
import dao.produit.*;
import models.*;
import controllers.services.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

/**
 * Servlet d'administration.
 * Protégée par AdminFilter (rôle ADMIN requis).
 *
 * Routes :
 *   GET  /admin                    - Dashboard
 *   GET  /admin/produits           - Liste des produits
 *   GET  /admin/produits/nouveau   - Formulaire création
 *   POST /admin/produits/nouveau   - Création
 *   GET  /admin/produits/modifier  - Formulaire modification (?id=X)
 *   POST /admin/produits/modifier  - Modification
 *   POST /admin/produits/supprimer - Suppression logique
 *   GET  /admin/categories         - Liste des catégories
 *   POST /admin/categories/nouveau - Création catégorie
 *   POST /admin/categories/supprimer - Suppression
 *   GET  /admin/commandes          - Liste des commandes
 *   POST /admin/commandes/statut   - Changement statut
 */
@WebServlet(urlPatterns = {
    "/admin", "/admin/produits", "/admin/produits/nouveau",
    "/admin/produits/modifier", "/admin/produits/supprimer",
    "/admin/categories", "/admin/categories/nouveau", "/admin/categories/supprimer",
    "/admin/commandes", "/admin/commandes/statut"
})
public class AdminServlet extends HttpServlet {

    private ProduitDAO     produitDAO;
    private CategorieDAO   categorieDAO;
    private CommandeService commandeService;

    @Override
    public void init() {
        produitDAO      = new ProduitDAOImplement();
        categorieDAO    = new CategorieDAOImplement();
        commandeService = new CommandeService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/admin":
                showDashboard(req, resp);   break;
            case "/admin/produits":
                listProduits(req, resp);    break;
            case "/admin/produits/nouveau":
                formProduit(req, resp, null); break;
            case "/admin/produits/modifier":
                formModifierProduit(req, resp); break;
            case "/admin/categories":
                listCategories(req, resp);  break;
            case "/admin/commandes":
                listCommandes(req, resp);   break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/admin/produits/nouveau":
                creerProduit(req, resp);        break;
            case "/admin/produits/modifier":
                modifierProduit(req, resp);     break;
            case "/admin/produits/supprimer":
                supprimerProduit(req, resp);    break;
            case "/admin/categories/nouveau":
                creerCategorie(req, resp);      break;
            case "/admin/categories/supprimer":
                supprimerCategorie(req, resp);  break;
            case "/admin/commandes/statut":
                changerStatutCommande(req, resp); break;
            default:
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // ── Dashboard ────────────────────────────────────────────
    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("nbProduits",  produitDAO.findAllActive().size());
        req.setAttribute("nbCategories", categorieDAO.findAll().size());
        req.setAttribute("nbCommandes",  commandeService.getToutesLesCommandes().size());
        req.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(req, resp);
    }

    // ── Produits ─────────────────────────────────────────────
    private void listProduits(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("produits",   produitDAO.findAllActive());
        req.setAttribute("categories", categorieDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/admin/produits/liste.jsp").forward(req, resp);
    }

    private void formProduit(HttpServletRequest req, HttpServletResponse resp, Produit produit)
            throws ServletException, IOException {

        req.setAttribute("categories", categorieDAO.findAll());
        req.setAttribute("produit",    produit);
        req.getRequestDispatcher("/WEB-INF/admin/produits/formulaire.jsp").forward(req, resp);
    }

    private void formModifierProduit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            Optional<Produit> opt = produitDAO.findById(id);
            if (opt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/produits");
                return;
            }
            formProduit(req, resp, opt.get());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/produits");
        }
    }

    private void creerProduit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            Produit p = buildProduitFromRequest(req, new Produit());
            produitDAO.save(p);
            req.getSession().setAttribute("succes", "Produit créé avec succès");
            resp.sendRedirect(req.getContextPath() + "/admin/produits");
        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur lors de la création : " + e.getMessage());
            formProduit(req, resp, null);
        }
    }

    private void modifierProduit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            Optional<Produit> opt = produitDAO.findById(id);
            if (opt.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/produits");
                return;
            }
            Produit p = buildProduitFromRequest(req, opt.get());
            produitDAO.update(p);
            req.getSession().setAttribute("succes", "Produit modifié avec succès");
            resp.sendRedirect(req.getContextPath() + "/admin/produits");
        } catch (Exception e) {
            req.setAttribute("erreur", "Erreur lors de la modification : " + e.getMessage());
            listProduits(req, resp);
        }
    }

    private void supprimerProduit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            produitDAO.softDelete(id);
            req.getSession().setAttribute("succes", "Produit supprimé (suppression logique)");
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Erreur suppression : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/produits");
    }

    private Produit buildProduitFromRequest(HttpServletRequest req, Produit p) {
        p.setNom(req.getParameter("nom"));
        p.setDescription(req.getParameter("description"));
        p.setPrix(new BigDecimal(req.getParameter("prix")));
        p.setStock(Integer.parseInt(req.getParameter("stock")));
        p.setMarque(req.getParameter("marque"));
        p.setImageUrl(req.getParameter("imageUrl"));

        Integer catId = Integer.parseInt(req.getParameter("categorieId"));
        categorieDAO.findById(catId).ifPresent(p::setCategorie);
        return p;
    }

    // ── Catégories ───────────────────────────────────────────
    private void listCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("categories", categorieDAO.findAll());
        req.getRequestDispatcher("/WEB-INF/admin/categories/liste.jsp").forward(req, resp);
    }

    private void creerCategorie(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String nom  = req.getParameter("nom");
        String desc = req.getParameter("description");
        categorieDAO.save(new Categorie(nom, desc));
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    private void supprimerCategorie(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            categorieDAO.delete(id);
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Impossible de supprimer : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }

    // ── Commandes ────────────────────────────────────────────
    private void listCommandes(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String statutParam = req.getParameter("statut");
        List<Commande> commandes;

        if (statutParam != null && !statutParam.isBlank()) {
            try {
                Commande.Statut statut = Commande.Statut.valueOf(statutParam);
                commandes = commandeService.getToutesLesCommandes().stream()
                    .filter(c -> c.getStatut() == statut).toList();
            } catch (IllegalArgumentException e) {
                commandes = commandeService.getToutesLesCommandes();
            }
        } else {
            commandes = commandeService.getToutesLesCommandes();
        }

        req.setAttribute("commandes", commandes);
        req.setAttribute("statutFiltre", statutParam);
        req.getRequestDispatcher("/WEB-INF/admin/commandes/liste.jsp").forward(req, resp);
    }

    private void changerStatutCommande(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {
            Integer commandeId = Integer.parseInt(req.getParameter("commandeId"));
            Commande.Statut statut = Commande.Statut.valueOf(req.getParameter("statut"));
            commandeService.changerStatut(commandeId, statut);
            req.getSession().setAttribute("succes", "Statut de la commande mis à jour");
        } catch (CommandeService.CommandeException e) {
            req.getSession().setAttribute("erreur", e.getMessage());
        } catch (Exception e) {
            req.getSession().setAttribute("erreur", "Erreur : " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/commandes");
    }
}