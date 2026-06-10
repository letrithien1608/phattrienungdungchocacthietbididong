package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "coupons")
public class Coupon {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @Column(unique = true, nullable = false) private String code;
    private Double discount_value;
    private String discount_type;
    private Double times_used;
    private Double max_usage;
    private Double order_amount_limit;
    private Date coupon_start_date;
    private Date coupon_end_date;
}
