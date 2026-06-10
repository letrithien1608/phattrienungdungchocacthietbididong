package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Favorite;
import java.util.List;
import java.util.UUID;

public interface FavoriteService {
    List<Favorite> getUserFavorites(UUID UserId);
    Favorite addFavorite(UUID UserId, UUID productId, String size);
    void removeFavorite(UUID UserId, UUID productId);
    boolean isFavorite(UUID UserId, UUID productId);
}
