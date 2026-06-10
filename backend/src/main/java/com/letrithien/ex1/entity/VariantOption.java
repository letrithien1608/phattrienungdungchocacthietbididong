package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "variant_options")
public class VariantOption {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String title;
    @ManyToOne @JoinColumn(name="image_id") private Gallery image;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    private Double sale_price;
    private Double compare_price;
    private Double buying_price;
    private Integer quantity;
    private String sku;
    private boolean active = true;
}
