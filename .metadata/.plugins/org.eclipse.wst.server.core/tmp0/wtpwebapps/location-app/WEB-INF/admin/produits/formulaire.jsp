<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <c:set var="isEdit" value="${not empty produit}"/>
  <title>${isEdit ? 'Modifier' : 'Nouveau'} produit — Admin TechShop</title>
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
            'green-ok': '#4cdb8f',
            'text-muted': '#9ca3af',
            'text-secondary': '#d1d5db',
            'border': '#374151',
            'bg-elevated': '#1f2937',
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

  <!-- Sidebar -->
  <nav class="w-64 shrink-0 bg-gray-900/80 backdrop-blur-xl border-r border-gray-800 p-4 flex flex-col" aria-label="Navigation administration">
    <div class="pb-3 mb-4 border-b border-gray-800">
      <div class="text-xs font-bold tracking-wider uppercase text-gold flex items-center gap-2">
        <span>⚙️</span> Administration
      </div>
    </div>
    <div class="space-y-1">
      <a href="${pageContext.request.contextPath}/admin" 
         class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
        <span class="text-lg">📊</span> Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/admin/produits" 
         class="flex items-center gap-3 px-3 py-2 bg-gold/10 text-gold rounded-xl border border-gold/20">
        <span class="text-lg">📱</span> Produits
      </a>
      <a href="${pageContext.request.contextPath}/admin/categories" 
         class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
        <span class="text-lg">🏷️</span> Catégories
      </a>
      <a href="${pageContext.request.contextPath}/admin/commandes" 
         class="flex items-center gap-3 px-3 py-2 text-gray-400 hover:text-white hover:bg-gray-800/50 rounded-xl transition-all duration-200">
        <span class="text-lg">📦</span> Commandes
      </a>
    </div>
  </nav>

  <!-- Contenu principal -->
  <main class="flex-1 p-8 overflow-y-auto">

    <!-- En-tête -->
    <div class="mb-8 animate-fade-up">
      <div class="flex items-center gap-2 text-sm text-gray-500 mb-2">
        <a href="${pageContext.request.contextPath}/admin" class="hover:text-gold transition-colors">Admin</a>
        <span class="text-gray-600">›</span>
        <a href="${pageContext.request.contextPath}/admin/produits" class="hover:text-gold transition-colors">Produits</a>
        <span class="text-gray-600">›</span>
        <span class="text-gray-400">${isEdit ? produit.nom : 'Nouveau produit'}</span>
      </div>
      <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
        ${isEdit ? '✏️ Modifier le produit' : '➕ Nouveau produit'}
      </h1>
    </div>

    <!-- Alertes -->
    <c:if test="${not empty erreur}">
      <div class="mb-6 p-4 bg-rose-900/50 border border-rose-600 rounded-xl flex items-center gap-3 text-rose-200 animate-fade-up" role="alert">
        <span class="text-2xl" aria-hidden="true">⚠️</span>
        <span>${erreur}</span>
      </div>
    </c:if>

    <!-- Layout formulaire + sidebar -->
    <div class="grid grid-cols-1 lg:grid-cols-[1fr,320px] gap-8 items-start animate-fade-up" style="animation-delay: 0.1s">

      <!-- Formulaire principal -->
      <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl p-6">
        <form action="${pageContext.request.contextPath}/admin/produits/${isEdit ? 'modifier' : 'nouveau'}"
              method="post"
              novalidate
              id="produitForm"
              aria-label="${isEdit ? 'Modifier le produit' : 'Créer un nouveau produit'}"
              class="space-y-5">

          <c:if test="${isEdit}">
            <input type="hidden" name="id" value="${produit.id}">
          </c:if>

          <!-- Nom et Marque -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="nom">
                Nom du produit <span class="text-gold">*</span>
              </label>
              <input type="text" id="nom" name="nom"
                     class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                     placeholder="iPhone 15 Pro"
                     value="<c:out value='${produit.nom}'/>"
                     required minlength="2" maxlength="200"
                     aria-required="true">
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="marque">
                Marque <span class="text-gold">*</span>
              </label>
              <input type="text" id="marque" name="marque"
                     class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                     placeholder="Apple, Samsung..."
                     value="<c:out value='${produit.marque}'/>"
                     required>
            </div>
          </div>

          <!-- Description -->
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2" for="description">Description</label>
            <textarea id="description" name="description"
                      class="w-full px-4 py-3 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                      placeholder="Description détaillée du produit..."
                      rows="4"><c:out value='${produit.description}'/></textarea>
          </div>

          <!-- Prix et Stock -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="prix">
                Prix (€) <span class="text-gold">*</span>
              </label>
              <div class="relative">
                <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gold font-bold">€</span>
                <input type="number" id="prix" name="prix"
                       class="w-full h-12 pl-8 pr-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                       placeholder="0.00"
                       value="<c:out value='${produit.prix}'/>"
                       required min="0" step="0.01"
                       aria-describedby="prix-hint">
              </div>
              <div class="text-xs text-gray-500 mt-1" id="prix-hint">Entrez le prix TTC en euros</div>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="stock">
                Stock initial <span class="text-gold">*</span>
              </label>
              <input type="number" id="stock" name="stock"
                     class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                     placeholder="0"
                     value="<c:out value='${produit.stock}'/>"
                     required min="0"
                     aria-describedby="stock-hint">
              <div class="text-xs text-gray-500 mt-1" id="stock-hint">Nombre d'unités disponibles</div>
            </div>
          </div>

          <!-- Catégorie et Image -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="categorieId">
                Catégorie <span class="text-gold">*</span>
              </label>
              <select id="categorieId" name="categorieId" 
                      class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300" 
                      required>
                <option value="" class="bg-gray-800">-- Sélectionner une catégorie --</option>
                <c:forEach var="cat" items="${categories}">
                  <option value="${cat.id}" class="bg-gray-800"
                          ${produit.categorie.id == cat.id ? 'selected' : ''}>
                    ${cat.nom}
                  </option>
                </c:forEach>
              </select>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-300 mb-2" for="imageUrl">Nom du fichier image</label>
              <input type="text" id="imageUrl" name="imageUrl"
                     class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                     placeholder="iphone15pro.jpg"
                     value="<c:out value='${produit.imageUrl}'/>"
                     aria-describedby="img-hint">
              <div class="text-xs text-gray-500 mt-1" id="img-hint">
                Fichier stocké dans <code class="text-gold text-xs">resources/images/produits/</code>
              </div>
            </div>
          </div>

          <!-- Boutons d'action -->
          <div class="flex gap-3 pt-4 border-t border-gray-700 mt-4">
            <button type="submit" 
                    class="px-6 h-12 bg-gradient-to-r from-gold to-gold-dark text-gray-900 font-medium rounded-xl hover:shadow-lg hover:shadow-gold/20 transition-all duration-300 flex items-center gap-2">
              <span>${isEdit ? '💾' : '➕'}</span>
              <span>${isEdit ? 'Enregistrer les modifications' : 'Créer le produit'}</span>
            </button>
            <a href="${pageContext.request.contextPath}/admin/produits" 
               class="px-6 h-12 bg-gray-800/50 hover:bg-gray-700 text-gray-300 hover:text-white rounded-xl flex items-center gap-2 transition-all duration-300 border border-gray-700">
              Annuler
            </a>
          </div>
        </form>
      </div>

      <!-- Panneau latéral : aperçu + contraintes qualité -->
      <div class="space-y-4">
        <!-- Aperçu image -->
        <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl p-5">
          <div class="text-xs font-bold tracking-wider uppercase text-gray-500 mb-3">Aperçu image</div>
          <div class="w-full h-40 bg-gray-900/50 rounded-xl flex items-center justify-center overflow-hidden"
               id="previewWrapper">
            <c:choose>
              <c:when test="${not empty produit.imageUrl}">
                <img id="previewImg"
                     src="${pageContext.request.contextPath}/resources/images/produits/${produit.imageUrl}"
                     alt="Aperçu"
                     class="max-w-full max-h-36 object-contain p-3">
              </c:when>
              <c:otherwise>
                <span class="text-5xl text-gray-600" id="previewPlaceholder" aria-hidden="true">📦</span>
                <img id="previewImg" src="" alt="" class="hidden max-w-full max-h-36 object-contain p-3">
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Contraintes qualité -->
        <div class="bg-gray-800/30 backdrop-blur-sm border border-gray-700 rounded-2xl p-5">
          <div class="text-xs font-bold tracking-wider uppercase text-gray-500 mb-3 flex items-center gap-1">
            <span>✅</span> Contraintes qualité
          </div>
          <div class="space-y-2">
            <div class="flex items-center gap-2 text-sm text-gray-400">
              <span class="text-emerald-500">✓</span> Prix ≥ 0 (validation serveur)
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-400">
              <span class="text-emerald-500">✓</span> Stock ≥ 0 (règle RM-02)
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-400">
              <span class="text-emerald-500">✓</span> Suppression logique (RM-04)
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-400">
              <span class="text-emerald-500">✓</span> Images dans resources/
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-400">
              <span class="text-emerald-500">✓</span> PreparedStatement (ENF-SEC-04)
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Script pour aperçu image -->
<script>
  // Aperçu image en temps réel
  document.getElementById('imageUrl').addEventListener('input', function() {
    const url = this.value.trim();
    const img = document.getElementById('previewImg');
    const placeholder = document.getElementById('previewPlaceholder');
    if (url) {
      img.src = '${pageContext.request.contextPath}/resources/images/produits/' + url;
      img.classList.remove('hidden');
      if (placeholder) placeholder.classList.add('hidden');
      img.onerror = () => {
        img.classList.add('hidden');
        if (placeholder) placeholder.classList.remove('hidden');
      };
    } else {
      img.classList.add('hidden');
      if (placeholder) placeholder.classList.remove('hidden');
    }
  });

  // Validation formulaire
  document.getElementById('produitForm').addEventListener('submit', function(e) {
    const prix = parseFloat(document.getElementById('prix').value);
    const stock = parseInt(document.getElementById('stock').value);
    if (prix < 0) { e.preventDefault(); alert('Le prix ne peut pas être négatif'); return; }
    if (stock < 0) { e.preventDefault(); alert('Le stock ne peut pas être négatif'); return; }
  });
</script>

<!-- Footer -->
<footer class="border-t border-gray-800" role="contentinfo">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
    <p class="text-center text-gray-500 text-sm">© 2025 TechShop — Administration</p>
  </div>
</footer>

</body>
</html>