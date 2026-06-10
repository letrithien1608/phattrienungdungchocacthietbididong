package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.AttributeValue;
import java.util.List;
import java.util.UUID;

public interface AttributeValueService {
    List<AttributeValue> findAll();
    AttributeValue findById(UUID id);
    AttributeValue save(AttributeValue entity);
    AttributeValue update(UUID id, AttributeValue entity);
    void delete(UUID id);
}
