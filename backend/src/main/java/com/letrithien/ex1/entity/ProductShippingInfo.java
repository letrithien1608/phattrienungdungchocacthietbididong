package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "product_shipping_info")
public class ProductShippingInfo {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    private Double weight;
    private String weight_unit;
    private Double volume;
    private String volume_unit;
    private Double dimension_width;
    private Double dimension_height;
    private Double dimension_depth;
    private String dimension_unit;
}
