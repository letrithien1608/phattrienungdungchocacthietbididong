package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.VariantValue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface VariantValueRepository extends JpaRepository<VariantValue, UUID> {
}
