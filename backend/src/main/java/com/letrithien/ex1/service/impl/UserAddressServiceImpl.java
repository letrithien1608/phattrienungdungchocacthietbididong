package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.UserAddress;
import com.letrithien.ex1.repository.UserAddressRepository;
import com.letrithien.ex1.service.UserAddressService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserAddressServiceImpl implements UserAddressService {

    private final UserAddressRepository UserAddressRepository;

    @Override
    public List<UserAddress> findAll() {
        return UserAddressRepository.findAll();
    }

    @Override
    public UserAddress findById(UUID id) {
        return UserAddressRepository.findById(id).orElseThrow(() -> new RuntimeException("UserAddress not found"));
    }

    @Override
    public UserAddress save(UserAddress entity) {
        return UserAddressRepository.save(entity);
    }

    @Override
    public UserAddress update(UUID id, UserAddress entity) {
        UserAddress existing = findById(id);
        // TODO: Map fields
        return UserAddressRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        UserAddressRepository.deleteById(id);
    }
}
