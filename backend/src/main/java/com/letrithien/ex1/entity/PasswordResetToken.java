package com.letrithien.ex1.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Entity
@Table(name = "password_reset_tokens")
@Data
@NoArgsConstructor
public class PasswordResetToken {
    
    private static final int EXPIRATION = 15; // Hết hạn sau 15 phút

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String token;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private Date expiryDate;

    public PasswordResetToken(String token, User user) {
        this.token = token;
        this.user = user;
        // Tính toán thời gian hết hạn
        this.expiryDate = new Date(System.currentTimeMillis() + EXPIRATION * 60 * 1000);
    }

    public boolean isExpired() {
        return new Date().after(this.expiryDate);
    }
}