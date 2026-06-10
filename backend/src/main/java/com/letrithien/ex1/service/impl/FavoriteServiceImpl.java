package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.entity.Favorite;
import com.letrithien.ex1.entity.Product;
import com.letrithien.ex1.repository.UserRepository;
import com.letrithien.ex1.repository.FavoriteRepository;
import com.letrithien.ex1.repository.ProductRepository;
import com.letrithien.ex1.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final UserRepository UserRepository;
    private final ProductRepository productRepository;

    @Override
    public List<Favorite> getUserFavorites(UUID UserId) {
        return favoriteRepository.findByUser_Id(UserId);
    }

    @Override
    @Transactional
    public Favorite addFavorite(UUID UserId, UUID productId, String size) {
        if (favoriteRepository.existsByUser_IdAndProduct_Id(UserId, productId)) {
            Favorite existing = favoriteRepository.findByUser_IdAndProduct_Id(UserId, productId).get();
            existing.setSize(size);
            return favoriteRepository.save(existing);
        }

        User User = UserRepository.findById(UserId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        Favorite favorite = new Favorite();
        favorite.setUser(User);
        favorite.setProduct(product);
        favorite.setSize(size);
        return favoriteRepository.save(favorite);
    }

    @Override
    @Transactional
    public void removeFavorite(UUID UserId, UUID productId) {
        favoriteRepository.deleteByUser_IdAndProduct_Id(UserId, productId);
    }

    @Override
    public boolean isFavorite(UUID UserId, UUID productId) {
        return favoriteRepository.existsByUser_IdAndProduct_Id(UserId, productId);
    }
}
