package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductAttribute;
import com.letrithien.ex1.repository.ProductAttributeRepository;
import com.letrithien.ex1.service.ProductAttributeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductAttributeServiceImpl implements ProductAttributeService {

    private final ProductAttributeRepository productAttributeRepository;

    @Override
    public List<ProductAttribute> findAll() {
        return productAttributeRepository.findAll();
    }

    @Override
    public ProductAttribute findById(UUID id) {
        return productAttributeRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductAttribute not found"));
    }

    @Override
    public ProductAttribute save(ProductAttribute entity) {
        return productAttributeRepository.save(entity);
    }

    @Override
    public ProductAttribute update(UUID id, ProductAttribute entity) {
        ProductAttribute existing = findById(id);
        // TODO: Map fields
        return productAttributeRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productAttributeRepository.deleteById(id);
    }
}
