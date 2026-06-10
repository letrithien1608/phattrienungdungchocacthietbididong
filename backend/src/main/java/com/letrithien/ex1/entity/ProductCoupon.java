package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "product_coupons")
public class ProductCoupon {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="product_id") private Product product;
    @ManyToOne @JoinColumn(name="coupon_id") private Coupon coupon;
}
