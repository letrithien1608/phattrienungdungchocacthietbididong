package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "attribute_values")
public class AttributeValue {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="attribute_id") private Attribute attribute;
    private String attribute_value;
    private String color;
}
