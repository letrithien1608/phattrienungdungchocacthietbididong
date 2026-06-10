package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ShippingZone;
import java.util.List;
import java.util.UUID;

public interface ShippingZoneService {
    List<ShippingZone> findAll();
    ShippingZone findById(UUID id);
    ShippingZone save(ShippingZone entity);
    ShippingZone update(UUID id, ShippingZone entity);
    void delete(UUID id);
}
