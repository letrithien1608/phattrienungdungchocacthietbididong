package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Attribute;
import java.util.List;
import java.util.UUID;

public interface AttributeService {
    List<Attribute> findAll();
    Attribute findById(UUID id);
    Attribute save(Attribute entity);
    Attribute update(UUID id, Attribute entity);
    void delete(UUID id);
}
