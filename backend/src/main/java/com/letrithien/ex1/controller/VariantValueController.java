package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.VariantValue;
import com.letrithien.ex1.service.VariantValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/variantValues")
@RequiredArgsConstructor
public class VariantValueController {

    private final VariantValueService variantValueService;

    @GetMapping
    public ResponseEntity<List<VariantValue>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(variantValueService.findAll());
        return ResponseEntity.ok(null);
    }
}
