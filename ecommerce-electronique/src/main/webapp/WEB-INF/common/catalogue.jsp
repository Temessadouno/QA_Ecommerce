<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="activePage" value="catalogue" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogue — TechShop</title>
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
        .filter-transition { transition: max-height 0.3s ease-in-out, opacity 0.2s ease-in-out; }
        .hidden-filters { max-height: 0; opacity: 0; overflow: hidden; }
        .show-filters { max-height: 1000px; opacity: 1; }
    </style>
</head>
<body class="bg-[#0B0F1A] text-gray-100 min-h-screen font-sans antialiased">

<%@ include file="navbar.jsp" %>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <div class="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-10">
        <div>
            <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
                Catalogue <span class="text-gold">Tech</span>
            </h1>
            <p class="text-gray-400 text-sm mt-1">Découvrez nos composants et périphériques premium.</p>
        </div>

        <div class="w-full md:w-80">
            <form action="${pageContext.request.contextPath}/catalogue" method="get" class="relative">
                <input type="search" name="q" value="<c:out value='${keyword}'/>"
                       placeholder="Rechercher..."
                       class="w-full h-10 pl-10 pr-4 bg-gray-900 border border-gray-800 rounded-full text-sm focus:outline-none focus:border-gold transition-all">
                <svg class="w-4 h-4 absolute left-3 top-3 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
            </form>
        </div>
    </div>

    <div class="mb-6 flex items-center gap-4">
        <button onclick="toggleFilters()" class="flex items-center gap-2 px-4 py-2 bg-gray-900 border border-gray-800 rounded-lg hover:bg-gray-800 transition-colors text-sm font-medium">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/></svg>
            Filtres
        </button>
        
        <c:if test="${not empty categorieId or not empty keyword}">
            <a href="${pageContext.request.contextPath}/catalogue" class="text-xs text-gray-500 hover:text-gold underline decoration-gold/30">Réinitialiser</a>
        </c:if>
    </div>

    <div id="filterSection" class="filter-transition hidden-filters mb-8">
        <div class="bg-gray-900/50 border border-gray-800 rounded-2xl p-6">
            <form action="${pageContext.request.contextPath}/catalogue" method="get" id="filterForm" class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <c:if test="${not empty keyword}"><input type="hidden" name="q" value="${keyword}"></c:if>
                
                <div>
                    <label class="block text-xs font-bold uppercase tracking-widest text-gold mb-3">Catégories</label>
                    <select name="categorie" onchange="this.form.submit()" class="w-full bg-gray-800 border-none rounded-lg text-sm p-2.5 focus:ring-1 focus:ring-gold">
                        <option value="">Toutes les catégories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}" ${categorieId == cat.id ? 'selected' : ''}>${cat.nom}</option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-bold uppercase tracking-widest text-gold mb-3">Disponibilité</label>
                    <label class="flex items-center cursor-pointer group">
                        <input type="checkbox" name="enStock" value="true" onchange="this.form.submit()" class="hidden peer">
                        <div class="w-5 h-5 border border-gray-700 rounded mr-3 flex items-center justify-center peer-checked:bg-gold peer-checked:border-gold transition-all">
                            <svg class="w-3 h-3 text-dark-bg" fill="currentColor" viewBox="0 0 20 20"><path d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"/></svg>
                        </div>
                        <span class="text-sm text-gray-400 group-hover:text-gray-200">Articles en stock uniquement</span>
                    </label>
                </div>
            </form>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty produits}">
            <div class="text-center py-20 bg-gray-900/20 rounded-3xl border border-dashed border-gray-800">
                <p class="text-gray-500">Aucun produit ne correspond à votre recherche.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                <c:forEach var="produit" items="${produits}">
                    <article class="group bg-gray-900/40 border border-gray-800 rounded-2xl overflow-hidden hover:border-gold/30 transition-all duration-300">
                        <div class="relative aspect-[4/3] bg-gray-800 overflow-hidden">
                            <c:if test="${produit.stock == 0}">
                                <div class="absolute inset-0 bg-gray-950/60 backdrop-blur-[2px] z-10 flex items-center justify-center">
                                    <span class="text-[10px] font-bold uppercase tracking-widest bg-white text-black px-2 py-1">Épuisé</span>
                                </div>
                            </c:if>
                            <img src="${pageContext.request.contextPath}/images/hp.jpg" alt="${produit.nom}" 
                                 class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 opacity-80 group-hover:opacity-100">
                        </div>

                        <div class="p-4">
                            <div class="flex justify-between items-start mb-2">
                                <span class="text-[10px] font-bold text-gold uppercase tracking-tighter">${produit.marque}</span>
                                <span class="text-sm font-bold text-white">${produit.prix}€</span>
                            </div>
                            <h3 class="font-medium text-gray-100 mb-1 line-clamp-1 group-hover:text-gold transition-colors">
                                <a href="${pageContext.request.contextPath}/produit/detail?id=${produit.id}">${produit.nom}</a>
                            </h3>
                            <p class="text-xs text-gray-500 line-clamp-2 mb-4">${produit.description}</p>

                            <div class="flex items-center justify-between mt-auto">
                                <span class="text-[10px] ${produit.stock > 0 ? 'text-emerald-500' : 'text-rose-500'} font-medium">
                                    ${produit.stock > 0 ? 'Disponible' : 'Indisponible'}
                                </span>
                                
                                <c:if test="${not empty sessionScope.client and !sessionScope.client.admin and produit.stock > 0}">
                                    <form action="${pageContext.request.contextPath}/panier/ajouter" method="post">
                                        <input type="hidden" name="produitId" value="${produit.id}">
                                        <input type="hidden" name="quantite" value="1">
                                        <button type="submit" class="p-2 bg-white text-black rounded-lg hover:bg-gold transition-colors">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<script>
    function toggleFilters() {
        const section = document.getElementById('filterSection');
        section.classList.toggle('hidden-filters');
        section.classList.toggle('show-filters');
    }
</script>

</body>
</html>