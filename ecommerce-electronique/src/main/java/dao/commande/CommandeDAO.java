package dao.commande;



import models.Commande;
import dao.GenericDAO;

import java.util.List;



public interface CommandeDAO extends GenericDAO<Commande, Integer> {
    List<Commande> findByClientId(Integer clientId);
    List<Commande> findByStatut(Commande.Statut statut);
    List<Commande> findAllWithClient();
}