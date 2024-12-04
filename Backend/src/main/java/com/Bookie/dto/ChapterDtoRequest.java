package com.Bookie.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ChapterDtoRequest(
        @NotBlank String title,
        @NotBlank String content,
        @NotNull Double latitude,
        @NotNull Double longitude,
        @NotNull Long historyId,
        String image
) {
}
