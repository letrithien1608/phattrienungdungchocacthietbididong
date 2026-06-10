package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Comment;
import java.util.List;
import java.util.UUID;

public interface CommentService {
    List<Comment> findAll();
    Comment findById(UUID id);
    List<Comment> findByProductId(UUID productId);
    List<Comment> findByUserId(UUID userId);
    java.util.Optional<Comment> findByUserIdAndProductId(UUID userId, UUID productId);
    Comment save(Comment entity);
    Comment update(UUID id, Comment entity);
    void delete(UUID id);
}
