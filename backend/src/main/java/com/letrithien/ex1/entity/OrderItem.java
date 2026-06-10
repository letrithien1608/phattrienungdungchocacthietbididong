package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "order_items")
public class OrderItem {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    @ManyToOne @JoinColumn(name="order_id") @com.fasterxml.jackson.annotation.JsonIgnore private Order order;
    private Double price;
    private Integer quantity;
}
