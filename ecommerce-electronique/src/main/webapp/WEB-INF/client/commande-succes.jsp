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
            gold: '#C5A028',
            'gold-dark': '#9A7D1D',
            'tech-black': '#121212',
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
    .success-icon-anim { animation: successPop 0.5s cubic-bezier(0.34,1.56,0.64,1) 0.2s both; }
    body { background-color: #ffffff; color: #121212; }
  </style>
</head>
<body class="min-h-screen font-sans antialiased">
<%@ include file="../common/navbar.jsp" %>

<main class="max-w-2xl mx-auto px-4 py-16">
  <div class="text-center">
    
    <div class="success-icon-anim inline-flex items-center justify-center w-24 h-24 border-4 border-black rounded-full mb-8 text-4xl bg-white shadow-[8px_8px_0px_0px_rgba(0,0,0,1)]">
      ✅
    </div>

    <h1 class="font-display text-4xl font-extrabold tracking-tighter uppercase mb-2">
      Commande <span class="bg-black text-white px-2">confirmée</span>
    </h1>
    <p class="text-gray-500 font-medium mb-12">
      Merci pour votre confiance, <span class="text-black font-bold">${sessionScope.client.prenom}</span> 🎉
    </p>

    <div class="border-4 border-black p-8 mb-10 text-left bg-white shadow-[12px_12px_0px_0px_rgba(0,0,0,1)]">
      <div class="flex flex-wrap justify-between items-end gap-4 mb-8 pb-6 border-b-2 border-black border-dashed">
        <div>
          <div class="text-[10px] uppercase tracking-widest font-black text-gray-400 mb-1">Référence</div>
          <div class="font-mono text-xl font-bold italic">#${commande.id}</div>
        </div>
        <div class="text-right">
          <div class="text-[10px] uppercase tracking-widest font-black text-gray-400 mb-1">Montant Total</div>
          <div class="font-display text-3xl font-black">
            <fmt:formatNumber value="${commande.total}" pattern="#,##0.00"/> €
          </div>
        </div>
      </div>

      <div class="space-y-3 mb-8">
        <c:forEach var="ligne" items="${commande.lignes}">
          <div class="flex justify-between items-center group">
            <span class="text-sm font-bold uppercase tracking-tight text-gray-600 group-hover:text-black transition-colors">
              ${ligne.produit.nom} <span class="text-xs text-gray-400 font-normal">x${ligne.quantite}</span>
            </span>
            <span class="font-bold">
              <fmt:formatNumber value="${ligne.sousTotal}" pattern="#,##0.00"/> €
            </span>
          </div>
        </c:forEach>
      </div>

      <div class="pt-6 border-t-2 border-black text-[11px] font-bold uppercase tracking-wider text-gray-500 flex gap-2">
        <span class="text-black">📍 Destination:</span> 
        <span class="italic font-medium">${commande.adresseLivraison}</span>
      </div>
    </div>

    <div class="flex flex-col sm:flex-row gap-4 justify-center">
      <a href="${pageContext.request.contextPath}/commande/historique"
         class="px-8 py-4 bg-black text-white font-black uppercase text-xs tracking-[0.2em] hover:bg-gold hover:text-black transition-all duration-300 transform hover:-translate-y-1 shadow-lg">
        📦 Mes commandes
      </a>
      <a href="${pageContext.request.contextPath}/catalogue"
         class="px-8 py-4 bg-white text-black border-4 border-black font-black uppercase text-xs tracking-[0.2em] hover:bg-gold hover:border-gold transition-all duration-300 transform hover:-translate-y-1 shadow-lg">
        🏪 Continuer mes achats
      </a>
    </div>

  </div>
</main>

<footer class="mt-20 border-t-2 border-black py-10">
  <div class="max-w-7xl mx-auto px-4 text-center">
    <p class="text-[10px] font-black uppercase tracking-[0.3em] text-gray-400">
      © 2026 TechShop — Premium Electronics
    </p>
  </div>
</footer>

</body>
</html>