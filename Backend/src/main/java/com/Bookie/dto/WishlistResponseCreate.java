package com.Bookie.dto;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.entities.WishlistEntity;
import jakarta.validation.constraints.NotNull;

public record WishlistResponseCreate(@NotNull Long id, @NotNull UserEntity userID, @NotNull HistoryEntity historyID) {

    public WishlistResponseCreate(WishlistEntity wishlist){
        this(wishlist.getId(),wishlist.getUser(),wishlist.getHistory());
    }
}
