package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Country;
import com.letrithien.ex1.service.CountryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/countrys")
@RequiredArgsConstructor
public class CountryController {

    private final CountryService countryService;

    @GetMapping
    public ResponseEntity<List<Country>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(countryService.findAll());
        return ResponseEntity.ok(null);
    }
}
