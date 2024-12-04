package com.Bookie.dto;

import jakarta.validation.constraints.NotNull;

public record ReaderCreateRequest(
        @NotNull
        Long user_id,
        @NotNull
        Long history_id
) {
}
