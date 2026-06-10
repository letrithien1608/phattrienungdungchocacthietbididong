package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "order_statuses")
public class OrderStatus {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String status_name;
    private String color;
    private String privacy;
    private Date created_at;
    private Date updated_at;
}
