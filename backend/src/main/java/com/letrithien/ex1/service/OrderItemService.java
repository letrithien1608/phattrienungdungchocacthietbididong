package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.OrderItem;
import java.util.List;
import java.util.UUID;

public interface OrderItemService {
    List<OrderItem> findAll();
    OrderItem findById(UUID id);
    OrderItem save(OrderItem entity);
    OrderItem update(UUID id, OrderItem entity);
    void delete(UUID id);
}
