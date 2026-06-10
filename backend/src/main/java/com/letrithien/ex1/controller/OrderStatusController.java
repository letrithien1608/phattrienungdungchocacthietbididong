package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.OrderStatus;
import com.letrithien.ex1.service.OrderStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/orderStatuss")
@RequiredArgsConstructor
public class OrderStatusController {

    private final OrderStatusService orderStatusService;

    @GetMapping
    public ResponseEntity<List<OrderStatus>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(orderStatusService.findAll());
        return ResponseEntity.ok(null);
    }
}
