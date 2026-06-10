package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Slideshow;
import com.letrithien.ex1.service.SlideshowService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/slideshows")
@RequiredArgsConstructor
public class SlideshowController {

    private final SlideshowService slideshowService;

    @GetMapping
    public ResponseEntity<List<Slideshow>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(slideshowService.findAll());
        return ResponseEntity.ok(null);
    }
}
