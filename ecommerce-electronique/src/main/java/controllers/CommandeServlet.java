package controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;

import models.Client;
import models.Commande;
import models.PanierItem;
import controllers.services.CommandeService;
import controllers.services.PanierServices;

import java.util.List;

/**
 * Servlet de gestion des commandes client.
 * Protégée par AuthFilter (RM-01 : authentification obligatoire).
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/commande/validerPanier", "/commande/historique", "/commande/detail"})
public class CommandeServlet extends HttpServlet {

    private CommandeService commandeService;
    private PanierServices panierService;

    @Override
    public void init() {
        commandeService = new CommandeService();
        panierService=new PanierServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/commande/historique":
                afficherHistorique(req, resp);
                break;
            case "/commande/validerPanier":
                // GET : afficher la page de confirmation
            	afficherPanier(req,resp);
                break;
            case "/commande/detail":
                afficherDetail(req, resp);
                break;
        }
    }
    
    private void afficherPanier(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Client client = getClientFromSession(req);
        List<PanierItem> items = panierService.getPanier(client.getId());
        BigDecimal total = panierService.calculerTotal(items);


        req.setAttribute("panierItems", items);
        req.setAttribute("total", total);
        req.getRequestDispatcher("/WEB-INF/client/confirmation-commande.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        if ("/commande/validerPanier".equals(req.getServletPath())) {
            validerCommande(req, resp);
        }
    }

    private void validerCommande(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        Client client = getClientFromSession(req);
        String adresse = req.getParameter("adresseLivraison");

        try {
            Commande commande = commandeService.validerCommande(client, adresse);
            req.setAttribute("commande", commande);
            req.getRequestDispatcher("/WEB-INF/client/commande-succes.jsp")
               .forward(req, resp);

        } catch (CommandeService.StockInsuffisantException e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/client/confirmation-commande.jsp")
               .forward(req, resp);

        } catch (CommandeService.CommandeException e) {
            req.setAttribute("erreur", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/panier");
        }
    }

    private void afficherHistorique(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Client client = getClientFromSession(req);
        List<Commande> commandes = commandeService.getHistoriqueClient(client.getId());
        System.out.println(commandes);
        req.setAttribute("commandes", commandes);
        req.getRequestDispatcher("/WEB-INF/client/historique-commandes.jsp")
           .forward(req, resp);
    }

    private void afficherDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            commandeService.getCommandeById(id).ifPresentOrElse(
                c -> {
                    try {
                        req.setAttribute("commande", c);
                        req.getRequestDispatcher("/WEB-INF/client/detail-commande.jsp")
                           .forward(req, resp);
                    } catch (Exception e) { throw new RuntimeException(e); }
                },
                () -> {
                    try { resp.sendError(HttpServletResponse.SC_NOT_FOUND); }
                    catch (IOException e) { throw new RuntimeException(e); }
                }
            );
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/commande/historique");
        }
    }

    private Client getClientFromSession(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (Client) session.getAttribute("client");
    }
}