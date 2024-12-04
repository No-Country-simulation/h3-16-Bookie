package com.Bookie.dto;

import java.util.List;

public record CountryResponseDto(
        Long id,
        String name,
        List<ProvinceResponseDto> provinces
) {
}
