<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Créer un compte — TechShop</title>
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
            'dark-bg': '#0a0a0f',
            'bg-elevated': '#111118',
            'bg-card': '#1a1a24',
            'border': '#2a2a35',
            'border-strong': '#3a3a45',
            'text-muted': '#9ca3af',
            'text-secondary': '#d1d5db',
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
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body class="bg-dark-bg text-gray-100 font-sans antialiased min-h-screen">

<div class="min-h-screen grid grid-cols-1 md:grid-cols-2">

  <!-- Panneau gauche -->
  <div class="bg-gradient-to-br from-[#0a0a0f] to-[#0d0d18] hidden md:flex flex-col justify-center p-16 relative overflow-hidden" aria-hidden="true">
    <div class="absolute inset-0" 
         style="background: radial-gradient(ellipse 60% 50% at 60% 30%, rgba(126,184,247,0.1) 0%, transparent 70%),
                         radial-gradient(ellipse 40% 40% at 20% 80%, rgba(240,192,64,0.08) 0%, transparent 60%);">
    </div>
    <div class="relative z-10">
      <div class="font-display text-2xl font-extrabold mb-10">
        <span class="text-gold">⚡</span> TechShop
      </div>
      <h1 class="font-display text-5xl font-extrabold leading-tight tracking-tighter mb-5">
        Rejoignez<br><span class="text-blue-ice">la communauté</span><br>TechShop.
      </h1>
      <p class="text-gray-400 leading-relaxed max-w-sm">
        Créez votre compte en quelques secondes et accédez à des milliers de produits électroniques au meilleur prix.
      </p>
      <div class="mt-12 grid grid-cols-2 gap-4">
        <div class="bg-gray-800/50 border border-gray-700 rounded-lg p-5">
          <div class="font-display text-3xl font-extrabold text-gold">14+</div>
          <div class="text-xs text-gray-500 mt-1">Produits premium</div>
        </div>
        <div class="bg-gray-800/50 border border-gray-700 rounded-lg p-5">
          <div class="font-display text-3xl font-extrabold text-blue-ice">5</div>
          <div class="text-xs text-gray-500 mt-1">Catégories</div>
        </div>
      </div>
    </div>
  </div>

  <!-- Formulaire d'inscription -->
  <main class="flex items-center justify-center p-8 md:p-12 bg-gray-900 overflow-y-auto">
    <div class="w-full max-w-lg animate-fade-up">

      <div class="mb-2">
        <a href="${pageContext.request.contextPath}/catalogue"
           class="text-sm text-gray-500 hover:text-gold inline-flex items-center gap-1 transition-colors">
          ← Retour au catalogue
        </a>
      </div>

      <h2 class="font-display text-3xl font-bold tracking-tight mb-1">
        Créer un compte
      </h2>
      <p class="text-gray-400 text-sm mb-8">
        Tous les champs marqués <span class="text-gold">*</span> sont obligatoires
      </p>

      <c:if test="${not empty erreur}">
        <div class="mb-6 p-4 bg-rose-900/50 border border-rose-600 rounded-xl flex items-center gap-3 text-rose-200" role="alert">
          <span class="text-2xl" aria-hidden="true">⚠️</span>
          <span>${erreur}</span>
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/inscription"
            method="post"
            novalidate
            id="inscriptionForm"
            aria-label="Formulaire d'inscription"
            class="space-y-5">

        <!-- Prénom et Nom -->
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2" for="prenom">
              Prénom <span class="text-gold">*</span>
            </label>
            <input type="text" id="prenom" name="prenom"
                   class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="Jean"
                   value="<c:out value='${prenom}'/>"
                   required minlength="2"
                   autocomplete="given-name"
                   aria-required="true">
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-300 mb-2" for="nom">
              Nom <span class="text-gold">*</span>
            </label>
            <input type="text" id="nom" name="nom"
                   class="w-full h-12 px-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="Dupont"
                   value="<c:out value='${nom}'/>"
                   required minlength="2"
                   autocomplete="family-name"
                   aria-required="true">
          </div>
        </div>

        <!-- Email -->
        <div>
          <label class="block text-sm font-medium text-gray-300 mb-2" for="email">
            Adresse e-mail <span class="text-gold">*</span>
          </label>
          <div class="relative">
            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500" aria-hidden="true">  </span>
            <input type="email" id="email" name="email"
                   class="w-full h-12 pl-11 pr-4 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="jean.dupont@email.com"
                   value="<c:out value='${email}'/>"
                   required
                   autocomplete="email"
                   aria-required="true"
                   aria-describedby="email-hint">
          </div>
          <div class="text-xs text-gray-500 mt-1" id="email-hint">Cet email servira d'identifiant de connexion</div>
        </div>

        <!-- Mot de passe -->
        <div>
          <label class="block text-sm font-medium text-gray-300 mb-2" for="password">
            Mot de passe <span class="text-gold">*</span>
          </label>
          <div class="relative">
            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500" aria-hidden="true"> </span>
            <input type="password" id="password" name="password"
                   class="w-full h-12 pl-11 pr-12 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                   placeholder="Minimum 6 caractères"
                   required minlength="6"
                   autocomplete="new-password"
                   aria-required="true"
                   aria-describedby="pwd-hint"
                   oninput="checkPasswordStrength(this.value)">
            <span class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gold cursor-pointer" 
                  onclick="togglePassword('password', this)"
                  role="button" 
                  tabindex="0" 
                  aria-label="Afficher le mot de passe">👁️</span>
          </div>
          <div class="text-xs text-gray-500 mt-1" id="pwd-hint">Minimum 6 caractères</div>
          <div id="pwd-strength" class="mt-2 hidden">
            <div class="flex gap-1">
              <div class="h-1 flex-1 rounded-full bg-gray-700 transition-all duration-300" id="sb1"></div>
              <div class="h-1 flex-1 rounded-full bg-gray-700 transition-all duration-300" id="sb2"></div>
              <div class="h-1 flex-1 rounded-full bg-gray-700 transition-all duration-300" id="sb3"></div>
              <div class="h-1 flex-1 rounded-full bg-gray-700 transition-all duration-300" id="sb4"></div>
            </div>
            <div id="pwd-strength-label" class="text-xs text-gray-500 mt-1"></div>
          </div>
        </div>

        <!-- Adresse -->
        <div>
          <label class="block text-sm font-medium text-gray-300 mb-2" for="adresse">Adresse de livraison</label>
          <textarea id="adresse" name="adresse"
                    class="w-full px-4 py-3 bg-gray-800/50 border border-gray-700 rounded-xl text-gray-100 placeholder-gray-600 focus:outline-none focus:border-gold focus:ring-2 focus:ring-gold/20 transition-all duration-300"
                    placeholder="12 Rue de la Paix, 75002 Paris"
                    rows="2"
                    autocomplete="street-address"><c:out value='${adresse}'/></textarea>
          <div class="text-xs text-gray-500 mt-1">Peut être modifiée lors de chaque commande</div>
        </div>

        <!-- CGU -->
        <div class="flex items-start gap-3">
          <input type="checkbox" id="cgu" name="cgu"
                 class="w-4 h-4 mt-1 accent-gold bg-gray-700 border-gray-600 rounded focus:ring-gold focus:ring-2"
                 required>
          <label for="cgu" class="text-sm text-gray-400 leading-relaxed cursor-pointer">
            J'accepte les <a href="#" class="text-gold hover:text-gold-dark transition-colors">Conditions Générales d'Utilisation</a>
            et la <a href="#" class="text-gold hover:text-gold-dark transition-colors">Politique de confidentialité</a>
          </label>
        </div>

        <!-- Submit -->
        <button type="submit" 
                class="w-full h-12 bg-gradient-to-r from-gold to-gold-dark text-gray-900 font-medium rounded-xl hover:shadow-lg hover:shadow-gold/20 transition-all duration-300 flex items-center justify-center gap-2">
          <span>Créer mon compte</span>
          <span aria-hidden="true">  </span>
        </button>
      </form>

      <!-- Lien connexion -->
      <div class="text-center mt-6 text-sm text-gray-400">
        Déjà un compte ?
        <a href="${pageContext.request.contextPath}/login" class="text-gold font-semibold hover:text-gold-dark transition-colors">Se connecter</a>
      </div>

    </div>
  </main>
