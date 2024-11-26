package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface HistoryRepository extends JpaRepository<HistoryEntity, Long> {

   List<HistoryEntity> findByCreator(UserEntity userId);
}
