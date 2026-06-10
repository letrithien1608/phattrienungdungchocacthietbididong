package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Attribute;
import com.letrithien.ex1.repository.AttributeRepository;
import com.letrithien.ex1.service.AttributeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AttributeServiceImpl implements AttributeService {

    private final AttributeRepository attributeRepository;

    @Override
    public List<Attribute> findAll() {
        return attributeRepository.findAll();
    }

    @Override
    public Attribute findById(UUID id) {
        return attributeRepository.findById(id).orElseThrow(() -> new RuntimeException("Attribute not found"));
    }

    @Override
    public Attribute save(Attribute entity) {
        return attributeRepository.save(entity);
    }

    @Override
    public Attribute update(UUID id, Attribute entity) {
        Attribute existing = findById(id);
        // TODO: Map fields
        return attributeRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        attributeRepository.deleteById(id);
    }
}
