package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.CartItem;
import java.util.List;
import java.util.UUID;

public interface CartItemService {
    List<CartItem> findAll();
    CartItem findById(UUID id);
    CartItem save(CartItem entity);
    CartItem update(UUID id, CartItem entity);
    void delete(UUID id);
}
