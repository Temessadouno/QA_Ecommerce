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
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            gold: '#D4AF37',
            'gold-dark': '#B8860B',
            'dark-bg': '#0B0F1A',
          },
          fontFamily: {
            display: ['Syne', 'sans-serif'],
            sans: ['DM Sans', 'sans-serif'],
            mono: ['DM Mono', 'monospace'],
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&family=DM+Mono:wght@400&display=swap" rel="stylesheet">
  <style>
    @keyframes successPop {
      0%   { transform: scale(0.5); opacity: 0; }
      70%  { transform: scale(1.1); }
      100% { transform: scale(1);   opacity: 1; }
    }
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(20px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .success-icon-anim { animation: successPop 0.5s cubic-bezier(0.34,1.56,0.64,1) 0.2s both; }
    .fade-up { animation: fadeUp 0.5s ease 0.4s both; }
    .fade-up-2 { animation: fadeUp 0.5s ease 0.6s both; }
    .fade-up-3 { animation: fadeUp 0.5s ease 0.8s both; }
  </style>
</head>
<body class="bg-[#0B0F1A] text-gray-100 min-h-screen font-sans antialiased">

<%@ include file="../common/navbar.jsp" %>

<main class="max-w-2xl mx-auto px-4 py-16">
  <div class="text-center">

    <%-- Icône succès --%>
    <div class="success-icon-anim inline-flex items-center justify-center w-24 h-24 rounded-full mb-8 bg-emerald-500/10 border-2 border-emerald-500/40">
      <svg class="w-12 h-12 text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
      </svg>
    </div>

    <%-- Titre --%>
    <h1 class="font-display text-4xl md:text-5xl font-bold tracking-tight mb-3 fade-up">
      Commande <span class="text-gold">confirmée</span>
    </h1>
    <p class="text-gray-400 text-base mb-12 fade-up">
      Merci pour votre confiance,
      <span class="text-white font-bold">${sessionScope.client.prenom}</span> 🎉
    </p>

    <%-- Card récapitulatif --%>
    <div class="bg-gray-900/40 border border-gray-800 rounded-2xl p-8 mb-8 text-left fade-up-2">

      <%-- Référence + Total --%>
      <div class="flex flex-wrap justify-between items-end gap-4 mb-7 pb-6 border-b border-gray-800">
        <div>
          <div class="text-[10px] uppercase tracking-widest font-bold text-gray-500 mb-1">Référence</div>
          <div class="font-mono text-xl font-bold text-gold"># ${commande.id}</div>
        </div>
        <div class="text-right">
          <div class="text-[10px] uppercase tracking-widest font-bold text-gray-500 mb-1">Montant total</div>
          <div class="font-display text-3xl font-bold text-white">
            <fmt:formatNumber value="${commande.total}" pattern="#,##0.00"/> €
          </div>
        </div>
      </div>

      <%-- Lignes produits --%>
      <div class="space-y-2 mb-7">
        <c:forEach var="ligne" items="${commande.lignes}">
          <div class="flex justify-between items-center py-2 border-b border-gray-800/50 group hover:bg-white/[0.02] px-2 rounded-lg transition-colors">
            <div class="flex items-center gap-3">
              <span class="font-mono text-xs font-bold bg-gray-800 text-gold px-1.5 py-0.5 rounded border border-gray-700 group-hover:bg-gold group-hover:text-dark-bg transition-colors">
                ×${ligne.quantite}
              </span>
              <span class="text-sm font-medium text-gray-300 group-hover:text-white transition-colors">
                ${ligne.produit.nom}
              </span>
            </div>
            <span class="font-bold text-white text-sm shrink-0 ml-4">
              <fmt:formatNumber value="${ligne.sousTotal}" pattern="#,##0.00"/> €
            </span>
          </div>
        </c:forEach>
      </div>

      <%-- Adresse --%>
      <div class="pt-5 border-t border-gray-800 flex items-center gap-2 text-xs text-gray-500">
        <svg class="w-4 h-4 text-gray-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
        </svg>
        <span class="uppercase tracking-widest">Livraison :</span>
        <span class="text-gray-400 font-medium">${commande.adresseLivraison}</span>
      </div>
    </div>

    <%-- Boutons CTA --%>
    <div class="flex flex-col sm:flex-row gap-4 justify-center fade-up-3">
      <a href="${pageContext.request.contextPath}/commande/historique"
         class="inline-flex items-center justify-center gap-2 px-8 py-3.5 bg-gold text-dark-bg font-bold rounded-xl hover:bg-gold-dark transition-colors text-sm uppercase tracking-widest shadow-lg shadow-gold/10">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
        </svg>
        Mes commandes
      </a>
      <a href="${pageContext.request.contextPath}/catalogue"
         class="inline-flex items-center justify-center gap-2 px-8 py-3.5 bg-gray-800 border border-gray-700 text-gray-300 font-bold rounded-xl hover:bg-gray-700 hover:text-white transition-colors text-sm uppercase tracking-widest">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16l-4-4m0 0l4-4m-4 4h18"/>
        </svg>
        Continuer mes achats
      </a>
    </div>

  </div>
</main>

<%@ include file="../common/foot.jsp" %>

</body>
</html>
