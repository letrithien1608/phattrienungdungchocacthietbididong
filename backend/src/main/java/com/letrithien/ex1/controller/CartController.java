package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Cart;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.Map;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @GetMapping
    public ResponseEntity<?> getCart(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        Cart cart = cartService.getUserCart(user.getId());
        java.util.List<com.letrithien.ex1.entity.CartItem> items = cartService.getCartItems(cart.getId());
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        response.put("id", cart.getId());
        response.put("items", items);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/add")
    public ResponseEntity<?> addToCart(
            @AuthenticationPrincipal User user,
            @RequestBody Map<String, Object> request) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        UUID productId = UUID.fromString(request.get("productId").toString());
        Integer quantity = Integer.parseInt(request.get("quantity").toString());
        cartService.addToCart(user.getId(), productId, quantity);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateQuantity(
            @AuthenticationPrincipal User user,
            @RequestBody Map<String, Object> request) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        UUID productId = UUID.fromString(request.get("productId").toString());
        Integer quantity = Integer.parseInt(request.get("quantity").toString());
        cartService.updateQuantity(user.getId(), productId, quantity);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/remove/{productId}")
    public ResponseEntity<?> removeFromCart(
            @AuthenticationPrincipal User user,
            @PathVariable UUID productId) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        cartService.removeFromCart(user.getId(), productId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/clear")
    public ResponseEntity<?> clearCart(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        cartService.clearCart(user.getId());
        return ResponseEntity.ok().build();
    }
}
