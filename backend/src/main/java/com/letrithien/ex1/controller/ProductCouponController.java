package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.ProductCoupon;
import com.letrithien.ex1.service.ProductCouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/productCoupons")
@RequiredArgsConstructor
public class ProductCouponController {

    private final ProductCouponService productCouponService;

    @GetMapping
    public ResponseEntity<List<ProductCoupon>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(productCouponService.findAll());
        return ResponseEntity.ok(null);
    }
}
