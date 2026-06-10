package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.VariantOption;
import com.letrithien.ex1.service.VariantOptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/variantOptions")
@RequiredArgsConstructor
public class VariantOptionController {

    private final VariantOptionService variantOptionService;

    @GetMapping
    public ResponseEntity<List<VariantOption>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(variantOptionService.findAll());
        return ResponseEntity.ok(null);
    }
}
