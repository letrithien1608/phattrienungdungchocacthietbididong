package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, UUID> {
    List<Comment> findByProductIdOrderByCreatedAtDesc(UUID productId);
    List<Comment> findByUserIdOrderByCreatedAtDesc(UUID userId);
    java.util.Optional<Comment> findByUserIdAndProductId(UUID userId, UUID productId);
}
