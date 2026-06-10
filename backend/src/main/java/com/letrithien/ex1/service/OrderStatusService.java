package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.OrderStatus;
import java.util.List;
import java.util.UUID;

public interface OrderStatusService {
    List<OrderStatus> findAll();
    OrderStatus findById(UUID id);
    OrderStatus save(OrderStatus entity);
    OrderStatus update(UUID id, OrderStatus entity);
    void delete(UUID id);
}
