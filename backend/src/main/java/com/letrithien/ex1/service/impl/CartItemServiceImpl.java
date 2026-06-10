package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.CartItem;
import com.letrithien.ex1.repository.CartItemRepository;
import com.letrithien.ex1.service.CartItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CartItemServiceImpl implements CartItemService {

    private final CartItemRepository CartItemRepository;

    @Override
    public List<CartItem> findAll() {
        return CartItemRepository.findAll();
    }

    @Override
    public CartItem findById(UUID id) {
        return CartItemRepository.findById(id).orElseThrow(() -> new RuntimeException("CartItem not found"));
    }

    @Override
    public CartItem save(CartItem entity) {
        return CartItemRepository.save(entity);
    }

    @Override
    public CartItem update(UUID id, CartItem entity) {
        CartItem existing = findById(id);
        // TODO: Map fields
        return CartItemRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        CartItemRepository.deleteById(id);
    }
}
