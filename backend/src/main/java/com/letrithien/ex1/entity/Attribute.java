package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "attributes")
public class Attribute {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String attribute_name;
    private Date created_at;
    private Date updated_at;
}
