package com.letrithien.ex1.repository;

import com.letrithien.ex1.entity.Country;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;



@Repository
public interface CountryRepository extends JpaRepository<Country, Integer> {
}
