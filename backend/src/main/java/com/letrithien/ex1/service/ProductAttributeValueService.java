package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductAttributeValue;
import java.util.List;
import java.util.UUID;

public interface ProductAttributeValueService {
    List<ProductAttributeValue> findAll();
    ProductAttributeValue findById(UUID id);
    ProductAttributeValue save(ProductAttributeValue entity);
    ProductAttributeValue update(UUID id, ProductAttributeValue entity);
    void delete(UUID id);
}
