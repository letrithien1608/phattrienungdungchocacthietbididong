package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "countries")
public class Country {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Integer id;
    private String iso;
    private String name;
    private String upper_name;
    private String iso3;
    private Integer num_code;
    private Integer phone_code;
}
