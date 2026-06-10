package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.VariantOption;
import java.util.List;
import java.util.UUID;

public interface VariantOptionService {
    List<VariantOption> findAll();
    VariantOption findById(UUID id);
    VariantOption save(VariantOption entity);
    VariantOption update(UUID id, VariantOption entity);
    void delete(UUID id);
}
