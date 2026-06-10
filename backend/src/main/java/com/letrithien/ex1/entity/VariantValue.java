package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "variant_values")
public class VariantValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="variant_id") private Variant variant;
    @ManyToOne @JoinColumn(name="product_attribute_value_id") private ProductAttributeValue productAttributeValue;
}
