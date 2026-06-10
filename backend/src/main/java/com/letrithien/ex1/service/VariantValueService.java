package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.VariantValue;
import java.util.List;
import java.util.UUID;

public interface VariantValueService {
    List<VariantValue> findAll();
    VariantValue findById(UUID id);
    VariantValue save(VariantValue entity);
    VariantValue update(UUID id, VariantValue entity);
    void delete(UUID id);
}
