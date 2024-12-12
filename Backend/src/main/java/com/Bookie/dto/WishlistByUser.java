package com.Bookie.dto;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.WishlistEntity;
import jakarta.validation.constraints.NotNull;

public record WishlistByUser(@NotNull Long id, @NotNull HistoryEntity histories) {
    public WishlistByUser(WishlistEntity w){
        this(w.getId(),w.getHistory());
    }
}
