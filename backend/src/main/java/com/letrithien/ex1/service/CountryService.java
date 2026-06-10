package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Country;
import java.util.List;


public interface CountryService {
    List<Country> findAll();
    Country findById(Integer id);
    Country save(Country entity);
    Country update(Integer id, Country entity);
    void delete(Integer id);
}
