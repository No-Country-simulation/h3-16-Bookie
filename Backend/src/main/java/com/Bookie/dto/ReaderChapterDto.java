package com.Bookie.dto;

import jakarta.validation.constraints.NotNull;

public record ReaderChapterDto(
        @NotNull
        Long readerId,
        @NotNull
        Long chapterId
) {
}
