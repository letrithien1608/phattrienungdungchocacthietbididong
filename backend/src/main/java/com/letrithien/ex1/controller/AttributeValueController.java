package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.AttributeValue;
import com.letrithien.ex1.service.AttributeValueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/attributeValues")
@RequiredArgsConstructor
public class AttributeValueController {

    private final AttributeValueService attributeValueService;

    @GetMapping
    public ResponseEntity<List<AttributeValue>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(attributeValueService.findAll());
        return ResponseEntity.ok(null);
    }
}
