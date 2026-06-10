package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductCoupon;
import com.letrithien.ex1.repository.ProductCouponRepository;
import com.letrithien.ex1.service.ProductCouponService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductCouponServiceImpl implements ProductCouponService {

    private final ProductCouponRepository productCouponRepository;

    @Override
    public List<ProductCoupon> findAll() {
        return productCouponRepository.findAll();
    }

    @Override
    public ProductCoupon findById(UUID id) {
        return productCouponRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductCoupon not found"));
    }

    @Override
    public ProductCoupon save(ProductCoupon entity) {
        return productCouponRepository.save(entity);
    }

    @Override
    public ProductCoupon update(UUID id, ProductCoupon entity) {
        ProductCoupon existing = findById(id);
        // TODO: Map fields
        return productCouponRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productCouponRepository.deleteById(id);
    }
}
