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
  <style>
    .order-card { transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    .order-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 0 0 1px rgba(212,175,55,0.4), 0 8px 32px rgba(0,0,0,0.4);
      border-color: rgba(212,175,55,0.4) !important;
    }
    .products-scroll::-webkit-scrollbar { width: 4px; }
    .products-scroll::-webkit-scrollbar-track { background: rgba(255,255,255,0.04); border-radius: 4px; }
    .products-scroll::-webkit-scrollbar-thumb { background: #D4AF37; border-radius: 4px; }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(12px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .order-card { animation: fadeUp 0.3s ease both; }

    /* Styles des onglets actifs */
    .tab-btn { transition: all 0.2s ease; }
    .tab-btn.active-all      { background: rgba(255,255,255,0.08); color: #fff;     border-color: rgba(255,255,255,0.2); }
    .tab-btn.active-en_cours { background: rgba(212,175,55,0.15);  color: #D4AF37;  border-color: rgba(212,175,55,0.4); }
    .tab-btn.active-validee  { background: rgba(52,211,153,0.1);   color: #34d399;  border-color: rgba(52,211,153,0.4); }
    .tab-btn.active-annulee  { background: rgba(251,113,133,0.1);  color: #fb7185;  border-color: rgba(251,113,133,0.4); }
  </style>
</head>
<body class="bg-[#0B0F1A] text-gray-100 min-h-screen font-sans antialiased">

<%@ include file="../common/navbar.jsp" %>

<main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">

  <%-- Titre --%>
  <div class="mb-10">
    <h1 class="text-3xl md:text-4xl font-display font-bold tracking-tight">
      Historique <span class="text-gold">des commandes</span>
    </h1>
    <p class="text-gray-400 text-sm mt-1">TechShop — Vos acquisitions premium</p>
  </div>

  <c:choose>
    <c:when test="${empty commandes}">
      <div class="text-center py-24 bg-gray-900/20 rounded-3xl border border-dashed border-gray-800">
        <svg class="w-16 h-16 mx-auto mb-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
        </svg>
        <h2 class="text-2xl font-display font-bold text-gray-300 mb-3">Aucune commande enregistrée</h2>
        <p class="text-gray-500 text-sm mb-8">Parcourez notre catalogue et passez votre première commande.</p>
        <a href="${pageContext.request.contextPath}/catalogue"
           class="inline-block px-8 py-3 bg-gold text-dark-bg font-bold rounded-xl hover:bg-gold-dark transition-colors text-sm uppercase tracking-widest">
          Explorer le catalogue
        </a>
      </div>
    </c:when>

    <c:otherwise>

      <%-- Comptage par statut côté JSTL --%>
      <c:set var="countAll"     value="0"/>
      <c:set var="countCours"   value="0"/>
      <c:set var="countValidee" value="0"/>
      <c:set var="countAnnulee" value="0"/>
      <c:forEach var="cmd" items="${commandes}">
        <c:set var="countAll" value="${countAll + 1}"/>
        <c:choose>
          <c:when test="${cmd.statutName eq 'EN_COURS'}"><c:set var="countCours"   value="${countCours + 1}"/></c:when>
          <c:when test="${cmd.statutName eq 'VALIDEE'}"> <c:set var="countValidee" value="${countValidee + 1}"/></c:when>
          <c:when test="${cmd.statutName eq 'ANNULEE'}"> <c:set var="countAnnulee" value="${countAnnulee + 1}"/></c:when>
        </c:choose>
      </c:forEach>

      <%-- Onglets filtre --%>
      <div class="flex flex-wrap gap-2 mb-8">

        <button onclick="filterOrders('all')" id="tab-all"
                class="tab-btn active-all flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-sm font-bold uppercase tracking-widest">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
          </svg>
          Toutes
          <span class="font-mono text-xs bg-white/10 px-1.5 py-0.5 rounded-md">${countAll}</span>
        </button>

        <button onclick="filterOrders('en_cours')" id="tab-en_cours"
                class="tab-btn flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-gray-400 text-sm font-bold uppercase tracking-widest hover:text-gold hover:border-gold/30">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          En cours
          <span class="font-mono text-xs bg-white/10 px-1.5 py-0.5 rounded-md">${countCours}</span>
        </button>

        <button onclick="filterOrders('validee')" id="tab-validee"
                class="tab-btn flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-gray-400 text-sm font-bold uppercase tracking-widest hover:text-emerald-400 hover:border-emerald-500/30">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          Confirmées
          <span class="font-mono text-xs bg-white/10 px-1.5 py-0.5 rounded-md">${countValidee}</span>
        </button>

        <button onclick="filterOrders('annulee')" id="tab-annulee"
                class="tab-btn flex items-center gap-2 px-4 py-2 rounded-xl border border-white/10 text-gray-400 text-sm font-bold uppercase tracking-widest hover:text-rose-400 hover:border-rose-500/30">
          <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
          Annulées
          <span class="font-mono text-xs bg-white/10 px-1.5 py-0.5 rounded-md">${countAnnulee}</span>
        </button>

      </div>

      <%-- Message aucun résultat pour ce filtre --%>
      <div id="empty-filter" class="hidden text-center py-16 bg-gray-900/20 rounded-3xl border border-dashed border-gray-800 mb-6">
        <p class="text-gray-500 text-sm">Aucune commande dans cette catégorie.</p>
      </div>

      <%-- Liste des commandes --%>
      <div class="space-y-6" id="orders-list">
        <c:forEach var="commande" items="${commandes}">
          <div class="order-card bg-gray-900/40 border border-gray-800 rounded-2xl p-6 md:p-8 flex flex-col gap-6"
               data-statut="${fn:toLowerCase(commande.statutName)}">

            <%-- Header --%>
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 pb-5 border-b border-gray-800">
              <div class="space-y-2">
                <div class="flex items-center gap-3 flex-wrap">
                  <span class="font-mono font-bold text-sm bg-gray-800 text-gold px-2.5 py-1 rounded-lg border border-gray-700">
                    # ${commande.id}
                  </span>
                  <c:choose>
                    <c:when test="${commande.statutName eq 'EN_COURS'}">
                      <span class="text-[10px] font-bold uppercase px-2.5 py-1 rounded-full border border-gold/50 text-gold bg-gold/10 tracking-widest flex items-center gap-1">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        En traitement
                      </span>
                    </c:when>
                    <c:when test="${commande.statutName eq 'VALIDEE'}">
                      <span class="text-[10px] font-bold uppercase px-2.5 py-1 rounded-full border border-emerald-500/50 text-emerald-400 bg-emerald-500/10 tracking-widest flex items-center gap-1">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        Confirmée
                      </span>
                    </c:when>
                    <c:when test="${commande.statutName eq 'ANNULEE'}">
                      <span class="text-[10px] font-bold uppercase px-2.5 py-1 rounded-full border border-rose-500/50 text-rose-400 bg-rose-500/10 tracking-widest flex items-center gap-1">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                        Annulée
                      </span>
                    </c:when>
                  </c:choose>
                </div>
                <div class="text-xs text-gray-500 uppercase tracking-widest">
                  Passée le <span class="text-gray-300 font-medium">
                    <fmt:formatDate value="${commande.dateCommandeAsDate}" pattern="dd/MM/yyyy à HH:mm"/>
                  </span>
                </div>
              </div>

              <div class="text-right">
                <div class="text-3xl font-display font-bold text-white tracking-tight">
                  <fmt:formatNumber value="${commande.total}" pattern="#,##0.00"/> €
                </div>
                <div class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mt-0.5">
                  Total TTC · ${fn:length(commande.lignes)} article(s)
                </div>
              </div>
            </div>

            <%-- Produits --%>
            <div class="products-scroll max-h-44 overflow-y-auto pr-2">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-x-10 gap-y-1">
                <c:forEach var="ligne" items="${commande.lignes}">
                  <div class="flex justify-between items-center text-sm py-2 border-b border-gray-800/60 hover:bg-white/[0.02] transition-colors group px-2 rounded">
                    <div class="flex items-center gap-3">
                      <span class="font-mono text-xs font-bold bg-gray-800 text-gold px-1.5 py-0.5 rounded group-hover:bg-gold group-hover:text-dark-bg transition-colors">
                        ×${ligne.quantite}
                      </span>
                      <span class="font-medium text-gray-300 group-hover:text-white transition-colors line-clamp-1">
                        ${ligne.produit.nom}
                      </span>
                    </div>
                    <span class="font-medium text-gray-500 shrink-0 ml-4">
                      <fmt:formatNumber value="${ligne.sousTotal}" pattern="#,##0.00"/> €
                    </span>
                  </div>
                </c:forEach>
              </div>
            </div>

            <%-- Footer --%>
            <div class="pt-5 border-t border-gray-800 flex flex-col md:flex-row justify-between items-center gap-4">
              <div class="flex items-center gap-2 text-xs text-gray-500">
                <svg class="w-4 h-4 text-gray-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
                <span class="uppercase tracking-widest">Expédié à :</span>
                <span class="text-gray-400">${commande.adresseLivraison}</span>
              </div>
              <a href="${pageContext.request.contextPath}/commande/detail?id=${commande.id}"
                 class="inline-flex items-center gap-2 px-5 py-2 bg-gray-800 border border-gray-700 text-gray-300 text-xs font-bold uppercase tracking-widest rounded-xl hover:bg-gold hover:text-dark-bg hover:border-gold transition-all">
                Voir la facture
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
              </a>
            </div>

          </div>
        </c:forEach>
      </div>

    </c:otherwise>
  </c:choose>
</main>

<%@ include file="../common/foot.jsp" %>

<script>
  const ACTIVE_CLASSES = {
    all:      'active-all',
    en_cours: 'active-en_cours',
    validee:  'active-validee',
    annulee:  'active-annulee',
  };

  function filterOrders(statut) {
    // Reset tous les onglets
    ['all', 'en_cours', 'validee', 'annulee'].forEach(s => {
      const btn = document.getElementById('tab-' + s);
      btn.classList.remove('active-all', 'active-en_cours', 'active-validee', 'active-annulee');
    });
    // Activer l'onglet cliqué
    document.getElementById('tab-' + statut).classList.add(ACTIVE_CLASSES[statut]);

    // Filtrer les cartes
    const cards = document.querySelectorAll('#orders-list .order-card');
    let visible = 0;
    cards.forEach(card => {
      const match = statut === 'all' || card.dataset.statut === statut;
      card.style.display = match ? '' : 'none';
      if (match) {
        // Relancer l'animation avec délai en cascade
        card.style.animationDelay = (visible * 0.07) + 's';
        card.style.animation = 'none';
        void card.offsetWidth; // reflow
        card.style.animation = '';
        visible++;
      }
    });

    // Afficher/masquer le message vide
    document.getElementById('empty-filter').classList.toggle('hidden', visible > 0);
  }
</script>
</body>
</html>
