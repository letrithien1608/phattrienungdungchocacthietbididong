package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductAttributeValue;
import com.letrithien.ex1.repository.ProductAttributeValueRepository;
import com.letrithien.ex1.service.ProductAttributeValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductAttributeValueServiceImpl implements ProductAttributeValueService {

    private final ProductAttributeValueRepository productAttributeValueRepository;

    @Override
    public List<ProductAttributeValue> findAll() {
        return productAttributeValueRepository.findAll();
    }

    @Override
    public ProductAttributeValue findById(UUID id) {
        return productAttributeValueRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductAttributeValue not found"));
    }

    @Override
    public ProductAttributeValue save(ProductAttributeValue entity) {
        return productAttributeValueRepository.save(entity);
    }

    @Override
    public ProductAttributeValue update(UUID id, ProductAttributeValue entity) {
        ProductAttributeValue existing = findById(id);
        // TODO: Map fields
        return productAttributeValueRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productAttributeValueRepository.deleteById(id);
    }
}
