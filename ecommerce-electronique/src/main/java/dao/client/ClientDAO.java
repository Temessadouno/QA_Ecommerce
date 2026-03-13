package dao.client;



import models.Client;
import java.util.Optional;

import dao.GenericDAO;

public interface ClientDAO extends GenericDAO<Client, Integer> {
    Optional<Client> findByEmail(String email);
    boolean existsByEmail(String email);
}
