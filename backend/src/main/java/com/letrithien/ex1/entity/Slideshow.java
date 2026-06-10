package com.letrithien.ex1.entity;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.GenericGenerator;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "slideshows")
@Data
public class Slideshow {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    private UUID id;

    private String title;

    @Column(name = "destination_url", columnDefinition = "TEXT")
    private String destinationUrl;

    @Column(columnDefinition = "TEXT")
    private String image;

    @Column(columnDefinition = "TEXT")
    private String placeholder;

    private String description;

    @Column(name = "btn_label")
    private String btnLabel;

    @Column(name = "display_order")
    private Integer displayOrder;

    private Boolean published;

    private Integer clicks;

    @Column(columnDefinition = "jsonb")
    private String styles;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Column(name = "created_by")
    private UUID createdBy;

    @Column(name = "updated_by")
    private UUID updatedBy;
}
