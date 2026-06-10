package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {
    List<Product> findByPublishedTrueOrderByCreatedAtAsc();
    List<Product> findByPublishedTrueAndShortDescriptionOrderByCreatedAtAsc(String shortDescription);
}
