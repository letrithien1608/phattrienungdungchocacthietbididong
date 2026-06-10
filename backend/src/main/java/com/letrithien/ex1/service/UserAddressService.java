package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.UserAddress;
import java.util.List;
import java.util.UUID;

public interface UserAddressService {
    List<UserAddress> findAll();
    UserAddress findById(UUID id);
    UserAddress save(UserAddress entity);
    UserAddress update(UUID id, UserAddress entity);
    void delete(UUID id);
}
