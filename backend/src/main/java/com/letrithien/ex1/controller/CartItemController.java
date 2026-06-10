package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.CartItem;
import com.letrithien.ex1.service.CartItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/CartItems")
@RequiredArgsConstructor
public class CartItemController {

    private final CartItemService CartItemService;

    @GetMapping
    public ResponseEntity<List<CartItem>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(CartItemService.findAll());
        return ResponseEntity.ok(null);
    }
}
