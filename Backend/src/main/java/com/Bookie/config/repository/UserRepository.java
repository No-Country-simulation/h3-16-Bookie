package com.Bookie.config.repository;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, Long> {
    Optional<UserEntity> findByEmail(String email);

    Optional<UserEntity> findByAuth0UserId(String auth0UserId);

    @Query("SELECT u FROM UserEntity u LEFT JOIN FETCH u.histories h WHERE h IS NOT NULL")
    List<UserEntity> findUsersWithHistories();


    /*@Query("SELECT h FROM HistoryEntity h LEFT JOIN FETCH h.chapters WHERE h.creator.id = :userId")
    List<HistoryEntity> findHistoriesWithChapters(@Param("userId") Long userId);*/

}
