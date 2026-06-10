package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductSupplier;
import com.letrithien.ex1.repository.ProductSupplierRepository;
import com.letrithien.ex1.service.ProductSupplierService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductSupplierServiceImpl implements ProductSupplierService {

    private final ProductSupplierRepository repository;

    @Override
    public List<ProductSupplier> findAll() {
        return repository.findAll();
    }

    @Override
    public ProductSupplier findById(UUID id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public ProductSupplier save(ProductSupplier productSupplier) {
        return repository.save(productSupplier);
    }

    @Override
    public void deleteById(UUID id) {
        repository.deleteById(id);
    }
}
