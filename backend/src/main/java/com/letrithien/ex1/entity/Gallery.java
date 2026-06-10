package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "gallery")
public class Gallery {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    private String image;
    private String placeholder;
    private boolean is_thumbnail = false;
    private Date created_at;
    private Date updated_at;
}
