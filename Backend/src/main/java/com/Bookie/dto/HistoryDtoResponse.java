package com.Bookie.dto;

import com.Bookie.enums.GenreLiterary;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryDtoResponse(
        @NotBlank
        Long id,
        @NotBlank
        String title,
        @NotBlank
        String syopsis,
        @NotBlank
        Long creator_id,
        @NotNull
        GenreLiterary genre,
        String img
) {
}
