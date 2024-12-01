package com.Bookie.dto;

import jakarta.validation.constraints.NotNull;

public record WishlistRequestCreate(@NotNull Long userID, @NotNull Long historyID) {
}
