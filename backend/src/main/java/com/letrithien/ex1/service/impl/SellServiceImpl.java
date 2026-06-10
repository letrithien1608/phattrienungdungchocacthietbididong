package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Sell;
import com.letrithien.ex1.repository.SellRepository;
import com.letrithien.ex1.service.SellService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class SellServiceImpl implements SellService {

    private final SellRepository sellRepository;

    @Override
    public List<Sell> findAll() {
        return sellRepository.findAll();
    }

    @Override
    public Sell findById(Long id) {
        return sellRepository.findById(id).orElseThrow(() -> new RuntimeException("Sell not found"));
    }

    @Override
    public Sell save(Sell entity) {
        return sellRepository.save(entity);
    }

    @Override
    public Sell update(Long id, Sell entity) {
        Sell existing = findById(id);
        // TODO: Map fields
        return sellRepository.save(existing);
    }

    @Override
    public void delete(Long id) {
        sellRepository.deleteById(id);
    }
}
