package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Product;
import com.letrithien.ex1.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        return ResponseEntity.ok(productService.getAllProducts());
    }

    @GetMapping("/new")
    public ResponseEntity<List<Product>> getNewProducts() {
        return ResponseEntity.ok(productService.getNewProducts());
    }

    @GetMapping("/sale")
    public ResponseEntity<List<Product>> getSaleProducts() {
        return ResponseEntity.ok(productService.getSaleProducts());
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        return ResponseEntity.ok(productService.createProduct(product));
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/clear")
    public ResponseEntity<String> clearAllProducts() {
        productService.deleteAllProducts();
        return ResponseEntity.ok("Deleted all products successfully!");
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/{id}")
    public ResponseEntity<String> deleteProduct(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id) {
        productService.deleteProduct(id);
        return ResponseEntity.ok("Deleted product successfully!");
    }

    @org.springframework.web.bind.annotation.PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id, @RequestBody Product product) {
        return ResponseEntity.ok(productService.updateProduct(id, product));
    }

    // Endpoint nhanh để đổi tag (Sale/New)
    @org.springframework.web.bind.annotation.PutMapping("/{id}/tag/{tag}")
    public ResponseEntity<Product> updateProductTag(@org.springframework.web.bind.annotation.PathVariable java.util.UUID id, @org.springframework.web.bind.annotation.PathVariable String tag) {
        Product updatedProduct = new Product();
        updatedProduct.setShortDescription(tag);
        return ResponseEntity.ok(productService.updateProduct(id, updatedProduct));
    }
}
