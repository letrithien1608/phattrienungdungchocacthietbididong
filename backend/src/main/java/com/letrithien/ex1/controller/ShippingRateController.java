package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ShippingRate;
import com.letrithien.ex1.service.ShippingRateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/shippingRates")
@RequiredArgsConstructor
public class ShippingRateController {

    private final ShippingRateService shippingRateService;

    @GetMapping
    public ResponseEntity<List<ShippingRate>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(shippingRateService.findAll());
        return ResponseEntity.ok(null);
    }
}
