package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.OrderStatus;
import com.letrithien.ex1.repository.OrderStatusRepository;
import com.letrithien.ex1.service.OrderStatusService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderStatusServiceImpl implements OrderStatusService {

    private final OrderStatusRepository orderStatusRepository;

    @Override
    public List<OrderStatus> findAll() {
        return orderStatusRepository.findAll();
    }

    @Override
    public OrderStatus findById(UUID id) {
        return orderStatusRepository.findById(id).orElseThrow(() -> new RuntimeException("OrderStatus not found"));
    }

    @Override
    public OrderStatus save(OrderStatus entity) {
        return orderStatusRepository.save(entity);
    }

    @Override
    public OrderStatus update(UUID id, OrderStatus entity) {
        OrderStatus existing = findById(id);
        // TODO: Map fields
        return orderStatusRepository.save(existing);
    }

    @Override
    public void delete(UUID id) {
        orderStatusRepository.deleteById(id);
    }
}
