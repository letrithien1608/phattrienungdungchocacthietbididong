package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductCoupon;
import java.util.List;
import java.util.UUID;

public interface ProductCouponService {
    List<ProductCoupon> findAll();
    ProductCoupon findById(UUID id);
    ProductCoupon save(ProductCoupon entity);
    ProductCoupon update(UUID id, ProductCoupon entity);
    void delete(UUID id);
}
