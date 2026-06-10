package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Coupon;
import java.util.List;
import java.util.UUID;

public interface CouponService {
    List<Coupon> findAll();
    Coupon findById(UUID id);
    Coupon save(Coupon entity);
    Coupon update(UUID id, Coupon entity);
    void delete(UUID id);
}
