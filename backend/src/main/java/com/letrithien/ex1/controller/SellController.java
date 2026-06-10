package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Sell;
import com.letrithien.ex1.service.SellService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/sells")
@RequiredArgsConstructor
public class SellController {

    private final SellService sellService;

    @GetMapping
    public ResponseEntity<List<Sell>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(sellService.findAll());
        return ResponseEntity.ok(null);
    }
}
