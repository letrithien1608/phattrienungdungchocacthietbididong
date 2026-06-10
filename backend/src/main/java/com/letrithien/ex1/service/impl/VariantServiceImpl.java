package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Variant;
import com.letrithien.ex1.repository.VariantRepository;
import com.letrithien.ex1.service.VariantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VariantServiceImpl implements VariantService {

    private final VariantRepository variantRepository;

    @Override
    public List<Variant> findAll() {
        return variantRepository.findAll();
    }

    @Override
    public Variant findById(UUID id) {
        return variantRepository.findById(id).orElseThrow(() -> new RuntimeException("Variant not found"));
    }

    @Override
    public Variant save(Variant entity) {
        return variantRepository.save(entity);
    }

    @Override
    public Variant update(UUID id, Variant entity) {
        Variant existing = findById(id);
        // TODO: Map fields
        return variantRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        variantRepository.deleteById(id);
    }
}
