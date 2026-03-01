<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="commandes" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Commande confirmée — TechShop</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&family=DM+Mono:wght@400&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
  <style>
    @keyframes successPop {
      0%   { transform: scale(0.5); opacity: 0; }
      70%  { transform: scale(1.1); }
      100% { transform: scale(1);   opacity: 1; }
    }
    .success-icon { animation: successPop 0.5s cubic-bezier(0.34,1.56,0.64,1) 0.2s both; }
    @keyframes confetti {
      0%   { transform: translateY(-100%) rotate(0deg); opacity: 1; }
      100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
    }
  </style>
</head>
<body>
<%@ include file="../common/navbar.jsp" %>

<div class="page-wrapper" style="max-width:680px;">
  <div style="text-align:center;padding:3rem 2rem;" class="fade-up">
    <div class="success-icon" style="display:inline-block;width:90px;height:90px;background:rgba(76,219,143,0.15);
         border:2px solid rgba(76,219,143,0.4);border-radius:50%;
         display:flex;align-items:center;justify-content:center;
         font-size:2.5rem;margin:0 auto 1.5rem;" aria-hidden="true" role="presentation">
      ✅
    </div>

    <h1 style="font-family:var(--font-display);font-size:2rem;font-weight:800;
               letter-spacing:-0.03em;margin-bottom:0.5rem;">
      Commande <span style="color:var(--green-ok);">confirmée</span> !
    </h1>
    <p style="color:var(--text-secondary);margin-bottom:2.5rem;font-size:1rem;">
      Merci pour votre achat, ${sessionScope.client.prenom} 🎉
    </p>

    <%-- Récapitulatif --%>
    <div class="card" style="text-align:left;margin-bottom:1.5rem;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.25rem;flex-wrap:wrap;gap:0.75rem;">
        <div>
          <div style="font-size:0.75rem;color:var(--text-muted);margin-bottom:0.2rem;">Numéro de commande</div>
          <div style="font-family:var(--font-mono);font-size:1.1rem;color:var(--gold);font-weight:600;">
            #${commande.id}
          </div>
        </div>
        <div style="text-align:right;">
          <div style="font-size:0.75rem;color:var(--text-muted);margin-bottom:0.2rem;">Total</div>
          <div style="font-family:var(--font-display);font-size:1.5rem;font-weight:800;color:var(--gold);">
            <fmt:formatNumber value="${commande.total}" pattern="#,##0.00"/> €
          </div>
        </div>
      </div>

      <div style="border-top:1px solid var(--border);padding-top:1rem;">
        <c:forEach var="ligne" items="${commande.lignes}">
          <div style="display:flex;justify-content:space-between;padding:0.4rem 0;font-size:0.85rem;">
            <span style="color:var(--text-secondary);">
              ${ligne.produit.nom} ×${ligne.quantite}
            </span>
            <span style="color:var(--text-primary);">
              <fmt:formatNumber value="${ligne.sousTotal}" pattern="#,##0.00"/> €
            </span>
          </div>
        </c:forEach>
      </div>

      <div style="margin-top:1rem;padding-top:0.75rem;border-top:1px solid var(--border);
                  font-size:0.8rem;color:var(--text-muted);">
        📍 Livraison à : ${commande.adresseLivraison}
      </div>
    </div>

    <div style="display:flex;gap:1rem;justify-content:center;flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/commande/historique"
         class="btn btn-secondary">
        📦 Mes commandes
      </a>
      <a href="${pageContext.request.contextPath}/catalogue"
         class="btn btn-ghost">
        🏪 Continuer mes achats
      </a>
    </div>
  </div>
</div>

<footer class="site-footer"><p>© 2025 TechShop</p></footer>
</body>
</html>
