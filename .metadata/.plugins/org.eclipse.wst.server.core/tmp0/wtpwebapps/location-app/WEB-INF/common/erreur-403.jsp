<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Accès refusé — TechShop</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body style="display:flex;align-items:center;justify-content:center;min-height:100vh;text-align:center;">
  <div style="max-width:480px;padding:3rem;" class="fade-up">
    <div style="font-size:5rem;margin-bottom:1rem;" aria-hidden="true">🔒</div>
    <h1 style="font-family:var(--font-display);font-size:5rem;font-weight:800;color:var(--red-alert);letter-spacing:-0.05em;line-height:1;">403</h1>
    <h2 style="font-family:var(--font-display);font-size:1.5rem;font-weight:600;margin-bottom:0.75rem;">Accès refusé</h2>
    <p style="color:var(--text-secondary);margin-bottom:2rem;line-height:1.7;">
      Vous n'avez pas les permissions nécessaires pour accéder à cette page.
      Cette zone est réservée aux administrateurs (AdminFilter — PAQ).
    </p>
    <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/catalogue" class="btn btn-primary">← Retour au catalogue</a>
      <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost">Se connecter</a>
    </div>
  </div>
</body>
</html>
