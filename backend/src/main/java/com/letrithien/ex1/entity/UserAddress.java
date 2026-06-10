package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "User_addresses")
public class UserAddress {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name="User_id") private User user;
    private String address_line1;
    private String address_line2;
    private String phone_number;
    private String dial_code;
    private String country;
    private String postal_code;
    private String city;
}
