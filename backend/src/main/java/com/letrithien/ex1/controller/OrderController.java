package com.letrithien.ex1.controller;

import com.letrithien.ex1.entity.Order;
import com.letrithien.ex1.entity.User;
import com.letrithien.ex1.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @GetMapping
    public ResponseEntity<?> getOrders(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        java.util.List<Order> orders = orderService.getUserOrders(user.getId());
        java.util.List<Map<String, Object>> response = orders.stream().map(order -> {
            Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", order.getId());
            map.put("date", order.getCreated_at());
            map.put("status", order.getOrderStatus() != null ? order.getOrderStatus().getStatus_name() : "Processing");
            
            java.util.List<com.letrithien.ex1.entity.OrderItem> items = orderService.getOrderItems(order.getId());
            double total = 0;
            if (items != null) {
                for (com.letrithien.ex1.entity.OrderItem item : items) {
                    if (item.getPrice() != null && item.getQuantity() != null) {
                        total += item.getPrice() * item.getQuantity();
                    }
                }
            }
            map.put("totalAmount", total);
            map.put("items", items != null ? items : new java.util.ArrayList<>());
            return map;
        }).collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/checkout")
    public ResponseEntity<?> checkout(
            @AuthenticationPrincipal User user,
            @RequestBody(required = false) Map<String, String> request) {
        if (user == null) {
            return ResponseEntity.status(401).body("Unauthorized");
        }
        // In reality, this would take shippingAddressId and paymentMethodId
        try {
            Order order = orderService.createOrderFromCart(user.getId(), null, null);
            return ResponseEntity.ok(order);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/{orderId}")
    public ResponseEntity<?> getOrderDetails(@PathVariable String orderId) {
        return ResponseEntity.ok(orderService.getOrderDetails(orderId));
    }
}
