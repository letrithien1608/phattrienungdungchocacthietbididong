package com.letrithien.ex1.entity;
import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.util.Date;
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Entity @Table(name = "notifications")
public class Notification {
    @Id @GeneratedValue(strategy = GenerationType.UUID) private UUID id;
    @ManyToOne @JoinColumn(name="account_id") private User account;
    private String title;
    private String content;
    private Boolean seen;
    private Date created_at;
    private Date receive_time;
    private Date notification_expiry_date;
}
