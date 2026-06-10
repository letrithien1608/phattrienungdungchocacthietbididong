package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "product_attributes")
public class ProductAttribute {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    @ManyToOne @JoinColumn(name="attribute_id") private Attribute attribute;
}
