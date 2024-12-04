package com.Bookie.Controllers;

import com.Bookie.dto.CountryResponseDto;
import com.Bookie.entities.CountryEntity;
import com.Bookie.service.CountryService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/countries")
@CrossOrigin("*")
@AllArgsConstructor
public class CountryController {

    private final CountryService countryService;

    @GetMapping
    public ResponseEntity<List<CountryResponseDto>> getAllCountriesWithProvinces() {
        List<CountryResponseDto> countries = countryService.getAllCountriesWithProvinces();
        return ResponseEntity.ok(countries);
    }
}
