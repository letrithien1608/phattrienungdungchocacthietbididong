package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.VariantValue;
import com.letrithien.ex1.repository.VariantValueRepository;
import com.letrithien.ex1.service.VariantValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VariantValueServiceImpl implements VariantValueService {

    private final VariantValueRepository variantValueRepository;

    @Override
    public List<VariantValue> findAll() {
        return variantValueRepository.findAll();
    }

    @Override
    public VariantValue findById(UUID id) {
        return variantValueRepository.findById(id).orElseThrow(() -> new RuntimeException("VariantValue not found"));
    }

    @Override
    public VariantValue save(VariantValue entity) {
        return variantValueRepository.save(entity);
    }

    @Override
    public VariantValue update(UUID id, VariantValue entity) {
        VariantValue existing = findById(id);
        // TODO: Map fields
        return variantValueRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        variantValueRepository.deleteById(id);
    }
}
