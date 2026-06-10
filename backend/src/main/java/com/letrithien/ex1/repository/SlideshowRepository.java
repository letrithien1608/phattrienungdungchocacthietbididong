package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Slideshow;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface SlideshowRepository extends JpaRepository<Slideshow, UUID> {
}
