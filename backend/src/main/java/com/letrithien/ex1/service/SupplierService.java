package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Supplier;
import java.util.List;
import java.util.UUID;

public interface SupplierService {
    List<Supplier> findAll();
    Supplier findById(UUID id);
    Supplier save(Supplier entity);
    Supplier update(UUID id, Supplier entity);
    void delete(UUID id);
}
