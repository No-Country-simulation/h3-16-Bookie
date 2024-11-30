package com.Bookie.config.repository;

import com.Bookie.entities.CountryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CountryRepository extends JpaRepository<CountryEntity,Long> {

    @Query("SELECT c FROM CountryEntity c WHERE c.name = :name")
    CountryEntity findByName(@Param("name") String name);
}
