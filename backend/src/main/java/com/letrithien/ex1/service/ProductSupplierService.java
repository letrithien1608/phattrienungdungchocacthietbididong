package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductSupplier;
import java.util.List;
import java.util.UUID;

public interface ProductSupplierService {
    List<ProductSupplier> findAll();
    ProductSupplier findById(UUID id);
    ProductSupplier save(ProductSupplier productSupplier);
    void deleteById(UUID id);
}
