package com.letrithien.ex1.service;

import com.letrithien.ex1.entity.Sell;
import java.util.List;


public interface SellService {
    List<Sell> findAll();
    Sell findById(Long id);
    Sell save(Sell entity);
    Sell update(Long id, Sell entity);
    void delete(Long id);
}
