package com.Bookie.config.repository;

import com.Bookie.entities.WishlistEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WishlistRepositoty extends JpaRepository<WishlistEntity,Long> {
}
