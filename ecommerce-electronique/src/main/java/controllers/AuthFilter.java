package controllers;

import controllers.services.PanierServices; // Importez votre service
import models.Client;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/panier/*", "/commande/*", "/client/*", "/catalogue", "/admin/*"})
public class AuthFilter implements Filter {

    private PanierServices panierService;

    @Override
    public void init(FilterConfig filterConfig) {
        panierService = new PanierServices();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        
        String path = req.getServletPath();

     // 1. EXCLUSION ROBUSTE DES RESSOURCES STATIQUES
        // On vérifie l'extension du fichier plutôt que le début du chemin
        String requestURI = req.getRequestURI().toLowerCase();
        
        if (requestURI.endsWith(".css") || 
            requestURI.endsWith(".js") || 
            requestURI.endsWith(".jpg") || 
            requestURI.endsWith(".jpeg") || 
            requestURI.endsWith(".png") || 
            requestURI.endsWith(".gif") || 
            requestURI.endsWith(".svg")) {
            
            chain.doFilter(request, response);
            return;
        }
        
        
        HttpSession session = req.getSession(false);
        Client client = (session != null) ? (Client) session.getAttribute("client") : null;

        if (client == null) {

            if (path.equals("/catalogue") || path.equals("/commande/validerPanier")) {
                chain.doFilter(request, response);
                return;
            }

            String url = req.getRequestURI();
            if (req.getQueryString() != null) url += "?" + req.getQueryString();
            req.getSession(true).setAttribute("redirectAfterLogin", url);

            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            // Client connecté : mettre à jour le compteur panier
            int count = panierService.getPanierCount(client.getId());
            session.setAttribute("nbArticles", count);
            chain.doFilter(request, response);
        }
    }
}