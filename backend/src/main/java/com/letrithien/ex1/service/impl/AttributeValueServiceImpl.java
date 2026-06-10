package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.AttributeValue;
import com.letrithien.ex1.repository.AttributeValueRepository;
import com.letrithien.ex1.service.AttributeValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AttributeValueServiceImpl implements AttributeValueService {

    private final AttributeValueRepository attributeValueRepository;

    @Override
    public List<AttributeValue> findAll() {
        return attributeValueRepository.findAll();
    }

    @Override
    public AttributeValue findById(UUID id) {
        return attributeValueRepository.findById(id).orElseThrow(() -> new RuntimeException("AttributeValue not found"));
    }

    @Override
    public AttributeValue save(AttributeValue entity) {
        return attributeValueRepository.save(entity);
    }

    @Override
    public AttributeValue update(UUID id, AttributeValue entity) {
        AttributeValue existing = findById(id);
        // TODO: Map fields
        return attributeValueRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        attributeValueRepository.deleteById(id);
    }
}
