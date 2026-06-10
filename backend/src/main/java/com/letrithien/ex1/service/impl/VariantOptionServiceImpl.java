package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.VariantOption;
import com.letrithien.ex1.repository.VariantOptionRepository;
import com.letrithien.ex1.service.VariantOptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VariantOptionServiceImpl implements VariantOptionService {

    private final VariantOptionRepository variantOptionRepository;

    @Override
    public List<VariantOption> findAll() {
        return variantOptionRepository.findAll();
    }

    @Override
    public VariantOption findById(UUID id) {
        return variantOptionRepository.findById(id).orElseThrow(() -> new RuntimeException("VariantOption not found"));
    }

    @Override
    public VariantOption save(VariantOption entity) {
        return variantOptionRepository.save(entity);
    }

    @Override
    public VariantOption update(UUID id, VariantOption entity) {
        VariantOption existing = findById(id);
        // TODO: Map fields
        return variantOptionRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        variantOptionRepository.deleteById(id);
    }
}
