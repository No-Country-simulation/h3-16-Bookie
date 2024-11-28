package com.Bookie.config.repository;

import com.Bookie.entities.ChapterEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ChapterRepository extends JpaRepository<ChapterEntity, Long> {
    List<ChapterEntity> findByHistoryId(Long historyId);
}
