package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Gallery;
import java.util.List;
import java.util.UUID;

public interface GalleryService {
    List<Gallery> findAll();
    Gallery findById(UUID id);
    Gallery save(Gallery entity);
    Gallery update(UUID id, Gallery entity);
    void delete(UUID id);
}