</div>

<script>
  function togglePassword(id, btn) {
    const input = document.getElementById(id);
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁️' : '🙈';
  }

  function checkPasswordStrength(pwd) {
    const bars = ['sb1','sb2','sb3','sb4'];
    const label = document.getElementById('pwd-strength-label');
    const container = document.getElementById('pwd-strength');
    container.style.display = pwd.length > 0 ? 'block' : 'none';

    let score = 0;
    if (pwd.length >= 6) score++;
    if (pwd.length >= 10) score++;
    if (/[A-Z]/.test(pwd) && /[0-9]/.test(pwd)) score++;
    if (/[^A-Za-z0-9]/.test(pwd)) score++;

    const colors = ['', '#f06060', '#f0c040', '#7eb8f7', '#4cdb8f'];
    const labels = ['', 'Trop court', 'Faible', 'Moyen', 'Fort'];
    bars.forEach((id, i) => {
      document.getElementById(id).style.background = i < score ? colors[score] : '#374151';
    });
    label.textContent = labels[score] || '';
    label.style.color = colors[score];
  }

  document.getElementById('inscriptionForm').addEventListener('submit', function(e) {
    const cgu = document.getElementById('cgu');
    if (!cgu.checked) {
      e.preventDefault();
      alert('Veuillez accepter les Conditions Générales d\'Utilisation');
    }
  });
</script>
</body>
</html>