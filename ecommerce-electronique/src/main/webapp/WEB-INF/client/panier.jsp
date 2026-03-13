<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="activePage" value="panier" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mon Panier — TechShop</title>
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
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
  <style>
    .item-card { border-bottom: 1px solid rgba(255,255,255,0.07); transition: all 0.2s ease; }
    .item-card:hover { background-color: rgba(255,255,255,0.03); }

    .scroll-custom::-webkit-scrollbar { width: 5px; }
    .scroll-custom::-webkit-scrollbar-track { background: rgba(255,255,255,0.05); border-radius: 4px; }
    .scroll-custom::-webkit-scrollbar-thumb { background: #D4AF37; border-radius: 4px; }
    .scroll-custom::-webkit-scrollbar-thumb:hover { background: #B8860B; }
  </style>
</head>
<body class="bg-[#0B0F1A] text-gray-100 min-h-screen font-sans antialiased">

<%@ include file="../common/navbar.jsp" %>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

  <%-- Breadcrumb + Titre --%>
  <div class="mb-10">
    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-gray-500 mb-4">
      <a href="${pageContext.request.contextPath}/catalogue" class="hover:text-gold transition-colors">Catalogue</a>
      <span>/</span>
      <span class="text-gold font-bold">Panier</span>
    </nav>
    <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
      Mon <span class="text-gold">Panier</span>
    </h1>
    <p class="text-gray-400 text-sm mt-1">Vérifiez vos articles avant de passer commande.</p>
  </div>

  <%-- Message d'erreur --%>
  <c:if test="${not empty erreur}">
    <div class="mb-6 p-4 bg-rose-500/10 border border-rose-500/30 rounded-2xl flex items-center gap-3 text-rose-400">
      <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
      </svg>
      <span class="text-sm font-medium">${erreur}</span>
    </div>
  </c:if>

  <c:choose>
    <%-- Panier vide --%>
    <c:when test="${empty panierItems}">
      <div class="text-center py-24 bg-gray-900/20 rounded-3xl border border-dashed border-gray-800">
        <svg class="w-16 h-16 mx-auto mb-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
        </svg>
        <h2 class="text-2xl font-display font-bold mb-3 text-gray-300">Votre panier est vide</h2>
        <p class="text-gray-500 text-sm mb-8">Découvrez nos produits et ajoutez-en au panier.</p>
        <a href="${pageContext.request.contextPath}/catalogue"
           class="inline-block px-8 py-3 bg-gold text-dark-bg font-bold rounded-xl hover:bg-gold-dark transition-colors text-sm uppercase tracking-widest">
          Retour au catalogue
        </a>
      </div>
    </c:when>

    <%-- Panier avec articles --%>
    <c:otherwise>
      <div class="flex flex-col lg:flex-row gap-10 items-start">

        <%-- Liste des articles --%>
        <div class="flex-1 w-full">
          <div class="bg-gray-900/40 border border-gray-800 rounded-2xl overflow-hidden">

            <%-- Header colonne --%>
            <div class="hidden md:grid grid-cols-12 gap-4 px-6 py-3 border-b border-gray-800 text-[10px] font-bold uppercase tracking-widest text-gray-500">
              <span class="col-span-5">Produit</span>
              <span class="col-span-3 text-center">Quantité</span>
              <span class="col-span-2 text-right">Prix unit.</span>
              <span class="col-span-2 text-right">Sous-total</span>
            </div>

            <%-- Scroll --%>
            <div class="max-h-[480px] overflow-y-auto scroll-custom divide-y divide-gray-800/60">
              <c:forEach var="item" items="${panierItems}">
                <div class="item-card px-6 py-6 grid grid-cols-12 gap-4 items-center">

                  <%-- Image + Infos produit --%>
                  <div class="col-span-12 md:col-span-5 flex items-center gap-4">
                    <div class="w-16 h-16 bg-gray-800 rounded-xl overflow-hidden shrink-0 flex items-center justify-center border border-gray-700">
                      <c:choose>
                        <c:when test="${not empty item.produit.imageUrl}">
                          <img src="${pageContext.request.contextPath}/images/logo.png"
                               alt="${item.produit.nom}" class="max-h-full max-w-full object-contain opacity-80 hover:opacity-100 transition-opacity">
                        </c:when>
                        <c:otherwise>
                          <span class="text-[9px] font-bold text-gray-600 uppercase">No img</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div>
                      <span class="text-[10px] font-bold text-gold uppercase tracking-tighter">${item.produit.marque}</span>
                      <h3 class="font-medium text-gray-100 leading-snug line-clamp-2 hover:text-gold transition-colors">${item.produit.nom}</h3>
                      <form action="${pageContext.request.contextPath}/panier/supprimer" method="post" class="inline">
                        <input type="hidden" name="itemId" value="${item.id}">
                        <button type="submit"
                                onclick="return confirm('Retirer cet article ?')"
                                class="text-[10px] text-gray-600 hover:text-rose-400 transition-colors mt-1 uppercase tracking-widest">
                          Supprimer
                        </button>
                      </form>
                    </div>
                  </div>

                  <%-- Quantité --%>
                  <div class="col-span-6 md:col-span-3 flex justify-center">
                    <form action="${pageContext.request.contextPath}/panier/modifier" method="post" class="flex items-center gap-1">
                      <input type="hidden" name="itemId" value="${item.id}">
                      <button type="button"
                              onclick="changeQty(${item.id}, -1)"
                              class="w-7 h-7 rounded-lg bg-gray-800 border border-gray-700 text-gray-300 hover:bg-gold hover:text-dark-bg hover:border-gold transition-all font-bold text-sm">−</button>
                      <span class="w-10 text-center font-bold text-sm text-white" id="qty-${item.id}">${item.quantite}</span>
                      <button type="button"
                              onclick="changeQty(${item.id}, 1, ${item.produit.stock})"
                              class="w-7 h-7 rounded-lg bg-gray-800 border border-gray-700 text-gray-300 hover:bg-gold hover:text-dark-bg hover:border-gold transition-all font-bold text-sm">+</button>
                      <input type="hidden" name="quantite" id="qty-input-${item.id}" value="${item.quantite}">
                      <button type="submit"
                              class="ml-2 px-3 py-1 text-[9px] font-bold uppercase tracking-widest bg-gray-800 border border-gray-700 text-gray-400 hover:bg-gold hover:text-dark-bg hover:border-gold transition-all rounded-lg">
                        Màj
                      </button>
                    </form>
                  </div>

                  <%-- Prix unitaire --%>
                  <div class="col-span-3 md:col-span-2 text-right">
                    <span class="text-sm font-medium text-gray-400">
                      <fmt:formatNumber value="${item.produit.prix}" pattern="#,##0.00"/> €
                    </span>
                  </div>

                  <%-- Sous-total --%>
                  <div class="col-span-3 md:col-span-2 text-right">
                    <span class="text-base font-bold text-white">
                      <fmt:formatNumber value="${item.sousTotal}" pattern="#,##0.00"/> €
                    </span>
                  </div>

                </div>
              </c:forEach>
            </div>
          </div>

          <div class="mt-5">
            <a href="${pageContext.request.contextPath}/catalogue"
               class="inline-flex items-center gap-2 text-xs font-bold uppercase tracking-widest text-gray-500 hover:text-gold transition-colors">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
              </svg>
              Continuer le shopping
            </a>
          </div>
        </div>

        <%-- Récapitulatif --%>
        <aside class="lg:w-80 w-full shrink-0">
          <div class="bg-gray-900/40 border border-gray-800 rounded-2xl p-6 sticky top-8">
            <h2 class="text-xl font-display font-bold mb-6 tracking-tight">
              Récapitulatif <span class="text-gold">de commande</span>
            </h2>

            <div class="space-y-3 text-sm border-b border-gray-800 pb-5 mb-5">
              <div class="flex justify-between text-gray-400">
                <span>Sous-total</span>
                <span class="text-white font-medium"><fmt:formatNumber value="${total}" pattern="#,##0.00"/> €</span>
              </div>
              <div class="flex justify-between text-gray-400">
                <span>Livraison</span>
                <span class="text-emerald-500 font-medium">Gratuite</span>
              </div>
              <div class="flex justify-between text-gray-400">
                <span>TVA incluse</span>
                <span class="text-gray-500 text-xs">20%</span>
              </div>
            </div>

            <div class="flex justify-between items-baseline mb-7">
              <span class="font-bold text-gray-300 uppercase text-sm tracking-widest">Total TTC</span>
              <span class="text-3xl font-display font-bold text-white">
                <fmt:formatNumber value="${total}" pattern="#,##0.00"/> €
              </span>
            </div>

            <a href="${pageContext.request.contextPath}/commande/validerPanier"
               class="block w-full text-center bg-gold text-dark-bg py-3.5 font-bold rounded-xl hover:bg-gold-dark transition-colors text-sm uppercase tracking-widest shadow-lg shadow-gold/10 hover:shadow-gold/20">
              Procéder au paiement
            </a>

            <div class="mt-5 flex items-center justify-center gap-2 text-[10px] text-gray-600 uppercase tracking-widest">
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
              </svg>
              Paiement sécurisé SSL · Retours 30 jours
            </div>
          </div>
        </aside>

      </div>
    </c:otherwise>
  </c:choose>
</main>

<%@ include file="../common/foot.jsp" %>

<script>
  function changeQty(itemId, delta, max) {
    let display = document.getElementById('qty-' + itemId);
    let current = parseInt(display.textContent);
    let newQty = current + delta;
    if (newQty < 1) newQty = 1;
    if (max && newQty > max) { alert('Stock maximum atteint (' + max + ')'); return; }
    display.textContent = newQty;
    document.getElementById('qty-input-' + itemId).value = newQty;
  }
</script>
</body>
</html>
