package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Comment;
import com.letrithien.ex1.repository.CommentRepository;
import com.letrithien.ex1.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl implements CommentService {

    private final CommentRepository commentRepository;

    @Override
    public List<Comment> findAll() {
        return commentRepository.findAll();
    }

    @Override
    public Comment findById(UUID id) {
        return commentRepository.findById(id).orElseThrow(() -> new RuntimeException("Comment not found"));
    }

    @Override
    public List<Comment> findByProductId(UUID productId) {
        return commentRepository.findByProductIdOrderByCreatedAtDesc(productId);
    }

    @Override
    public List<Comment> findByUserId(UUID userId) {
        return commentRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Override
    public java.util.Optional<Comment> findByUserIdAndProductId(UUID userId, UUID productId) {
        return commentRepository.findByUserIdAndProductId(userId, productId);
    }

    @Override
    public Comment save(Comment entity) {
        return commentRepository.save(entity);
    }

    @Override
    public Comment update(UUID id, Comment entity) {
        Comment existing = findById(id);
        // TODO: Map fields
        return commentRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        commentRepository.deleteById(id);
    }
}
