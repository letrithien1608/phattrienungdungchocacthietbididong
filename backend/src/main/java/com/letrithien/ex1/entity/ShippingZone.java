package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "shipping_zones")
public class ShippingZone {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String name;
    private String display_name;
    private boolean active = false;
    private boolean free_shipping = false;
    private String rate_type;
    private Date created_at;
    private Date updated_at;
}
