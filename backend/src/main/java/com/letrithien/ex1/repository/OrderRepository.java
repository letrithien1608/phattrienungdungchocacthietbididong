package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface OrderRepository extends JpaRepository<Order, String> {
    java.util.List<Order> findByUser_Id(java.util.UUID userId);
}
