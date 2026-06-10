package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductCategory;
import com.letrithien.ex1.repository.ProductCategoryRepository;
import com.letrithien.ex1.service.ProductCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductCategoryServiceImpl implements ProductCategoryService {

    private final ProductCategoryRepository productCategoryRepository;

    @Override
    public List<ProductCategory> findAll() {
        return productCategoryRepository.findAll();
    }

    @Override
    public ProductCategory findById(UUID id) {
        return productCategoryRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductCategory not found"));
    }

    @Override
    public ProductCategory save(ProductCategory entity) {
        return productCategoryRepository.save(entity);
    }

    @Override
    public ProductCategory update(UUID id, ProductCategory entity) {
        ProductCategory existing = findById(id);
        // TODO: Map fields
        return productCategoryRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productCategoryRepository.deleteById(id);
    }
}
