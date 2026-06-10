package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "suppliers")
public class Supplier {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    private String supplier_name;
    private String company;
    private String phone_number;
    private String address_line1;
    private String address_line2;
    @ManyToOne @JoinColumn(name="country_id") private Country country;
    private String city;
    private String note;
    private Date created_at;
    private Date updated_at;
}
