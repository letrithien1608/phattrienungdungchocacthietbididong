package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.*;
import com.letrithien.ex1.repository.*;
import com.letrithien.ex1.service.CartService;
import com.letrithien.ex1.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartService cartService;
    private final UserRepository UserRepository;
    private final OrderStatusRepository orderStatusRepository;

    @Override
    @Transactional
    public Order createOrderFromCart(UUID UserId, UUID shippingAddressId, UUID paymentMethodId) {
        User user = UserRepository.findById(UserId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Cart cart = cartService.getUserCart(UserId);
        if (cart == null) {
            throw new RuntimeException("Cart is empty");
        }
        
        List<CartItem> cartItems = cartService.getCartItems(cart.getId());
        if (cartItems == null || cartItems.isEmpty()) {
            throw new RuntimeException("Cart is empty");
        }

        Order order = new Order();
        order.setId(UUID.randomUUID().toString());
        order.setUser(user);
        order.setCreated_at(new Date());
        order = orderRepository.save(order);

        for (CartItem ci : cartItems) {
            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setProduct(ci.getProduct());
            oi.setQuantity(ci.getQuantity());
            if (ci.getProduct() != null && ci.getProduct().getSalePrice() != null) {
                oi.setPrice(ci.getProduct().getSalePrice().doubleValue());
            } else {
                oi.setPrice(0.0);
            }
            orderItemRepository.save(oi);
        }

        cartService.clearCart(UserId);
        return order;
    }

    @Override
    public List<Order> getUserOrders(UUID UserId) {
        return orderRepository.findByUser_Id(UserId);
    }

    @Override
    public List<OrderItem> getOrderItems(String orderId) {
        return orderItemRepository.findByOrder_Id(orderId);
    }

    @Override
    public Order getOrderDetails(String orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }
}
