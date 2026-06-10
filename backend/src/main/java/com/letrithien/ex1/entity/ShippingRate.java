package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "shipping_rates")
public class ShippingRate {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="shipping_zone_id") private ShippingZone shippingZone;
    private String weight_unit;
    private Double min_value;
    private Double max_value;
    private boolean no_max = true;
    private Double price;
}
