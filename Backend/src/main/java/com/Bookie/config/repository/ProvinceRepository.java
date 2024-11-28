package com.Bookie.config.repository;

import com.Bookie.entities.ProvinceEntity;
import jakarta.validation.constraints.NotBlank;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProvinceRepository extends JpaRepository<ProvinceEntity,Long> {
    ProvinceEntity findByName(@NotBlank String probince);
}
