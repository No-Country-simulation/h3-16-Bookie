package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.enums.GenreLiterary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface HistoryRepository extends JpaRepository<HistoryEntity, Long> {

   List<HistoryEntity> findByCreator(UserEntity userId);

   @Query("SELECT h FROM HistoryEntity h WHERE LOWER(h.province.name) = LOWER(:provinceName)")
   List<HistoryEntity> findByProvinceName(@Param("provinceName") String provinceName);

   @Query("SELECT h FROM HistoryEntity h WHERE LOWER(h.province.country.name) = LOWER(:countryName)")
   List<HistoryEntity> findByCountryName(@Param("countryName") String countryName);

   @Query("SELECT h FROM HistoryEntity h WHERE h.genre = :genre")
   List<HistoryEntity> findByGenre(@Param("genre") GenreLiterary genre);
}
