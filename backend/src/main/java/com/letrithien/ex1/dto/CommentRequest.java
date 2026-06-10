package com.letrithien.ex1.dto;

import lombok.Data;

@Data
public class CommentRequest {
    private Integer rating;
    private String content;
    private String image;
}
