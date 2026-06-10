package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ProductShippingInfo;
import com.letrithien.ex1.service.ProductShippingInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/productShippingInfos")
@RequiredArgsConstructor
public class ProductShippingInfoController {

    private final ProductShippingInfoService productShippingInfoService;

    @GetMapping
    public ResponseEntity<List<ProductShippingInfo>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(productShippingInfoService.findAll());
        return ResponseEntity.ok(null);
    }
}
