package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "Cart_items")
public class CartItem {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="Cart_id") @com.fasterxml.jackson.annotation.JsonIgnore private Cart cart;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    private Integer quantity = 1;
}
