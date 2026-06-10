package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductTag;
import com.letrithien.ex1.repository.ProductTagRepository;
import com.letrithien.ex1.service.ProductTagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductTagServiceImpl implements ProductTagService {

    private final ProductTagRepository productTagRepository;

    @Override
    public List<ProductTag> findAll() {
        return productTagRepository.findAll();
    }

    @Override
    public ProductTag findById(UUID id) {
        return productTagRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductTag not found"));
    }

    @Override
    public ProductTag save(ProductTag entity) {
        return productTagRepository.save(entity);
    }

    @Override
    public ProductTag update(UUID id, ProductTag entity) {
        ProductTag existing = findById(id);
        // TODO: Map fields
        return productTagRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productTagRepository.deleteById(id);
    }
}
