package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "product_attribute_values")
public class ProductAttributeValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_attribute_id") private ProductAttribute productAttribute;
    @ManyToOne @JoinColumn(name="attribute_value_id") private AttributeValue attributeValue;
}
