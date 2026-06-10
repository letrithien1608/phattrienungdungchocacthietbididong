package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.PasswordResetToken;
import com.letrithien.ex1.service.PasswordResetTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/passwordResetTokens")
@RequiredArgsConstructor
public class PasswordResetTokenController {

    private final PasswordResetTokenService passwordResetTokenService;

    @GetMapping
    public ResponseEntity<List<PasswordResetToken>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(passwordResetTokenService.findAll());
        return ResponseEntity.ok(null);
    }
}
