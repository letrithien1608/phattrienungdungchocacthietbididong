package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Comment;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.dto.CommentDTO;
import com.letrithien.ex1.dto.CommentRequest;
import com.letrithien.ex1.service.CommentService;
import com.letrithien.ex1.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.Map;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;
    private final UserRepository userRepository;

    @GetMapping
    public ResponseEntity<List<Comment>> getAll() {
        return ResponseEntity.ok(commentService.findAll());
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<List<CommentDTO>> getByProductId(@PathVariable UUID productId) {
        List<Comment> comments = commentService.findByProductId(productId);
        List<CommentDTO> response = comments.stream().map(c -> convertToDTO(c)).collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/my-reviews")
    public ResponseEntity<List<CommentDTO>> getMyReviews(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).body(null);
        }
        List<Comment> comments = commentService.findByUserId(user.getId());
        List<CommentDTO> response = comments.stream().map(c -> convertToDTO(c)).collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/product/{productId}")
    public ResponseEntity<?> create(
            @AuthenticationPrincipal User user,
            @PathVariable UUID productId,
            @RequestBody CommentRequest request) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        java.util.Optional<Comment> existingOpt = commentService.findByUserIdAndProductId(user.getId(), productId);
        Comment comment = existingOpt.orElse(new Comment());
        comment.setUserId(user.getId());
        comment.setProductId(productId);
        comment.setRating(request.getRating());
        comment.setReviewText(request.getContent());
        comment.setImageUrl(request.getImage());
        comment.setCreatedAt(java.time.LocalDateTime.now());
        
        return ResponseEntity.ok(convertToDTO(commentService.save(comment)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Comment> update(@PathVariable UUID id, @RequestBody Comment comment) {
        return ResponseEntity.ok(commentService.update(id, comment));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        commentService.delete(id);
        return ResponseEntity.ok().build();
    }

    private CommentDTO convertToDTO(Comment c) {
        CommentDTO dto = new CommentDTO();
        dto.setId(c.getId());
        dto.setProductId(c.getProductId());
        dto.setRating(c.getRating());
        dto.setContent(c.getReviewText());
        dto.setImage(c.getImageUrl());
        dto.setCreatedAt(c.getCreatedAt() != null ? c.getCreatedAt().toString() : "");

        CommentDTO.UserDTO userDTO = new CommentDTO.UserDTO();
        userDTO.setId(c.getUserId());
        String fullName = "Anonymous";
        User commentUser = userRepository.findById(c.getUserId()).orElse(null);
        if (commentUser != null) {
            fullName = (commentUser.getFirstName() != null ? commentUser.getFirstName() : "") + " " + 
                       (commentUser.getLastName() != null ? commentUser.getLastName() : "");
        }
        userDTO.setFullName(fullName.trim());
        dto.setUser(userDTO);

        return dto;
    }
}
