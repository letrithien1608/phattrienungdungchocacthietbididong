package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Variant;
import java.util.List;
import java.util.UUID;

public interface VariantService {
    List<Variant> findAll();
    Variant findById(UUID id);
    Variant save(Variant entity);
    Variant update(UUID id, Variant entity);
    void delete(UUID id);
}
