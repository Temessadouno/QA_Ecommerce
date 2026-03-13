<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="activePage" value="catalogue" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${produit.nom} — TechShop</title>
  <!-- TailwindCSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- Configuration Tailwind personnalisée -->
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            gold: '#D4AF37',
            'gold-dark': '#B8860B',
            'blue-ice': '#7eb8f7',
            'green-ok': '#4cdb8f',
            'red-alert': '#f06060',
            'text-muted': '#9ca3af',
            'text-secondary': '#d1d5db',
            'border': '#374151',
          },
          fontFamily: {
            display: ['Syne', 'sans-serif'],
            sans: ['DM Sans', 'sans-serif'],
            mono: ['DM Mono', 'monospace'],
          },
          animation: {
            'fade-up': 'fadeUp 0.6s ease-out forwards',
          },
          keyframes: {
            fadeUp: {
              '0%': { opacity: '0', transform: 'translateY(20px)' },
              '100%': { opacity: '1', transform: 'translateY(0)' },
            }
          }
        }
      }
    }
  </script>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet">
</head>
<body class="bg-gradient-to-br from-gray-950 via-gray-900 to-gray-950 text-gray-100 min-h-screen font-sans antialiased">
<%@ include file="navbar.jsp" %>

<!-- Main Content -->
<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 md:py-12">

  <!-- Fil d'Ariane -->
  <div class="flex items-center gap-2 text-sm text-gray-500 mb-8 animate-fade-up">
    <a href="${pageContext.request.contextPath}/catalogue" class="hover:text-gold transition-colors">Catalogue</a>
    <span class="text-gray-600" aria-hidden="true">›</span>
    <a href="${pageContext.request.contextPath}/catalogue?categorie=${produit.categorie.id}" 
       class="hover:text-gold transition-colors">${produit.categorie.nom}</a>
    <span class="text-gray-600" aria-hidden="true">›</span>
    <span class="text-gray-400">${produit.nom}</span>
  </div>

  <!-- Grid produit -->
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12 animate-fade-up">

    <!-- Image -->
    <div>
      <div class="bg-gray-800/30 border border-gray-700 rounded-3xl p-8 flex items-center justify-center min-h-[400px]">
        <c:choose>
          <c:when test="${not empty produit.imageUrl}">
            <img src="${pageContext.request.contextPath}/images/logo.png"
                 alt="${produit.nom}" 
                 class="max-h-[340px] w-auto object-contain"
                 onerror="this.style.display='none';document.getElementById('img-placeholder').style.display='flex'">
            <div id="img-placeholder" class="hidden text-7xl text-gray-600" aria-hidden="true">📱</div>
          </c:when>
          <c:otherwise>
            <div class="text-8xl text-gray-600" aria-hidden="true">
              <c:choose>
                <c:when test="${fn:contains(produit.categorie.nom,'Smartphone')}">📱</c:when>
                <c:when test="${fn:contains(produit.categorie.nom,'Ordinateur')}">💻</c:when>
                <c:when test="${fn:contains(produit.categorie.nom,'Audio')}">🎧</c:when>
                <c:when test="${fn:contains(produit.categorie.nom,'Tablette')}">📟</c:when>
                <c:otherwise>🔌</c:otherwise>
              </c:choose>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Badges -->
      <div class="flex gap-3 mt-4 flex-wrap">
        <span class="px-3 py-1 bg-gold/10 text-gold text-xs font-bold rounded-full border border-gold/20">
          ${produit.categorie.nom}
        </span>
        <c:if test="${produit.stock > 0}">
          <span class="px-3 py-1 bg-green-500/10 text-green-500 text-xs font-bold rounded-full border border-green-500/20">
            ✓ En stock
          </span>
        </c:if>
        <c:if test="${produit.stock == 0}">
          <span class="px-3 py-1 bg-rose-500/10 text-rose-500 text-xs font-bold rounded-full border border-rose-500/20">
            Rupture de stock
          </span>
        </c:if>
      </div>
    </div>

    <!-- Infos produit -->
    <div>
      <!-- Marque -->
      <div class="text-xs text-gold font-mono tracking-wider mb-2">
        ${produit.marque}
      </div>

      <!-- Titre -->
      <h1 class="font-display text-3xl md:text-4xl font-bold tracking-tight leading-tight mb-4">
        ${produit.nom}
      </h1>

      <!-- Description -->
      <p class="text-gray-400 leading-relaxed mb-8">
        ${produit.description}
      </p>

      <!-- Prix + stock -->
      <div class="bg-gray-800/50 border border-gray-700 rounded-2xl p-6 mb-6">
        <div class="flex items-baseline gap-3 mb-4">
          <div class="font-display text-3xl md:text-4xl font-extrabold text-gold">
            ${produit.prix} €
          </div>
          <div class="text-xs text-gray-500">TTC</div>
        </div>

        <div class="flex items-center gap-2 mb-6">
          <c:choose>
            <c:when test="${produit.stock == 0}">
              <span class="text-rose-500" aria-live="polite">✗ Rupture de stock</span>
            </c:when>
            <c:when test="${produit.stock <= 5}">
              <span class="text-gold" aria-live="polite">
                ⚠ Plus que <strong>${produit.stock}</strong> exemplaire${produit.stock > 1 ? 's' : ''} disponible${produit.stock > 1 ? 's' : ''}
              </span>
            </c:when>
            <c:otherwise>
              <span class="text-emerald-500" aria-live="polite">
                ✓ En stock — ${produit.stock} disponible${produit.stock > 1 ? 's' : ''}
              </span>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Formulaire ajout panier -->
        <c:choose>
          <c:when test="${not empty sessionScope.client and not sessionScope.client.admin}">
            <c:if test="${produit.stock > 0}">
              <c:if test="${not empty erreur}">
                <div class="mb-4 p-4 bg-rose-900/50 border border-rose-600 rounded-xl flex items-center gap-3 text-rose-200">
                  <span class="text-2xl" aria-hidden="true">⚠️</span>
                  <span>${erreur}</span>
                </div>
              </c:if>
              <form action="${pageContext.request.contextPath}/panier/ajouter" method="post"
                    aria-label="Ajouter au panier">
                <input type="hidden" name="produitId" value="${produit.id}">
                <div class="flex flex-col sm:flex-row gap-4 items-start sm:items-end">
                  <div>
                    <label class="block text-sm font-medium text-gray-300 mb-2" for="quantite">Quantité</label>
                    <input type="number" id="quantite" name="quantite"
                           class="w-24 h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                           value="1" min="1" max="${produit.stock}"
                           aria-label="Quantité à commander"
                           aria-describedby="qty-hint">
                    <div class="text-xs text-gray-500 mt-1" id="qty-hint">Max : ${produit.stock}</div>
                  </div>
                  <div class="flex-1">
                    <button type="submit" 
                            class="w-full h-12 bg-gradient-to-r from-gold to-gold-dark text-gray-900 font-medium rounded-xl hover:shadow-lg hover:shadow-gold/20 transition-all duration-300 flex items-center justify-center gap-2">
                      <span>🛒</span>
                      <span>Ajouter au panier</span>
                    </button>
                  </div>
                </div>
              </form>
            </c:if>
          </c:when>
          <c:when test="${empty sessionScope.client}">
            <div class="p-4 bg-blue-900/20 border border-blue-500/30 rounded-xl flex items-center gap-3 text-blue-300">
              <span class="text-2xl" aria-hidden="true">ℹ️</span>
              <span>
                <a href="${pageContext.request.contextPath}/login"
                   class="text-blue-400 font-semibold hover:text-blue-300 transition-colors">Connectez-vous</a>
                pour ajouter des produits à votre panier
              </span>
            </div>
          </c:when>
        </c:choose>
      </div>

      <!-- Informations supplémentaires -->
      <div class="bg-gray-800/50 border border-gray-700 rounded-xl overflow-hidden mb-4">
        <div class="px-5 py-3 bg-gray-800 border-b border-gray-700 text-xs font-bold tracking-wider uppercase text-gray-400">
          Informations
        </div>
        <div class="p-5">
          <table class="w-full text-sm">
            <tr>
              <td class="py-2 text-gray-500 w-32">Marque</td>
              <td class="text-gray-300 font-medium">${produit.marque}</td>
            </tr>
            <tr>
              <td class="py-2 text-gray-500 border-t border-gray-700">Catégorie</td>
              <td class="text-gray-300 border-t border-gray-700">
                <a href="${pageContext.request.contextPath}/catalogue?categorie=${produit.categorie.id}"
                   class="text-gold hover:text-gold-dark transition-colors">${produit.categorie.nom}</a>
              </td>
            </tr>
            <tr>
              <td class="py-2 text-gray-500 border-t border-gray-700">Référence</td>
              <td class="text-gray-400 border-t border-gray-700 font-mono text-xs">
                #${produit.id}
              </td>
            </tr>
          </table>
        </div>
      </div>

      <!-- Garanties -->
      <div class="grid grid-cols-3 gap-3">
        <div class="text-center p-4 bg-gray-800/50 border border-gray-700 rounded-xl">
          <div class="text-2xl mb-2">🔒</div>
          <div class="text-xs text-gray-500">Paiement sécurisé</div>
        </div>
        <div class="text-center p-4 bg-gray-800/50 border border-gray-700 rounded-xl">
          <div class="text-2xl mb-2">🚀</div>
          <div class="text-xs text-gray-500">Livraison express</div>
        </div>
        <div class="text-center p-4 bg-gray-800/50 border border-gray-700 rounded-xl">
          <div class="text-2xl mb-2">✅</div>
          <div class="text-xs text-gray-500">Garantie 2 ans</div>
        </div>
      </div>
    </div>
  </div>
</main>

<!-- Footer -->
<footer class="mt-20 border-t border-gray-800" role="contentinfo">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <p class="text-center text-gray-500 text-sm">© 2025 TechShop — Tous droits réservés</p>
  </div>
</footer>

</body>
</html>