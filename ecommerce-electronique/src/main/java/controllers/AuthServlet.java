package controllers;

import controllers.services.AuthService;
import models.Client;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;



/**
 * Servlet gérant l'authentification (login/logout) et l'inscription.
 * Pattern MVC : Controller uniquement – aucun HTML produit directement.
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = {"/login", "/logout", "/inscription"})
public class AuthServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() {
        authService = new AuthService();
    }

    // ── GET : affichage des formulaires ──────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/login":
                // Si déjà connecté, rediriger vers le catalogue
                if (req.getSession(false) != null && req.getSession(false).getAttribute("client") != null) {
                    resp.sendRedirect(req.getContextPath() + "/catalogue");
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/common/login.jsp").forward(req, resp);
                break;

            case "/inscription":
                req.getRequestDispatcher("/WEB-INF/common/inscription.jsp").forward(req, resp);
                break;

            case "/logout":
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                resp.sendRedirect(req.getContextPath() + "/catalogue");
                break;

            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ── POST : traitement des formulaires ────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/login":
                handleLogin(req, resp);
                break;
            case "/inscription":
                handleInscription(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            Client client = authService.authentifier(email, password);

            // Créer la session et y stocker le client
            HttpSession session = req.getSession(true);
            session.setAttribute("client", client);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            // Redirection selon le rôle
            if (client.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else {
                String redirect = (String) session.getAttribute("redirectAfterLogin");
                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    resp.sendRedirect(redirect);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/catalogue");
                }
            }

        } catch (AuthService.AuthException e) {
            req.setAttribute("erreur", e.getMessage());
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/common/login.jsp").forward(req, resp);
        }
    }

    private void handleInscription(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String nom      = req.getParameter("nom");
        String prenom   = req.getParameter("prenom");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String adresse  = req.getParameter("adresse");

        try {
            authService.inscrire(nom, prenom, email, password, adresse);
            req.setAttribute("succes", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            req.getRequestDispatcher("/WEB-INF/common/login.jsp").forward(req, resp);

        } catch (AuthService.AuthException e) {
            req.setAttribute("erreur", e.getMessage());
            req.setAttribute("nom", nom);
            req.setAttribute("prenom", prenom);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/common/inscription.jsp").forward(req, resp);
        }
    }
}