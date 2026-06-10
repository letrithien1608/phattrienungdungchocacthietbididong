package com.letrithien.ex1.dto;

import lombok.Data;
import java.util.UUID;

@Data
public class CommentDTO {
    private UUID id;
    private UUID productId;
    private Integer rating;
    private String content;
    private String image;
    private String createdAt;
    private UserDTO user;

    @Data
    public static class UserDTO {
        private UUID id;
        private String fullName;
    }
}
