package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Tag;
import java.util.List;
import java.util.UUID;

public interface TagService {
    List<Tag> findAll();
    Tag findById(UUID id);
    Tag save(Tag entity);
    Tag update(UUID id, Tag entity);
    void delete(UUID id);
}
