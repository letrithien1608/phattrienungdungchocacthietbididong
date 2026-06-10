package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, UUID> {
    List<Favorite> findByUser_Id(UUID UserId);
    Optional<Favorite> findByUser_IdAndProduct_Id(UUID UserId, UUID productId);
    boolean existsByUser_IdAndProduct_Id(UUID UserId, UUID productId);
    void deleteByUser_IdAndProduct_Id(UUID UserId, UUID productId);
}
