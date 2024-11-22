package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HistoryRepository extends JpaRepository<HistoryEntity, Long> {

}
