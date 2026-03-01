package util;


import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Singleton utilitaire pour la gestion de l'EntityManagerFactory JPA.
 * Assure une seule instance de l'EMF par application.
 */
public class JPAUtil {

    private static final String PERSISTENCE_UNIT = "ecommercePU";
    private static EntityManagerFactory emf;

    private JPAUtil() {}

    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (emf == null || !emf.isOpen()) {
            emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT);
        }
        return emf;
    }

    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    public static void closeEntityManagerFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
