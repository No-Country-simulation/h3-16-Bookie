package com.Bookie.dto;

import java.util.List;

public record UserWithHistoriesDTO(
        Long id,
        String name,
        String email,
        List<HistoryWithChaptersDTO> histories
) {
    public UserWithHistoriesDTO(com.Bookie.entities.UserEntity user) {
        this(
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getHistories().stream()
                        .map(HistoryWithChaptersDTO::new)
                        .toList()
        );
    }
}