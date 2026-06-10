package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Coupon;
import com.letrithien.ex1.repository.CouponRepository;
import com.letrithien.ex1.service.CouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CouponServiceImpl implements CouponService {

    private final CouponRepository couponRepository;

    @Override
    public List<Coupon> findAll() {
        return couponRepository.findAll();
    }

    @Override
    public Coupon findById(UUID id) {
        return couponRepository.findById(id).orElseThrow(() -> new RuntimeException("Coupon not found"));
    }

    @Override
    public Coupon save(Coupon entity) {
        return couponRepository.save(entity);
    }

    @Override
    public Coupon update(UUID id, Coupon entity) {
        Coupon existing = findById(id);
        // TODO: Map fields
        return couponRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        couponRepository.deleteById(id);
    }
}
