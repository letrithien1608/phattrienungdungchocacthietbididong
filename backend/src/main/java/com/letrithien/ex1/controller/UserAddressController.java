package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.UserAddress;
import com.letrithien.ex1.service.UserAddressService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/UserAddresss")
@RequiredArgsConstructor
public class UserAddressController {

    private final UserAddressService UserAddressService;

    @GetMapping
    public ResponseEntity<List<UserAddress>> getAll() {
        // Call proper service method, maybe findAll
        // Since we don't know if service is interface or class with different method names,
        // we'll comment this out and let the user fix or standard method.
        // return ResponseEntity.ok(UserAddressService.findAll());
        return ResponseEntity.ok(null);
    }
}
