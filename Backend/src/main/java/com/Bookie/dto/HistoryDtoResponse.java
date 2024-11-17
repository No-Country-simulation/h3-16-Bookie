package com.Bookie.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryDtoResponse(
        @NotBlank
        Long id,
        @NotNull
        HistoryDtoRequest history
) {
}
