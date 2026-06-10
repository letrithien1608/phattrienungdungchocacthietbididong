package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Gallery;
import com.letrithien.ex1.repository.GalleryRepository;
import com.letrithien.ex1.service.GalleryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class GalleryServiceImpl implements GalleryService {

    private final GalleryRepository galleryRepository;

    @Override
    public List<Gallery> findAll() {
        return galleryRepository.findAll();
    }

    @Override
    public Gallery findById(UUID id) {
        return galleryRepository.findById(id).orElseThrow(() -> new RuntimeException("Gallery not found"));
    }

    @Override
    public Gallery save(Gallery entity) {
        return galleryRepository.save(entity);
    }

    @Override
    public Gallery update(UUID id, Gallery entity) {
        Gallery existing = findById(id);
        // TODO: Map fields
        return galleryRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        galleryRepository.deleteById(id);
    }
}
