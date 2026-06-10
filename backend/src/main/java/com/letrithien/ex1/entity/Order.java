package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "orders")
public class Order {
    @Id private String id; // VARCHAR(50)
    @ManyToOne @JoinColumn(name="coupon_id") private Coupon coupon;
    @ManyToOne @JoinColumn(name="User_id") @com.fasterxml.jackson.annotation.JsonIgnore private User user;
    @ManyToOne @JoinColumn(name="order_status_id") private OrderStatus orderStatus;
    private Date order_approved_at;
    private Date order_delivered_carrier_date;
    private Date order_delivered_User_date;
    private Date created_at;
}
