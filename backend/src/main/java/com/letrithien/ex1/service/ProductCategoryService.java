package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductCategory;
import java.util.List;
import java.util.UUID;

public interface ProductCategoryService {
    List<ProductCategory> findAll();
    ProductCategory findById(UUID id);
    ProductCategory save(ProductCategory entity);
    ProductCategory update(UUID id, ProductCategory entity);
    void delete(UUID id);
}
