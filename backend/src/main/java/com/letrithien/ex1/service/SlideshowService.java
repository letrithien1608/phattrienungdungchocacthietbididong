package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Slideshow;
import java.util.List;
import java.util.UUID;

public interface SlideshowService {
    List<Slideshow> findAll();
    Slideshow findById(UUID id);
    Slideshow save(Slideshow entity);
    Slideshow update(UUID id, Slideshow entity);
    void delete(UUID id);
}
