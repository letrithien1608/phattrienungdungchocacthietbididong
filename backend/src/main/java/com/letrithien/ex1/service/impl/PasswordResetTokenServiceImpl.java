package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.PasswordResetToken;
import com.letrithien.ex1.repository.PasswordResetTokenRepository;
import com.letrithien.ex1.service.PasswordResetTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class PasswordResetTokenServiceImpl implements PasswordResetTokenService {

    private final PasswordResetTokenRepository passwordResetTokenRepository;

    @Override
    public List<PasswordResetToken> findAll() {
        return passwordResetTokenRepository.findAll();
    }

    @Override
    public PasswordResetToken findById(Long id) {
        return passwordResetTokenRepository.findById(id).orElseThrow(() -> new RuntimeException("PasswordResetToken not found"));
    }

    @Override
    public PasswordResetToken save(PasswordResetToken entity) {
        return passwordResetTokenRepository.save(entity);
    }

    @Override
    public PasswordResetToken update(Long id, PasswordResetToken entity) {
        PasswordResetToken existing = findById(id);
        // TODO: Map fields
        return passwordResetTokenRepository.save(existing);
    }

    @Override
    public void delete(Long id) {
        passwordResetTokenRepository.deleteById(id);
    }
}
