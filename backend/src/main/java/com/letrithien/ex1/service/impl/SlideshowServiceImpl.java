package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Slideshow;
import com.letrithien.ex1.repository.SlideshowRepository;
import com.letrithien.ex1.service.SlideshowService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class SlideshowServiceImpl implements SlideshowService {

    private final SlideshowRepository slideshowRepository;

    @Override
    public List<Slideshow> findAll() {
        return slideshowRepository.findAll();
    }

    @Override
    public Slideshow findById(UUID id) {
        return slideshowRepository.findById(id).orElseThrow(() -> new RuntimeException("Slideshow not found"));
    }

    @Override
    public Slideshow save(Slideshow entity) {
        return slideshowRepository.save(entity);
    }

    @Override
    public Slideshow update(UUID id, Slideshow entity) {
        Slideshow existing = findById(id);
        // TODO: Map fields
        return slideshowRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        slideshowRepository.deleteById(id);
    }
}
