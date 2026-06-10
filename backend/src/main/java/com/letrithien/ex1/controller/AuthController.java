package com.letrithien.ex1.controller;

import com.letrithien.ex1.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    
    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody Map<String, Object> request) {
        try {
            String token = authService.register(request);
            return ResponseEntity.ok(Map.of("token", token));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, Object> request) {
        try {
            String token = authService.login(request);
            return ResponseEntity.ok(Map.of("token", token));
        } catch (Exception e) {
            return ResponseEntity.status(401).body(Map.of("error", "Sai email hoặc mật khẩu"));
        }
    }

    @PostMapping("/social")
    public ResponseEntity<?> socialLogin(@RequestBody Map<String, Object> request) {
        try {
            String token = authService.socialLogin(request);
            return ResponseEntity.ok(Map.of("token", token));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
    // ... (Các code cũ giữ nguyên) ...

    // API Quên mật khẩu (Gửi email)
    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody Map<String, Object> request) {
        try {
            authService.processForgotPassword(request);
            return ResponseEntity.ok(Map.of("message", "Đã gửi link đặt lại mật khẩu vào email của bạn"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    // API Đặt lại mật khẩu mới
    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, Object> request) {
        try {
            authService.resetPassword(request);
            return ResponseEntity.ok(Map.of("message", "Đặt lại mật khẩu thành công"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}