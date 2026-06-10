package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Favorite;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping
    public ResponseEntity<?> getFavorites(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        List<Favorite> favorites = favoriteService.getUserFavorites(user.getId());
        List<Map<String, Object>> result = favorites.stream().map(fav -> {
            Map<String, Object> map = new java.util.HashMap<>();
            com.letrithien.ex1.entity.Product p = fav.getProduct();
            map.put("id", p.getId());
            map.put("productName", p.getProductName());
            map.put("salePrice", p.getSalePrice());
            map.put("comparePrice", p.getComparePrice());
            map.put("quantity", p.getQuantity());
            map.put("shortDescription", p.getShortDescription());
            map.put("productType", p.getProductType());
            map.put("image", p.getImage());
            map.put("favoriteSize", fav.getSize());
            return map;
        }).collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(result);
    }

    @PostMapping
    public ResponseEntity<?> addFavorite(
            @AuthenticationPrincipal User user,
            @RequestBody Map<String, Object> payload) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        UUID productId = UUID.fromString((String) payload.get("productId"));
        String size = (String) payload.get("size");
        favoriteService.addFavorite(user.getId(), productId, size);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{productId}")
    public ResponseEntity<?> removeFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable UUID productId) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        favoriteService.removeFavorite(user.getId(), productId);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/check/{productId}")
    public ResponseEntity<?> checkFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable UUID productId) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        boolean isFav = favoriteService.isFavorite(user.getId(), productId);
        return ResponseEntity.ok(Map.of("isFavorite", isFav));
    }
}
