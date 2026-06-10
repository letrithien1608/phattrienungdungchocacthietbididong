package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.ProductShippingInfo;
import java.util.List;
import java.util.UUID;

public interface ProductShippingInfoService {
    List<ProductShippingInfo> findAll();
    ProductShippingInfo findById(UUID id);
    ProductShippingInfo save(ProductShippingInfo entity);
    ProductShippingInfo update(UUID id, ProductShippingInfo entity);
    void delete(UUID id);
}
