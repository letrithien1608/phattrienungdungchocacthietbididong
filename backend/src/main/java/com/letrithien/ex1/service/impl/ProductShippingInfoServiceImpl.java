package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.ProductShippingInfo;
import com.letrithien.ex1.repository.ProductShippingInfoRepository;
import com.letrithien.ex1.service.ProductShippingInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductShippingInfoServiceImpl implements ProductShippingInfoService {

    private final ProductShippingInfoRepository productShippingInfoRepository;

    @Override
    public List<ProductShippingInfo> findAll() {
        return productShippingInfoRepository.findAll();
    }

    @Override
    public ProductShippingInfo findById(UUID id) {
        return productShippingInfoRepository.findById(id).orElseThrow(() -> new RuntimeException("ProductShippingInfo not found"));
    }

    @Override
    public ProductShippingInfo save(ProductShippingInfo entity) {
        return productShippingInfoRepository.save(entity);
    }

    @Override
    public ProductShippingInfo update(UUID id, ProductShippingInfo entity) {
        ProductShippingInfo existing = findById(id);
        // TODO: Map fields
        return productShippingInfoRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        productShippingInfoRepository.deleteById(id);
    }
}
