package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.User;
import java.util.List;
import java.util.UUID;

public interface UserService {
    List<User> findAll();
    User findById(UUID id);
    User save(User entity);
    User update(UUID id, User entity);
    void delete(UUID id);
}
