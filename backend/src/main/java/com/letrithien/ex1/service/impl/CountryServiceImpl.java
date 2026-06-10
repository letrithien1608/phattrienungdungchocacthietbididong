package com.letrithien.ex1.service.impl;

import com.letrithien.ex1.entity.Country;
import com.letrithien.ex1.repository.CountryRepository;
import com.letrithien.ex1.service.CountryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class CountryServiceImpl implements CountryService {

    private final CountryRepository countryRepository;

    @Override
    public List<Country> findAll() {
        return countryRepository.findAll();
    }

    @Override
    public Country findById(Integer id) {
        return countryRepository.findById(id).orElseThrow(() -> new RuntimeException("Country not found"));
    }

    @Override
    public Country save(Country entity) {
        return countryRepository.save(entity);
    }

    @Override
    public Country update(Integer id, Country entity) {
        Country existing = findById(id);
        // TODO: Map fields
        return countryRepository.save(existing);
    }

    @Override
    public void delete(Integer id) {
        countryRepository.deleteById(id);
    }
}
