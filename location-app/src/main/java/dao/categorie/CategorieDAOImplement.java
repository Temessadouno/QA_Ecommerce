package dao.categorie;


import jakarta.persistence.EntityManager;
import models.Categorie;
import util.JPAUtil;

import java.util.List;
import java.util.Optional;

public class CategorieDAOImplement implements CategorieDAO {

    @Override
    public Categorie save(Categorie c) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(c);
            em.getTransaction().commit();
            return c;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur création catégorie", e);
        } finally { em.close(); }
    }

    @Override
    public Categorie update(Categorie c) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Categorie merged = em.merge(c);
            em.getTransaction().commit();
            return merged;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur mise à jour catégorie", e);
        } finally { em.close(); }
    }

    @Override
    public void delete(Integer id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Categorie c = em.find(Categorie.class, id);
            if (c != null) em.remove(c);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Erreur suppression catégorie", e);
        } finally { em.close(); }
    }

    @Override
    public Optional<Categorie> findById(Integer id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return Optional.ofNullable(em.find(Categorie.class, id));
        } finally { em.close(); }
    }

    @Override
    public List<Categorie> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Categorie c ORDER BY c.nom ASC", Categorie.class)
                     .getResultList();
        } finally { em.close(); }
    }
}