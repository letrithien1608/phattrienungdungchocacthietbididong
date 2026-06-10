package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "variants")
public class Variant {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String variant_option;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    @ManyToOne @JoinColumn(name="variant_option_id") private VariantOption variantOption;
}
