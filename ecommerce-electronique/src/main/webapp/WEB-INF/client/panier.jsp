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
            gold: '#C5A028',
            'gold-dark': '#9A7D1D',
            'tech-black': '#121212',
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
    body { background-color: #ffffff; color: #121212; }
    .item-card { border-bottom: 1px solid #e5e7eb; transition: all 0.2s ease; }
    .item-card:hover { background-color: #fafafa; }
    
    /* Personnalisation de la barre de défilement pour rester dans le style noir/blanc */
    .scroll-custom::-webkit-scrollbar { width: 6px; }
    .scroll-custom::-webkit-scrollbar-track { background: #f1f1f1; }
    .scroll-custom::-webkit-scrollbar-thumb { background: #121212; }
    .scroll-custom::-webkit-scrollbar-thumb:hover { background: #C5A028; }
  </style>
</head>
<body class="min-h-screen font-sans antialiased">
<%@ include file="../common/navbar.jsp" %>

<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

  <div class="mb-10">
    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-gray-400 mb-4">
      <a href="${pageContext.request.contextPath}/catalogue" class="hover:text-black">Catalogue</a>
      <span>/</span>
      <span class="text-black font-bold">Panier</span>
    </nav>
    <h1 class="text-4xl font-display font-extrabold text-tech-black border-b-4 border-tech-black inline-block pb-2 uppercase">
      Mon Panier
    </h1>
  </div>

  <c:if test="${not empty erreur}">
    <div class="mb-6 p-4 bg-black text-white rounded-lg flex items-center gap-3">
      <span class="font-bold uppercase text-xs tracking-widest">Erreur :</span>
      <span class="text-sm">${erreur}</span>
    </div>
  </c:if>

  <c:choose>
    <c:when test="${empty panierItems}">
      <div class="text-center py-32 border-2 border-black">
        <h2 class="text-3xl font-display font-bold mb-6 text-tech-black uppercase tracking-tighter">Votre panier est vide</h2>
        <a href="${pageContext.request.contextPath}/catalogue" 
           class="inline-block px-10 py-4 bg-tech-black text-white font-bold hover:bg-gold transition-colors uppercase text-sm tracking-widest">
          Retour au catalogue
        </a>
      </div>
    </c:when>

    <c:otherwise>
      <div class="flex flex-col lg:flex-row gap-16 items-start">

        <%-- Liste des articles SCROLLABLE --%>
        <div class="flex-1 w-full">
          <%-- On fixe la hauteur max ici --%>
          <div class="border-t-2 border-black max-h-[400px] overflow-y-auto scroll-custom pr-6">
            <c:forEach var="item" items="${panierItems}">
              <div class="item-card py-8 flex flex-col md:flex-row gap-8">
                
                <div class="w-full md:w-40 h-40 bg-gray-100 flex items-center justify-center grayscale hover:grayscale-0 transition-all border border-gray-100">
                  <c:choose>
                    <c:when test="${not empty item.produit.imageUrl}">
                      <img src="${pageContext.request.contextPath}/images/logo.png"
                           alt="${item.produit.nom}" class="max-h-full max-w-full object-contain">
                    </c:when>
                    <c:otherwise><span class="text-xs font-bold font-display">NO IMAGE</span></c:otherwise>
                  </c:choose>
                </div>

                <div class="flex-1 flex flex-col justify-between">
                  <div>
                    <h3 class="text-2xl font-display font-bold leading-tight mb-1 uppercase tracking-tighter">
                      ${item.produit.nom}
                    </h3>
                    <p class="text-gray-400 text-xs mb-4 font-bold uppercase tracking-widest">${item.produit.marque}</p>
                    
                    <div class="text-xl font-bold">
                      <fmt:formatNumber value="${item.produit.prix}" pattern="#,##0.00"/> €
                      <span class="text-gray-400 text-sm font-normal ml-2 italic">x ${item.quantite}</span>
                    </div>
                  </div>

                  <div class="mt-6 flex items-center gap-6">
                    <form action="${pageContext.request.contextPath}/panier/modifier" method="post" class="flex border-2 border-black">
                      <input type="hidden" name="itemId" value="${item.id}">
                      <button type="button" class="px-3 py-1 font-bold hover:bg-black hover:text-white transition-colors" onclick="changeQty(${item.id}, -1)">-</button>
                      <span class="px-4 py-1 border-x-2 border-black font-bold text-sm" id="qty-${item.id}">${item.quantite}</span>
                      <button type="button" class="px-3 py-1 font-bold hover:bg-black hover:text-white transition-colors" onclick="changeQty(${item.id}, 1, ${item.produit.stock})">+</button>
                      <input type="hidden" name="quantite" id="qty-input-${item.id}" value="${item.quantite}">
                      <button type="submit" class="bg-black text-white px-4 py-1 text-[10px] font-bold uppercase hover:bg-gold transition-colors border-l-0">Maj</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/panier/supprimer" method="post">
                      <input type="hidden" name="itemId" value="${item.id}">
                      <button type="submit" class="text-[10px] font-bold uppercase border-b-2 border-black hover:text-red-600 hover:border-red-600 transition-colors"
                              onclick="return confirm('Retirer cet article ?')">
                        Supprimer
                      </button>
                    </form>
                  </div>
                </div>

                <div class="text-right">
                  <span class="text-2xl font-display font-black tracking-tighter">
                    <fmt:formatNumber value="${item.sousTotal}" pattern="#,##0.00"/> €
                  </span>
                </div>
              </div>
            </c:forEach>
          </div>
          
          <div class="mt-6">
             <a href="${pageContext.request.contextPath}/catalogue" class="text-xs font-bold uppercase border-b-2 border-black hover:text-gold hover:border-gold transition-colors">
               ← Continuer le shopping
             </a>
          </div>
        </div>

        <%-- Résumé FIXE (grâce à sticky top) --%>
        <aside class="lg:w-80 w-full shrink-0">
          <div class="border-4 border-black p-6 sticky top-8 bg-white">
            <h2 class="text-xl font-display font-black mb-6 uppercase italic tracking-tighter">Récapitulatif</h2>
            
            <div class="space-y-4 text-xs font-bold uppercase border-b-2 border-black pb-6 mb-6">
              <div class="flex justify-between">
                <span class="text-gray-500">Total Articles</span>
                <span><fmt:formatNumber value="${total}" pattern="#,##0.00"/> €</span>
              </div>
              <div class="flex justify-between">
                <span class="text-gray-500">Expédition</span>
                <span class="text-green-600">Gratuit</span>
              </div>
            </div>

            <div class="flex justify-between items-baseline mb-8">
              <span class="text-lg font-black uppercase tracking-tighter">Total TTC</span>
              <span class="text-3xl font-display font-black tracking-tighter">
                <fmt:formatNumber value="${total}" pattern="#,##0.00"/> €
              </span>
            </div>

            <a href="${pageContext.request.contextPath}/commande/validerPanier"
               class="block w-full text-center bg-black text-white py-4 font-black uppercase text-sm tracking-widest hover:bg-gold transition-all transform hover:-translate-y-1 shadow-xl">
              Paiement
            </a>
            
            <div class="mt-6 text-center">
              <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest leading-relaxed">
                Paiement sécurisé par cryptage SSL.<br>Retours gratuits sous 30 jours.
              </p>
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