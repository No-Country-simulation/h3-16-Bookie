package com.Bookie.dto;

import com.Bookie.entities.UserEntity;
import com.Bookie.enums.GenreLiterary;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryDtoRequest(
        @NotBlank
        String title,
        @NotBlank
        String synopsis,
        @NotNull
        Long creator_id,
        @NotNull
        GenreLiterary genre,
        String img
) {
}
