package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "Carts")
public class Cart {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="User_id") private User user;
}
