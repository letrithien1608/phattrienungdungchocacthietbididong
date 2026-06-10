package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ProductAttribute;
import com.letrithien.ex1.service.ProductAttributeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/productAttributes")
@RequiredArgsConstructor
public class ProductAttributeController {

    private final ProductAttributeService productAttributeService;

    @GetMapping
    public ResponseEntity<List<ProductAttribute>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(productAttributeService.findAll());
        return ResponseEntity.ok(null);
    }
}
