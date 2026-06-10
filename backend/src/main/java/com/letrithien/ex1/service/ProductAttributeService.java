package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductAttribute;
import java.util.List;
import java.util.UUID;

public interface ProductAttributeService {
    List<ProductAttribute> findAll();
    ProductAttribute findById(UUID id);
    ProductAttribute save(ProductAttribute entity);
    ProductAttribute update(UUID id, ProductAttribute entity);
    void delete(UUID id);
}
