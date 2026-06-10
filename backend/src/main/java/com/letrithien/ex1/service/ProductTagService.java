package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductTag;
import java.util.List;
import java.util.UUID;

public interface ProductTagService {
    List<ProductTag> findAll();
    ProductTag findById(UUID id);
    ProductTag save(ProductTag entity);
    ProductTag update(UUID id, ProductTag entity);
    void delete(UUID id);
}
