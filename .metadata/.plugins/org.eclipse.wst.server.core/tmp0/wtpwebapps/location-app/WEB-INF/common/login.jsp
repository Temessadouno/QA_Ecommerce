<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Connexion — TechShop</title>
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
            'gold-glow': 'rgba(212, 175, 55, 0.15)',
            'dark-bg': '#0a0a0f',
            'bg-elevated': '#111118',
            'border': '#2a2a35',
            'border-strong': '#3a3a45',
          },
          fontFamily: {
            display: ['Syne', 'sans-serif'],
            sans: ['DM Sans', 'sans-serif'],
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
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body class="bg-dark-bg text-gray-100 font-sans antialiased min-h-screen">

<div class="min-h-screen grid grid-cols-1 md:grid-cols-2">

  <%-- ── Panneau gauche ── --%>
  <div class="bg-gradient-to-br from-[#0a0a0f] via-[#111118] to-[#0d0d18] hidden md:flex flex-col justify-center items-start p-16 relative overflow-hidden" aria-hidden="true">
    <div class="absolute inset-0" 
         style="background: radial-gradient(ellipse 60% 60% at 30% 40%, rgba(240,192,64,0.12) 0%, transparent 70%),
                         radial-gradient(ellipse 40% 40% at 70% 70%, rgba(126,184,247,0.08) 0%, transparent 60%);">
    </div>
    <div class="relative z-10">
      <div class="flex items-center gap-3 mb-12">
        <div class="w-[42px] h-[42px] bg-gradient-to-br from-gold to-amber-600 rounded-lg flex items-center justify-center text-xl shadow-[0_0_30px_rgba(212,175,55,0.3)]">
          ⚡
        </div>
        <span class="font-display text-2xl font-extrabold">Tech<span class="text-gold">Shop</span></span>
      </div>
      <h1 class="font-display text-5xl font-extrabold leading-tight tracking-tighter mb-6">
        L'excellence<br><span class="text-gold">technologique</span><br>à portée de main.
      </h1>
      <p class="text-gray-400 text-base leading-relaxed max-w-md mb-12">
        Découvrez notre catalogue de produits électroniques premium — smartphones, laptops, audio et bien plus.
      </p>
      <div class="space-y-4">
        <div class="flex items-center gap-4">
          <div class="w-9 h-9 bg-gold-glow border border-gold/20 rounded-lg flex items-center justify-center text-base shrink-0">  </div>
          <span class="text-sm text-gray-400">Paiement sécurisé & données protégées</span>
        </div>
        <div class="flex items-center gap-4">
          <div class="w-9 h-9 bg-gold-glow border border-gold/20 rounded-lg flex items-center justify-center text-base shrink-0">  </div>
          <span class="text-sm text-gray-400">Livraison express en 24h</span>
        </div>
        <div class="flex items-center gap-4">
          <div class="w-9 h-9 bg-gold-glow border border-gold/20 rounded-lg flex items-center justify-center text-base shrink-0">  </div>
          <span class="text-sm text-gray-400">Garantie constructeur sur tous les produits</span>
        </div>
      </div>
    </div>
  </div>

  <%-- ── Formulaire de connexion ── --%>
  <main class="flex items-center justify-center p-8 md:p-12 bg-gray-900">
    <div class="w-full max-w-md animate-fade-up">

      <h2 class="font-display text-3xl font-bold tracking-tight mb-1">Bon retour   </h2>
      <p class="text-gray-400 text-sm mb-8">Connectez-vous à votre compte TechShop</p>

      <%-- Alertes qualité --%>
      <c:if test="${not empty succes}">
        <div class="mb-6 p-4 bg-emerald-900/50 border border-emerald-600 rounded-xl flex items-center gap-3 text-emerald-200" role="alert">
          <span class="text-2xl" aria-hidden="true">   </span>
          <span>${succes}</span>
        </div>
      </c:if>
      <c:if test="${not empty erreur}">
        <div class="mb-6 p-4 bg-rose-900/50 border border-rose-600 rounded-xl flex items-center gap-3 text-rose-200" role="alert">
          <span class="text-2xl" aria-hidden="true">    </span>
          <span>${erreur}</span>
        </div>
      </c:if>

      <%-- Formulaire avec validation HTML5 + contraintes qualité --%>
      <form action="${pageContext.request.contextPath}/login"
            method="post"
            novalidate
            id="loginForm"
            aria-label="Formulaire de connexion"
            class="space-y-5">

        <%-- Protection CSRF (à implémenter) --%>
        <%-- <input type="hidden" name="_csrf" value="${csrfToken}"> --%>

        <div>
          <div class="flex justify-between items-baseline mb-2">
            <label class="text-sm font-medium text-gray-300" for="email">
              Adresse e-mail <span class="text-gold" aria-hidden="true">*</span>
            </label>
          </div>
          <div class="relative">
            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 text-sm" aria-hidden="true">      </span>
            <input type="email"
                   id="email"
                   name="email"
                   class="w-full h-12 pl-10 pr-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="votre@email.com"
                   value="<c:out value='${email}'/>"
                   required
                   autocomplete="email"
                   aria-describedby="email-hint"
                   aria-required="true">
          </div>
          <div class="text-xs text-gray-500 mt-1" id="email-hint">Entrez l'email associé à votre compte</div>
        </div>

        <div>
          <div class="flex justify-between items-baseline mb-2">
            <label class="text-sm font-medium text-gray-300" for="password">
              Mot de passe <span class="text-gold" aria-hidden="true">*</span>
            </label>
            <a href="#" class="text-xs text-gold hover:text-gold-dark transition-colors">Mot de passe oublié ?</a>
          </div>
          <div class="relative">
            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 text-sm" aria-hidden="true">       </span>
            <input type="password"
                   id="password"
                   name="password"
                   class="w-full h-12 pl-10 pr-12 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="••••••••"
                   required
                   autocomplete="current-password"
                   aria-required="true">
            <span class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gold cursor-pointer text-sm select-none" 
                  onclick="togglePassword('password', this)"
                  role="button" 
                  tabindex="0" 
                  aria-label="Afficher/masquer le mot de passe">👁️</span>
          </div>
        </div>

        <div class="flex items-center gap-2">
          <input type="checkbox" id="remember" name="remember"
                 class="w-4 h-4 accent-gold bg-gray-700 border-gray-600 rounded focus:ring-gold focus:ring-2">
          <label for="remember" class="text-sm text-gray-400 cursor-pointer select-none">
            Se souvenir de moi
          </label>
        </div>

        <button type="submit"
                class="w-full h-12 bg-gradient-to-r from-gold to-gold-dark text-gray-900 font-medium rounded-xl hover:shadow-lg hover:shadow-gold/20 transition-all duration-300 flex items-center justify-center gap-2"
                id="submitBtn">
          <span>Se connecter</span>
          <span aria-hidden="true">→</span>
        </button>
      </form>

      <div class="flex items-center gap-4 my-6">
        <div class="flex-1 h-px bg-gray-800"></div>
        <span class="text-xs text-gray-500">ou</span>
        <div class="flex-1 h-px bg-gray-800"></div>
      </div>

      <div class="text-center text-sm text-gray-400">
        Pas encore de compte ?
        <a href="${pageContext.request.contextPath}/inscription" class="text-gold font-semibold hover:text-gold-dark transition-colors">Créer un compte gratuitement</a>
      </div>

      <%-- Comptes de test (développement uniquement) --%>
      <div class="mt-8 p-4 bg-gray-800/50 border border-gray-700 rounded-xl text-xs">
        <div class="text-gray-400 font-semibold mb-2">🧪 Comptes de test</div>
        <div class="text-gray-500">Admin : admin@ecommerce.com / Admin2024!</div>
        <div class="text-gray-500">Client : jean.dupont@test.com / Test1234!</div>
      </div>

    </div>
  </main>
</div>

<script>
  // Contrainte qualité : validation côté client en complément du serveur
  function togglePassword(id, btn) {
    const input = document.getElementById(id);
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁️' : '🙈';
  }

  // Validation HTML5 améliorée avec accessibilité
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    const email = document.getElementById('email');
    const password = document.getElementById('password');
    let valid = true;

    if (!email.value.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
      email.setCustomValidity('Adresse email invalide');
      valid = false;
    } else {
      email.setCustomValidity('');
    }

    if (!password.value) {
      password.setCustomValidity('Le mot de passe est obligatoire');
      valid = false;
    } else {
      password.setCustomValidity('');
    }

    if (!valid) { e.preventDefault(); this.reportValidity(); }
  });
</script>
</body>
</html>