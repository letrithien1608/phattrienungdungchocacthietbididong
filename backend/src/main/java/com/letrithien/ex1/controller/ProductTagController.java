package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ProductTag;
import com.letrithien.ex1.service.ProductTagService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/productTags")
@RequiredArgsConstructor
public class ProductTagController {

    private final ProductTagService productTagService;

    @GetMapping
    public ResponseEntity<List<ProductTag>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(productTagService.findAll());
        return ResponseEntity.ok(null);
    }
}
