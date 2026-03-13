package dao.panier;



import models.PanierItem;
import java.util.List;
import java.util.Optional;

public interface PanierDAO {
	int  getPanierCount(Integer clientId);
    PanierItem save(PanierItem item);
    PanierItem update(PanierItem item);
    void delete(Integer itemId);
    void deleteByClientId(Integer clientId);
    void updateItemQuantity(Integer itemId,int quantite);
    List<PanierItem> findByClientId(Integer clientId);
    Optional<PanierItem> findByClientAndProduit(Integer clientId, Integer produitId);
}
