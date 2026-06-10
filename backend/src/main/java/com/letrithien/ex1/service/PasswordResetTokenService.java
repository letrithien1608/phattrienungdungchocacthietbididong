package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.PasswordResetToken;
import java.util.List;


public interface PasswordResetTokenService {
    List<PasswordResetToken> findAll();
    PasswordResetToken findById(Long id);
    PasswordResetToken save(PasswordResetToken entity);
    PasswordResetToken update(Long id, PasswordResetToken entity);
    void delete(Long id);
}
