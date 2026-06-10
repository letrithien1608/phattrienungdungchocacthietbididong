package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Order;
import java.util.List;
import java.util.UUID;

public interface OrderService {
    Order createOrderFromCart(UUID UserId, UUID shippingAddressId, UUID paymentMethodId);
    List<Order> getUserOrders(UUID UserId);
    List<com.letrithien.ex1.entity.OrderItem> getOrderItems(String orderId);
    Order getOrderDetails(String orderId);
}
