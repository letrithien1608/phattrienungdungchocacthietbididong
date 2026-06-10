package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Cart;
import com.letrithien.ex1.entity.CartItem;

import java.util.UUID;

public interface CartService {
    Cart getUserCart(UUID UserId);
    java.util.List<com.letrithien.ex1.entity.CartItem> getCartItems(UUID cartId);
    CartItem addToCart(UUID UserId, UUID productId, Integer quantity);
    void removeFromCart(UUID UserId, UUID productId);
    CartItem updateQuantity(UUID UserId, UUID productId, Integer quantity);
    void clearCart(UUID UserId);
}
