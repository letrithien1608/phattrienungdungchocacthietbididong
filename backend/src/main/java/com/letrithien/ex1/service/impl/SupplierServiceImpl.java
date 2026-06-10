package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Supplier;
import com.letrithien.ex1.repository.SupplierRepository;
import com.letrithien.ex1.service.SupplierService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SupplierServiceImpl implements SupplierService {

    private final SupplierRepository supplierRepository;

    @Override
    public List<Supplier> findAll() {
        return supplierRepository.findAll();
    }

    @Override
    public Supplier findById(UUID id) {
        return supplierRepository.findById(id).orElseThrow(() -> new RuntimeException("Supplier not found"));
    }

    @Override
    public Supplier save(Supplier entity) {
        return supplierRepository.save(entity);
    }

    @Override
    public Supplier update(UUID id, Supplier entity) {
        Supplier existing = findById(id);
        // TODO: Map fields
        return supplierRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        supplierRepository.deleteById(id);
    }
}
