<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="validerPanier" value="panier" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Confirmation de commande</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
</head>
<body class="bg-gray-50">
<%@ include file="../common/navbar.jsp" %>
    
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Confirmation de votre commande</h1>
        
        <%-- Affichage des erreurs éventuelles --%>
        <c:if test="${not empty erreur}">
            <div class="mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700 rounded" role="alert">
                <p class="font-medium">Erreur</p>
                <p>${erreur}</p>
            </div>
        </c:if>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Récapitulatif du panier -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg shadow-md overflow-hidden">
                    <div class="bg-gray-50 px-6 py-4 border-b border-gray-200">
                        <h3 class="text-xl font-semibold text-gray-800">Récapitulatif de votre panier</h3>
                    </div>
                    <div class="p-6">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Produit
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Prix unitaire
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Quantité
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Total
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="item" items="${panierItems}">
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">
                                                    ${item.produit.nom}
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-900">${item.produit.prix} €</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm text-gray-900">${item.quantite}</div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="text-sm font-medium text-gray-900">
                                                    ${item.produit.prix * item.quantite} €
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="bg-gray-50">
                                    <tr>
                                        <th colspan="3" scope="row" class="px-6 py-4 text-right text-sm font-medium text-gray-900">
                                            Total
                                        </th>
                                        <td class="px-6 py-4 whitespace-nowrap text-lg font-bold text-gray-900">
                                            ${total} €
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Formulaire adresse de livraison -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-lg shadow-md overflow-hidden sticky top-6">
                    <div class="bg-gray-50 px-6 py-4 border-b border-gray-200">
                        <h3 class="text-xl font-semibold text-gray-800">Adresse de livraison</h3>
                    </div>
                    <div class="p-6">
                        <form action="${pageContext.request.contextPath}/commande/validerPanier" method="post">
                            <div class="mb-4">
                                <label for="adresseLivraison" class="block text-sm font-medium text-gray-700 mb-2">
                                    Adresse complète :
                                </label>
                                <textarea id="adresseLivraison" 
                                          name="adresseLivraison" 
                                          rows="4"
                                          required
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">${sessionScope.client.adresseLivraison}</textarea>
                            </div>
                            
                            <div class="space-y-3">
                                <button type="submit" 
                                        class="w-full bg-gold hover:bg-green-700 text-white font-medium py-2 px-4 rounded-md transition duration-200 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2">
                                    Confirmer la commande
                                </button>
                                
                                <a href="${pageContext.request.contextPath}/panier" 
                                   class="block w-full text-center bg-gray-200 hover:bg-gray-300 text-gray-700 font-medium py-2 px-4 rounded-md transition duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">
                                    Retour au panier
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Résumé des informations client (optionnel) -->
        <div class="mt-8 bg-white rounded-lg shadow-md p-6">
            <h3 class="text-lg font-semibold text-gray-800 mb-4">Informations client</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <p class="text-sm text-gray-600">Nom :</p>
                    <p class="font-medium">${sessionScope.client.nom} ${sessionScope.client.prenom}</p>
                </div>
                <div>
                    <p class="text-sm text-gray-600">Email :</p>
                    <p class="font-medium">${sessionScope.client.email}</p>
                </div>
            </div>
        </div>
    </main>
    
<%@ include file="../common/foot.jsp" %>
</body>
</html>