<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Administration — TechShop</title>
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
<%@ include file="../common/navbar.jsp" %>

<!-- Admin Layout -->
<div class="flex min-h-screen">

  <%-- ── Sidebar admin ── --%>
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
           class="flex items-center gap-3 px-3 py-2 bg-gold/10 text-gold rounded-xl border border-gold/20">
          <span class="text-lg">📊</span> Vue d'ensemble
        </a>
      </div>

      <!-- Catalogue -->
      <div>
        <div class="text-xs font-medium text-gray-500 uppercase tracking-wider mb-2 px-2">Catalogue</div>
        <div class="space-y-1">
          <a href="${pageContext.request.contextPath}/admin/produits" 
             class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
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

    <!-- Footer navigation -->
    <div class="mt-auto pt-4 border-t border-gray-800 space-y-1">
      <a href="${pageContext.request.contextPath}/catalogue" 
         class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
        <span class="text-lg">🏪</span> Voir la boutique
      </a>
      <a href="${pageContext.request.contextPath}/logout" 
         class="flex items-center gap-3 px-3 py-2 text-rose-400 hover:text-rose-300 hover:bg-rose-500/10 rounded-xl transition-all duration-200">
        <span class="text-lg">🚪</span> Déconnexion
      </a>
    </div>
  </nav>

  <%-- ── Contenu principal ── --%>
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

    <!-- En-tête -->
    <div class="mb-8 animate-fade-up">
      <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight mb-2">
        Bonjour, <span class="text-gold">${sessionScope.client.prenom}</span> 👋
      </h1>
      <p class="text-gray-400">Vue d'ensemble de votre boutique TechShop</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8 animate-fade-up" style="animation-delay: 0.1s">
      <!-- Produits -->
      <div class="bg-gradient-to-br from-amber-500/10 to-amber-600/5 border border-amber-500/20 rounded-2xl p-5">
        <div class="flex items-center gap-3 mb-2">
          <div class="w-10 h-10 rounded-xl bg-amber-500/20 flex items-center justify-center text-amber-500 text-xl">📱</div>
          <div class="text-2xl font-display font-bold text-amber-500">${nbProduits}</div>
        </div>
        <div class="text-sm text-gray-400">Produits actifs</div>
      </div>

      <!-- Catégories -->
      <div class="bg-gradient-to-br from-blue-500/10 to-blue-600/5 border border-blue-500/20 rounded-2xl p-5">
        <div class="flex items-center gap-3 mb-2">
          <div class="w-10 h-10 rounded-xl bg-blue-500/20 flex items-center justify-center text-blue-500 text-xl">🏷️</div>
          <div class="text-2xl font-display font-bold text-blue-500">${nbCategories}</div>
        </div>
        <div class="text-sm text-gray-400">Catégories</div>
      </div>

      <!-- Commandes -->
      <div class="bg-gradient-to-br from-emerald-500/10 to-emerald-600/5 border border-emerald-500/20 rounded-2xl p-5">
        <div class="flex items-center gap-3 mb-2">
          <div class="w-10 h-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-500 text-xl">📦</div>
          <div class="text-2xl font-display font-bold text-emerald-500">${nbCommandes}</div>
        </div>
        <div class="text-sm text-gray-400">Commandes total</div>
      </div>

      <!-- Architecture -->
      <div class="bg-gradient-to-br from-rose-500/10 to-rose-600/5 border border-rose-500/20 rounded-2xl p-5">
        <div class="flex items-center gap-3 mb-2">
          <div class="w-10 h-10 rounded-xl bg-rose-500/20 flex items-center justify-center text-rose-500 text-xl">⚡</div>
          <div class="text-2xl font-display font-bold text-rose-500">JEE</div>
        </div>
        <div class="text-sm text-gray-400">Architecture MVC</div>
      </div>
    </div>

    <!-- Actions rapides -->
    <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl p-6 mb-8 animate-fade-up" style="animation-delay: 0.2s">
      <h2 class="font-display text-sm font-bold uppercase tracking-wider text-gray-500 mb-4">
        Actions rapides
      </h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
        <a href="${pageContext.request.contextPath}/admin/produits/nouveau"
           class="flex items-center gap-3 px-4 py-3 bg-gold/10 hover:bg-gold/20 text-gold rounded-xl transition-all duration-300 border border-gold/20">
          <span class="text-lg">➕</span> Nouveau produit
        </a>
        <a href="${pageContext.request.contextPath}/admin/produits"
           class="flex items-center gap-3 px-4 py-3 bg-gray-700/50 hover:bg-gray-700 text-gray-300 hover:text-white rounded-xl transition-all duration-300">
          <span class="text-lg">📋</span> Gérer les produits
        </a>
        <a href="${pageContext.request.contextPath}/admin/commandes"
           class="flex items-center gap-3 px-4 py-3 bg-gray-800/50 hover:bg-gray-700 text-gray-400 hover:text-white rounded-xl transition-all duration-300 border border-gray-700">
          <span class="text-lg">📦</span> Voir les commandes
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories"
           class="flex items-center gap-3 px-4 py-3 bg-gray-800/50 hover:bg-gray-700 text-gray-400 hover:text-white rounded-xl transition-all duration-300 border border-gray-700">
          <span class="text-lg">🏷️</span> Gérer les catégories
        </a>
      </div>
    </div>

    <!-- Qualité logicielle : indicateurs PAQ -->
    <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl p-6 animate-fade-up" style="animation-delay: 0.3s">
      <h2 class="font-display text-sm font-bold uppercase tracking-wider text-gray-500 mb-4 flex items-center gap-2">
        <span>📋</span> Indicateurs Qualité Logicielle (PAQ)
      </h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <!-- Couverture -->
        <div class="bg-gray-900/50 border border-emerald-500/20 rounded-xl p-4">
          <div class="text-2xl font-display font-bold text-emerald-500 mb-1">≥75%</div>
          <div class="text-xs text-gray-500">Couverture JaCoCo (KQI-01)</div>
        </div>
        <!-- Architecture -->
        <div class="bg-gray-900/50 border border-gold/20 rounded-xl p-4">
          <div class="text-2xl font-display font-bold text-gold mb-1">MVC</div>
          <div class="text-xs text-gray-500">Architecture respectée (KQI-07)</div>
        </div>
        <!-- Sécurité -->
        <div class="bg-gray-900/50 border border-blue-500/20 rounded-xl p-4">
          <div class="text-2xl font-display font-bold text-blue-500 mb-1">OWASP</div>
          <div class="text-xs text-gray-500">Sécurité conforme</div>
        </div>
        <!-- Hash -->
        <div class="bg-gray-900/50 border border-emerald-500/20 rounded-xl p-4">
          <div class="text-2xl font-display font-bold text-emerald-500 mb-1">SHA-256</div>
          <div class="text-xs text-gray-500">Mots de passe hashés</div>
        </div>
      </div>
    </div>

  </main>
</div>

<!-- Footer -->
<footer class="border-t border-gray-800" role="contentinfo">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <p class="text-center text-gray-500 text-sm">© 2025 TechShop — Panneau d'administration</p>
  </div>
</footer>

</body>
</html>