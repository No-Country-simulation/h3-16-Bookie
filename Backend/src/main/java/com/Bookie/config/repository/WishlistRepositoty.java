package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.entities.WishlistEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WishlistRepositoty extends JpaRepository<WishlistEntity, Long> {

    @Query("""
            SELECT w FROM WishlistEntity w WHERE w.user = :user AND w.history = :history
            """)
    WishlistEntity findByUserAndHistory(@Param("user") UserEntity user, @Param("history") HistoryEntity history);


    }