package dao;


import java.util.List;
import java.util.Optional;

/**
 * Interface générique DAO définissant les opérations CRUD de base.
 *
 * @param <T>  Type de l'entité
 * @param <ID> Type de l'identifiant
 */
public interface GenericDAO<T, ID> {

    T save(T entity);
    T update(T entity);
    void delete(ID id);
    Optional<T> findById(ID id);
    List<T> findAll();
}
