package com.Bookie.service;

import com.Bookie.config.repository.CountryRepository;
import com.Bookie.dto.CountryResponseDto;
import com.Bookie.dto.ProvinceResponseDto;
import com.Bookie.entities.CountryEntity;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class CountryService {

    private final CountryRepository countryRepository;

    public List<CountryResponseDto> getAllCountriesWithProvinces() {
        return countryRepository.findAll().stream()
                .map(this::mapToCountryResponseDto)
                .collect(Collectors.toList());
    }

    private CountryResponseDto mapToCountryResponseDto(CountryEntity country) {
        return new CountryResponseDto(
                country.getId(),
                country.getName(),
                country.getProvinces().stream()
                        .map(province -> new ProvinceResponseDto(province.getId(), province.getName()))
                        .collect(Collectors.toList())
        );
    }
}