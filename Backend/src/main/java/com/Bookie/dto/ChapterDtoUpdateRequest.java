package com.Bookie.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ChapterDtoUpdateRequest(
        @NotBlank String title,
        @NotBlank String content,
        @NotNull Double latitude,
        @NotNull Double longitude,
        String image
) {
}
