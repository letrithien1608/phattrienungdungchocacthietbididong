package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.repository.UserRepository;
import com.letrithien.ex1.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public User findById(UUID id) {
        return userRepository.findById(id).orElseThrow(() -> new RuntimeException("User not found"));
    }

    @Override
    public User save(User entity) {
        return userRepository.save(entity);
    }

    @Override
    public User update(UUID id, User entity) {
        User existing = findById(id);
        // TODO: Map fields
        return userRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        userRepository.deleteById(id);
    }
}
