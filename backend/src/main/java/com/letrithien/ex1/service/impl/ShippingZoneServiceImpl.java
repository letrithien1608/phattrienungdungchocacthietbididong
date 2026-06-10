package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ShippingZone;
import com.letrithien.ex1.repository.ShippingZoneRepository;
import com.letrithien.ex1.service.ShippingZoneService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ShippingZoneServiceImpl implements ShippingZoneService {

    private final ShippingZoneRepository shippingZoneRepository;

    @Override
    public List<ShippingZone> findAll() {
        return shippingZoneRepository.findAll();
    }

    @Override
    public ShippingZone findById(UUID id) {
        return shippingZoneRepository.findById(id).orElseThrow(() -> new RuntimeException("ShippingZone not found"));
    }

    @Override
    public ShippingZone save(ShippingZone entity) {
        return shippingZoneRepository.save(entity);
    }

    @Override
    public ShippingZone update(UUID id, ShippingZone entity) {
        ShippingZone existing = findById(id);
        // TODO: Map fields
        return shippingZoneRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        shippingZoneRepository.deleteById(id);
    }
}
