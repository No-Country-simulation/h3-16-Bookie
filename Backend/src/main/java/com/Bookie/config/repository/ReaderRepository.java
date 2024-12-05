package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.ReaderEntity;
import com.Bookie.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReaderRepository extends JpaRepository<ReaderEntity,Long> {
    @Query("""
        SELECT r FROM ReaderEntity r WHERE r.userId = :user_id AND r.historyId = :history_id
        """)
    ReaderEntity findByUserIdAndHistoryId(@Param("user_id") UserEntity user_id, @Param("history_id") HistoryEntity history_id);

    @Query("""
        SELECT r FROM ReaderEntity r WHERE r.userId = :user
        """)
    List<ReaderEntity> findByUser(@Param("user") UserEntity user);
}
