package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Cart;
import com.letrithien.ex1.entity.CartItem;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.entity.Product;
import com.letrithien.ex1.repository.CartItemRepository;
import com.letrithien.ex1.repository.CartRepository;
import com.letrithien.ex1.repository.UserRepository;
import com.letrithien.ex1.repository.ProductRepository;
import com.letrithien.ex1.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final UserRepository UserRepository;
    private final ProductRepository productRepository;

    @Override
    @Transactional
    public Cart getUserCart(UUID UserId) {
        return cartRepository.findByUser_Id(UserId).orElseGet(() -> {
            User User = UserRepository.findById(UserId)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            Cart cart = new Cart();
            cart.setUser(User);
            return cartRepository.save(cart);
        });
    }

    @Override
    @Transactional
    public java.util.List<CartItem> getCartItems(UUID cartId) {
        return cartItemRepository.findByCart_Id(cartId);
    }

    @Override
    @Transactional
    public CartItem addToCart(UUID UserId, UUID productId, Integer quantity) {
        Cart cart = getUserCart(UserId);
        
        Optional<CartItem> existingItem = cartItemRepository.findByCart_IdAndProduct_Id(cart.getId(), productId);
        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + quantity);
            return cartItemRepository.save(item);
        }

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        CartItem newItem = new CartItem();
        newItem.setCart(cart);
        newItem.setProduct(product);
        newItem.setQuantity(quantity);
        return cartItemRepository.save(newItem);
    }

    @Override
    @Transactional
    public void removeFromCart(UUID UserId, UUID productId) {
        Cart cart = getUserCart(UserId);
        cartItemRepository.findByCart_IdAndProduct_Id(cart.getId(), productId)
                .ifPresent(cartItemRepository::delete);
    }

    @Override
    @Transactional
    public CartItem updateQuantity(UUID UserId, UUID productId, Integer quantity) {
        Cart cart = getUserCart(UserId);
        CartItem item = cartItemRepository.findByCart_IdAndProduct_Id(cart.getId(), productId)
                .orElseThrow(() -> new RuntimeException("Item not found in cart"));
        
        if (quantity <= 0) {
            cartItemRepository.delete(item);
            return null;
        } else {
            item.setQuantity(quantity);
            return cartItemRepository.save(item);
        }
    }

    @Override
    @Transactional
    public void clearCart(UUID UserId) {
        Cart cart = getUserCart(UserId);
        cartItemRepository.deleteByCart_Id(cart.getId());
    }
}
