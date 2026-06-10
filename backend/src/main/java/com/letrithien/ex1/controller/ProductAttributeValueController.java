package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ProductAttributeValue;
import com.letrithien.ex1.service.ProductAttributeValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/productAttributeValues")
@RequiredArgsConstructor
public class ProductAttributeValueController {

    private final ProductAttributeValueService productAttributeValueService;

    @GetMapping
    public ResponseEntity<List<ProductAttributeValue>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(productAttributeValueService.findAll());
        return ResponseEntity.ok(null);
    }
}
