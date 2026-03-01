package controllers;



import models.Client;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filtre de contrôle d'accès administrateur.
 * Protège toutes les routes /admin/* et vérifie le rôle ADMIN.
 */
@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("client") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Client client = (Client) session.getAttribute("client");
        if (!client.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Accès refusé : rôle ADMIN requis");
            return;
        }

        chain.doFilter(request, response);
    }
}