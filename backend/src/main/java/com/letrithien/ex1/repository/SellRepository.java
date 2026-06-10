package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Sell;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface SellRepository extends JpaRepository<Sell, Long> {
}
