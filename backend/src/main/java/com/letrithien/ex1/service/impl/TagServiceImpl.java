package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Tag;
import com.letrithien.ex1.repository.TagRepository;
import com.letrithien.ex1.service.TagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class TagServiceImpl implements TagService {

    private final TagRepository tagRepository;

    @Override
    public List<Tag> findAll() {
        return tagRepository.findAll();
    }

    @Override
    public Tag findById(UUID id) {
        return tagRepository.findById(id).orElseThrow(() -> new RuntimeException("Tag not found"));
    }

    @Override
    public Tag save(Tag entity) {
        return tagRepository.save(entity);
    }

    @Override
    public Tag update(UUID id, Tag entity) {
        Tag existing = findById(id);
        // TODO: Map fields
        return tagRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        tagRepository.deleteById(id);
    }
}
