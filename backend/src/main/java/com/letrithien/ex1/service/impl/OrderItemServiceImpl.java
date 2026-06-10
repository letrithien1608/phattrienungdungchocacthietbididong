package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.OrderItem;
import com.letrithien.ex1.repository.OrderItemRepository;
import com.letrithien.ex1.service.OrderItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderItemServiceImpl implements OrderItemService {

    private final OrderItemRepository orderItemRepository;

    @Override
    public List<OrderItem> findAll() {
        return orderItemRepository.findAll();
    }

    @Override
    public OrderItem findById(UUID id) {
        return orderItemRepository.findById(id).orElseThrow(() -> new RuntimeException("OrderItem not found"));
    }

    @Override
    public OrderItem save(OrderItem entity) {
        return orderItemRepository.save(entity);
    }

    @Override
    public OrderItem update(UUID id, OrderItem entity) {
        OrderItem existing = findById(id);
        // TODO: Map fields
        return orderItemRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        orderItemRepository.deleteById(id);
    }
}
