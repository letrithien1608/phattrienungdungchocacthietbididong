package com.letrithien.ex1.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import org.hibernate.annotations.GenericGenerator;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "products")
@Data
public class Product {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    private UUID id;

    private String slug;

    @Column(name = "product_name")
    private String productName;

    private String sku;

    @Column(name = "sale_price")
    private BigDecimal salePrice;

    @Column(name = "compare_price")
    private BigDecimal comparePrice;

    @Column(name = "buying_price")
    private BigDecimal buyingPrice;

    private Integer quantity;

    @Column(name = "short_description")
    private String shortDescription;

    @Column(name = "product_description", columnDefinition = "TEXT")
    private String productDescription;

    @Column(name = "product_type")
    private String productType;

    @Column(columnDefinition = "TEXT")
    private String image;

    private Boolean published;

    @Column(name = "disable_out_of_stock")
    private Boolean disableOutOfStock;

    @Column(columnDefinition = "TEXT")
    private String note;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @Column(name = "created_by")
    private UUID createdBy;

    @Column(name = "updated_by")
    private UUID updatedBy;
}
