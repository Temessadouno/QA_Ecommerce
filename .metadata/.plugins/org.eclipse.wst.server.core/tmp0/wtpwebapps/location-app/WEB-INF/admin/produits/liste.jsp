<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestion des Produits — Admin TechShop</title>
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
            'text-muted': '#9ca3af',
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
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&family=DM+Mono:wght@400&display=swap" rel="stylesheet">
</head>
<body class="bg-gradient-to-br from-gray-950 via-gray-900 to-gray-950 text-gray-100 min-h-screen font-sans antialiased">
<%@ include file="../../common/navbar.jsp" %>

<!-- Admin Layout -->
<div class="flex min-h-screen">

  <%-- Sidebar --%>
  <nav class="w-64 shrink-0 bg-gray-900/80 backdrop-blur-xl border-r border-gray-800 p-4 flex flex-col" aria-label="Navigation administration">
    
    <!-- Header -->
    <div class="pb-3 mb-4 border-b border-gray-800">
      <div class="text-xs font-bold tracking-wider uppercase text-gold flex items-center gap-2">
        <span>⚙️</span> Administration
      </div>
    </div>

    <!-- Navigation sections -->
    <div class="space-y-6 flex-1">
      <!-- Dashboard -->
      <div>
        <div class="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2 px-2">Tableau de bord</div>
        <a href="${pageContext.request.contextPath}/admin" 
           class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
          <span class="text-lg">📊</span> Vue d'ensemble
        </a>
      </div>

      <!-- Catalogue -->
      <div>
        <div class="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2 px-2">Catalogue</div>
        <div class="space-y-1">
          <a href="${pageContext.request.contextPath}/admin/produits" 
             class="flex items-center gap-3 px-3 py-2 bg-gold/10 text-gold rounded-xl border border-gold/20">
            <span class="text-lg">📱</span> Produits
          </a>
          <a href="${pageContext.request.contextPath}/admin/categories" 
             class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
            <span class="text-lg">🏷️</span> Catégories
          </a>
        </div>
      </div>

      <!-- Ventes -->
      <div>
        <div class="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2 px-2">Ventes</div>
        <a href="${pageContext.request.contextPath}/admin/commandes" 
           class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
          <span class="text-lg">📦</span> Commandes
        </a>
      </div>
    </div>
  </nav>

  <!-- Contenu principal -->
  <main class="flex-1 p-8 overflow-y-auto">

    <!-- Alertes -->
    <c:if test="${not empty sessionScope.succes}">
      <div class="mb-6 p-4 bg-emerald-900/50 border border-emerald-600 rounded-xl flex items-center gap-3 text-emerald-200 animate-fade-up" role="alert">
        <span class="text-2xl" aria-hidden="true">✅</span>
        <span>${sessionScope.succes}</span>
      </div>
      <c:remove var="succes" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.erreur}">
      <div class="mb-6 p-4 bg-rose-900/50 border border-rose-600 rounded-xl flex items-center gap-3 text-rose-200 animate-fade-up" role="alert">
        <span class="text-2xl" aria-hidden="true">⚠️</span>
        <span>${sessionScope.erreur}</span>
      </div>
      <c:remove var="erreur" scope="session"/>
    </c:if>

    <!-- En-tête avec bouton nouveau -->
    <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-8 animate-fade-up">
      <div>
        <div class="flex items-center gap-2 text-sm text-gray-500 mb-2">
          <a href="${pageContext.request.contextPath}/admin" class="hover:text-gold transition-colors">Admin</a>
          <span class="text-gray-600">›</span>
          <span class="text-gray-400">Produits</span>
        </div>
        <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
          Gestion des <span class="text-gold">produits</span>
        </h1>
        <p class="text-gray-400 mt-1">
          ${fn:length(produits)} produit${fn:length(produits) > 1 ? 's' : ''} actif${fn:length(produits) > 1 ? 's' : ''}
        </p>
      </div>
      <a href="${pageContext.request.contextPath}/admin/produits/nouveau"
         class="flex items-center gap-2 px-5 py-3 bg-gradient-to-r from-gold to-gold-dark text-gray-900 font-medium rounded-xl hover:shadow-lg hover:shadow-gold/20 transition-all duration-300">
        <span class="text-lg">➕</span> Nouveau produit
      </a>
    </div>

    <!-- Filtre rapide par catégorie -->
    <div class="flex flex-wrap gap-2 mb-6 animate-fade-up" style="animation-delay: 0.1s">
      <a href="${pageContext.request.contextPath}/admin/produits"
         class="px-4 py-2 text-sm font-medium rounded-xl transition-all duration-300
                ${empty param.categorie 
                  ? 'bg-gold text-gray-900' 
                  : 'bg-gray-800/50 text-gray-400 hover:text-white hover:bg-gray-700 border border-gray-700'}">
        Tous
      </a>
      <c:forEach var="cat" items="${categories}">
        <a href="${pageContext.request.contextPath}/admin/produits?categorie=${cat.id}"
           class="px-4 py-2 text-sm font-medium rounded-xl transition-all duration-300
                  ${param.categorie == cat.id 
                    ? 'bg-gold text-gray-900' 
                    : 'bg-gray-800/50 text-gray-400 hover:text-white hover:bg-gray-700 border border-gray-700'}">
          ${cat.nom}
        </a>
      </c:forEach>
    </div>

    <!-- Tableau des produits -->
    <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl overflow-hidden animate-fade-up" style="animation-delay: 0.2s">
      <div class="overflow-x-auto">
        <table class="w-full" aria-label="Liste des produits">
          <thead>
            <tr class="border-b border-gray-700 bg-gray-900/50">
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Produit</th>
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Catégorie</th>
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Prix</th>
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Stock</th>
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Statut</th>
              <th scope="col" class="px-6 py-4 text-left text-xs font-medium text-gray-400 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-800">
            <c:forEach var="p" items="${produits}">
              <tr class="hover:bg-gray-800/50 transition-colors">
                <!-- Produit -->
                <td class="px-6 py-4">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-gray-800 rounded-lg flex items-center justify-center text-xl shrink-0">
                      <c:choose>
                        <c:when test="${not empty p.imageUrl}">
                          <img src="${pageContext.request.contextPath}/resources/images/produits/${p.imageUrl}"
                               alt="" class="w-9 h-9 object-contain"
                               onerror="this.style.display='none'">
                        </c:when>
                        <c:otherwise>
                          <span class="text-gray-500">📦</span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div>
                      <div class="font-medium text-white">${p.nom}</div>
                      <div class="text-xs text-gray-500">${p.marque}</div>
                    </div>
                  </div>
                </td>
                
                <!-- Catégorie -->
                <td class="px-6 py-4">
                  <span class="px-2 py-1 bg-gold/10 text-gold text-xs font-bold rounded-full border border-gold/20">
                    ${p.categorie.nom}
                  </span>
                </td>
                
                <!-- Prix -->
                <td class="px-6 py-4">
                  <span class="font-mono text-gold font-semibold">
                    <fmt:formatNumber value="${p.prix}" pattern="#,##0.00"/> €
                  </span>
                </td>
                
                <!-- Stock -->
                <td class="px-6 py-4">
                  <div class="flex items-center gap-2">
                    <c:choose>
                      <c:when test="${p.stock == 0}">
                        <span class="px-2 py-1 bg-rose-500/10 text-rose-500 text-xs font-bold rounded-full border border-rose-500/20">Rupture</span>
                      </c:when>
                      <c:when test="${p.stock <= 5}">
                        <span class="text-gold font-semibold">${p.stock}</span>
                        <span class="px-2 py-1 bg-gold/10 text-gold text-xs font-bold rounded-full border border-gold/20">Faible</span>
                      </c:when>
                      <c:otherwise>
                        <span class="text-gray-300 font-semibold">${p.stock}</span>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </td>
                
                <!-- Statut -->
                <td class="px-6 py-4">
                  <c:choose>
                    <c:when test="${p.stock > 0}">
                      <span class="px-2 py-1 bg-emerald-500/10 text-emerald-500 text-xs font-bold rounded-full border border-emerald-500/20">Actif</span>
                    </c:when>
                    <c:otherwise>
                      <span class="px-2 py-1 bg-rose-500/10 text-rose-500 text-xs font-bold rounded-full border border-rose-500/20">Indisponible</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                
                <!-- Actions -->
                <td class="px-6 py-4">
                  <div class="flex items-center gap-2">
                    <a href="${pageContext.request.contextPath}/admin/produits/modifier?id=${p.id}"
                       class="w-8 h-8 flex items-center justify-center bg-gray-700/50 hover:bg-gray-700 text-gray-300 hover:text-white rounded-lg transition-colors"
                       aria-label="Modifier ${p.nom}">
                      <span class="text-sm">✏️</span>
                    </a>
                    <form action="${pageContext.request.contextPath}/admin/produits/supprimer"
                          method="post" 
                          onsubmit="return confirm('Supprimer « ${p.nom} » ? Cette action est irréversible.')">
                      <input type="hidden" name="id" value="${p.id}">
                      <button type="submit" 
                              class="w-8 h-8 flex items-center justify-center bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 hover:text-rose-300 rounded-lg transition-colors"
                              aria-label="Supprimer ${p.nom}">
                        <span class="text-sm">🗑️</span>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
            
            <!-- État vide -->
            <c:if test="${empty produits}">
              <tr>
                <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                  Aucun produit trouvé
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </div>
  </main>
</div>

<!-- Footer -->
<footer class="border-t border-gray-800" role="contentinfo">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <p class="text-center text-gray-500 text-sm">© 2025 TechShop — Administration</p>
  </div>
</footer>

</body>
</html>