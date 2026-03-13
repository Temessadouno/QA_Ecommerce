<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="activePage" value="commandes" scope="request"/>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Mes Commandes — TechShop</title>
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
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@700;800&family=DM+Sans:wght@400;500;700&family=DM+Mono&display=swap" rel="stylesheet">
  <style>
    body { background-color: #ffffff; color: #121212; }
    .order-card { border: 4px solid #121212; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    .order-card:hover { transform: translate(-4px, -4px); box-shadow: 12px 12px 0px 0px #C5A028; border-color: #C5A028; }
    
    /* Scrollbar minimaliste pour les produits */
    .products-scroll::-webkit-scrollbar { width: 4px; }
    .products-scroll::-webkit-scrollbar-track { background: #f1f1f1; }
    .products-scroll::-webkit-scrollbar-thumb { background: #121212; }
  </style>
</head>
<body class="min-h-screen font-sans antialiased">
<%@ include file="../common/navbar.jsp" %>

<main class="max-w-5xl mx-auto px-4 py-12">
  
  <div class="mb-12 border-b-4 border-black pb-6">
    <h1 class="text-5xl font-display font-black uppercase tracking-tighter">Historique</h1>
    <p class="text-gray-500 font-bold uppercase text-xs tracking-[0.2em] mt-2 italic">TechShop — Vos acquisitions premium</p>
  </div>

  <c:choose>
    <c:when test="${empty commandes}">
      <div class="text-center py-24 border-4 border-dashed border-gray-300">
        <div class="text-6xl mb-6">📦</div>
        <h2 class="text-2xl font-display font-bold uppercase mb-4">Aucune commande enregistrée</h2>
        <a href="${pageContext.request.contextPath}/catalogue" 
           class="inline-block px-10 py-4 bg-black text-white font-black uppercase text-xs tracking-widest hover:bg-gold transition-colors">
          Explorer le catalogue
        </a>
      </div>
    </c:when>

    <c:otherwise>
      <div class="space-y-10">
        <c:forEach var="commande" items="${commandes}">
          <div class="order-card bg-white p-6 md:p-8 flex flex-col gap-6">
            
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 pb-6 border-b-2 border-black border-dotted">
              <div class="space-y-1">
                <div class="flex items-center gap-4">
                  <span class="font-mono font-bold text-lg bg-black text-white px-2 italic"># ${commande.id}</span>
                  
                  <c:choose>
                    <c:when test="${commande.statutName eq 'EN_COURS'}">
                      <span class="text-[10px] font-black uppercase px-2 py-0.5 border-2 border-gold text-gold">Traitement</span>
                    </c:when>
                    <c:when test="${commande.statutName eq 'VALIDEE'}">
                      <span class="text-[10px] font-black uppercase px-2 py-0.5 border-2 border-black bg-black text-white italic">Confirmée</span>
                    </c:when>
                    <c:when test="${commande.statutName eq 'ANNULEE'}">
                      <span class="text-[10px] font-black uppercase px-2 py-0.5 border-2 border-red-600 text-red-600">Annulée</span>
                    </c:when>
                  </c:choose>
                </div>
                <div class="text-xs font-bold text-gray-400 uppercase tracking-widest">
                  Acquis le <span class="text-black italic">
                    <fmt:formatDate value="${commande.dateCommandeAsDate}" pattern="dd/MM/yyyy à HH:mm"/>
                  </span>
                </div>
              </div>

              <div class="text-right">
                <div class="font-display text-3xl font-black tracking-tighter">
                  <fmt:formatNumber value="${commande.total}" pattern="#,##0.00"/> €
                </div>
                <div class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">
                  Total TTC — ${fn:length(commande.lignes)} article(s)
                </div>
              </div>
            </div>

            <div class="products-scroll max-h-40 overflow-y-auto pr-4">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-3">
                <c:forEach var="ligne" items="${commande.lignes}">
                  <div class="flex justify-between items-center text-sm border-b border-gray-100 py-1 hover:bg-gray-50 transition-colors group">
                    <div class="flex items-center gap-3">
                      <span class="font-mono text-xs font-bold bg-gray-100 px-1 group-hover:bg-gold transition-colors">×${ligne.quantite}</span>
                      <span class="font-bold uppercase tracking-tighter text-gray-700">${ligne.produit.nom}</span>
                    </div>
                    <span class="font-medium text-gray-400">
                      <fmt:formatNumber value="${ligne.sousTotal}" pattern="#,##0.00"/> €
                    </span>
                  </div>
                </c:forEach>
              </div>
            </div>

            <div class="pt-6 border-t-2 border-black flex flex-col md:flex-row justify-between items-center gap-4">
              <div class="text-[10px] font-bold text-gray-500 uppercase tracking-widest flex items-center gap-2">
                <span class="text-black">📍 Expédié à :</span> ${commande.adresseLivraison}
              </div>
              <a href="${pageContext.request.contextPath}/commande/detail?id=${commande.id}" 
                 class="px-6 py-2 bg-black text-white text-[10px] font-black uppercase tracking-widest hover:bg-gold hover:text-black transition-all">
                Voir la facture →
              </a>
            </div>

          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<footer class="mt-20 border-t-4 border-black py-10 bg-white">
  <div class="max-w-7xl mx-auto px-4 text-center">
    <p class="text-[10px] font-black uppercase tracking-[0.4em] text-gray-400 italic">
      © 2026 TechShop — Premium Electronics Supply
    </p>
  </div>
</footer>

</body>
</html>