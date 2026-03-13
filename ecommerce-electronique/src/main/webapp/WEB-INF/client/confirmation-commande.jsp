<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="validerPanier" value="panier" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirmation de commande — TechShop</title>
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
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&family=DM+Mono&display=swap" rel="stylesheet">
</head>
<body class="bg-[#0B0F1A] text-gray-100 min-h-screen font-sans antialiased">

<%@ include file="../common/navbar.jsp" %>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

  <%-- Titre --%>
  <div class="mb-10">
    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-gray-500 mb-4">
      <a href="${pageContext.request.contextPath}/catalogue" class="hover:text-gold transition-colors">Catalogue</a>
      <span>/</span>
      <a href="${pageContext.request.contextPath}/panier" class="hover:text-gold transition-colors">Panier</a>
      <span>/</span>
      <span class="text-gold font-bold">Confirmation</span>
    </nav>
    <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
      Confirmation de <span class="text-gold">commande</span>
    </h1>
    <p class="text-gray-400 text-sm mt-1">Vérifiez votre récapitulatif et renseignez votre adresse de livraison.</p>
  </div>

  <%-- Erreur --%>
  <c:if test="${not empty erreur}">
    <div class="mb-6 p-4 bg-rose-500/10 border border-rose-500/30 rounded-2xl flex items-center gap-3 text-rose-400">
      <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
      </svg>
      <span class="text-sm font-medium">${erreur}</span>
    </div>
  </c:if>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">

    <%-- Récapitulatif panier --%>
    <div class="lg:col-span-2 bg-gray-900/40 border border-gray-800 rounded-2xl overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-800">
        <h3 class="text-lg font-display font-bold tracking-tight">
          Récapitulatif <span class="text-gold">du panier</span>
        </h3>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full">
          <thead>
            <tr class="border-b border-gray-800">
              <th class="px-6 py-3 text-left text-[10px] font-bold uppercase tracking-widest text-gray-500">Produit</th>
              <th class="px-6 py-3 text-right text-[10px] font-bold uppercase tracking-widest text-gray-500">Prix unit.</th>
              <th class="px-6 py-3 text-center text-[10px] font-bold uppercase tracking-widest text-gray-500">Qté</th>
              <th class="px-6 py-3 text-right text-[10px] font-bold uppercase tracking-widest text-gray-500">Sous-total</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-800/60">
            <c:forEach var="item" items="${panierItems}">
              <tr class="hover:bg-white/[0.02] transition-colors group">
                <td class="px-6 py-4">
                  <div class="font-medium text-gray-200 group-hover:text-white transition-colors">${item.produit.nom}</div>
                  <div class="text-[10px] font-bold text-gold uppercase tracking-tighter mt-0.5">${item.produit.marque}</div>
                </td>
                <td class="px-6 py-4 text-right text-sm text-gray-400">
                  <fmt:formatNumber value="${item.produit.prix}" pattern="#,##0.00"/> €
                </td>
                <td class="px-6 py-4 text-center">
                  <span class="font-mono text-xs font-bold bg-gray-800 text-gold px-2 py-0.5 rounded border border-gray-700">
                    ×${item.quantite}
                  </span>
                </td>
                <td class="px-6 py-4 text-right font-bold text-white">
                  <fmt:formatNumber value="${item.sousTotal}" pattern="#,##0.00"/> €
                </td>
              </tr>
            </c:forEach>
          </tbody>
          <tfoot>
            <tr class="border-t border-gray-700">
              <td colspan="3" class="px-6 py-4 text-right text-sm font-bold uppercase tracking-widest text-gray-400">
                Total TTC
              </td>
              <td class="px-6 py-4 text-right">
                <span class="text-2xl font-display font-bold text-white">
                  <fmt:formatNumber value="${total}" pattern="#,##0.00"/> €
                </span>
              </td>
            </tr>
          </tfoot>
        </table>
      </div>

      <%-- Infos client --%>
      <div class="px-6 py-5 border-t border-gray-800 bg-gray-900/30">
        <h4 class="text-xs font-bold uppercase tracking-widest text-gray-500 mb-3">Informations client</h4>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <p class="text-[10px] text-gray-600 uppercase tracking-widest">Nom</p>
            <p class="font-medium text-gray-200 mt-0.5">${sessionScope.client.nom} ${sessionScope.client.prenom}</p>
          </div>
          <div>
            <p class="text-[10px] text-gray-600 uppercase tracking-widest">Email</p>
            <p class="font-medium text-gray-200 mt-0.5">${sessionScope.client.email}</p>
          </div>
        </div>
      </div>
    </div>

    <%-- Formulaire livraison --%>
    <div class="lg:col-span-1">
      <div class="bg-gray-900/40 border border-gray-800 rounded-2xl overflow-hidden sticky top-8">
        <div class="px-6 py-4 border-b border-gray-800">
          <h3 class="text-lg font-display font-bold tracking-tight">
            Adresse de <span class="text-gold">livraison</span>
          </h3>
        </div>
        <div class="p-6">
          <form action="${pageContext.request.contextPath}/commande/validerPanier" method="post">

            <div class="mb-6">
              <label for="adresseLivraison" class="block text-xs font-bold uppercase tracking-widest text-gray-400 mb-2">
                Adresse complète
              </label>
              <textarea id="adresseLivraison"
                        name="adresseLivraison"
                        rows="4"
                        required
                        placeholder="Numéro, rue, ville, code postal…"
                        class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded-xl text-sm text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-1 focus:ring-gold transition-all resize-none">${sessionScope.client.adresseLivraison}</textarea>
            </div>

            <div class="space-y-3">
              <button type="submit"
                      class="w-full bg-gold text-dark-bg py-3 font-bold rounded-xl hover:bg-gold-dark transition-colors text-sm uppercase tracking-widest shadow-lg shadow-gold/10 hover:shadow-gold/20">
                Confirmer la commande
              </button>

              <a href="${pageContext.request.contextPath}/panier"
                 class="block w-full text-center py-3 bg-gray-800 border border-gray-700 text-gray-400 font-bold rounded-xl hover:bg-gray-700 hover:text-gray-200 transition-colors text-sm uppercase tracking-widest">
                ← Retour au panier
              </a>
            </div>

          </form>

          <div class="mt-6 flex items-center justify-center gap-2 text-[10px] text-gray-600 uppercase tracking-widest">
            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>
            Paiement sécurisé SSL
          </div>
        </div>
      </div>
    </div>

  </div>
</main>

<%@ include file="../common/foot.jsp" %>

</body>
</html>
