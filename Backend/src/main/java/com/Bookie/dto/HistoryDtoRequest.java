package com.Bookie.dto;

import com.Bookie.enums.GenreLiterary;
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
        String img,
        @NotBlank
        String country,
        @NotBlank
        String province
) {
}
