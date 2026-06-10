package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ShippingRate;
import com.letrithien.ex1.repository.ShippingRateRepository;
import com.letrithien.ex1.service.ShippingRateService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ShippingRateServiceImpl implements ShippingRateService {

    private final ShippingRateRepository shippingRateRepository;

    @Override
    public List<ShippingRate> findAll() {
        return shippingRateRepository.findAll();
    }

    @Override
    public ShippingRate findById(UUID id) {
        return shippingRateRepository.findById(id).orElseThrow(() -> new RuntimeException("ShippingRate not found"));
    }

    @Override
    public ShippingRate save(ShippingRate entity) {
        return shippingRateRepository.save(entity);
    }

    @Override
    public ShippingRate update(UUID id, ShippingRate entity) {
        ShippingRate existing = findById(id);
        // TODO: Map fields
        return shippingRateRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        shippingRateRepository.deleteById(id);
    }
}
