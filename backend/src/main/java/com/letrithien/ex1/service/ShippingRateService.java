package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ShippingRate;
import java.util.List;
import java.util.UUID;

public interface ShippingRateService {
    List<ShippingRate> findAll();
    ShippingRate findById(UUID id);
    ShippingRate save(ShippingRate entity);
    ShippingRate update(UUID id, ShippingRate entity);
    void delete(UUID id);
}
