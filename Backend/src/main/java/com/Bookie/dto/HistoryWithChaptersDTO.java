package com.Bookie.dto;

import java.util.List;

public record HistoryWithChaptersDTO(
        Long id,
        String title,
        String synopsis,
        List<ChapterDTO> chapters
) {
    public HistoryWithChaptersDTO(com.Bookie.entities.HistoryEntity history) {
        this(
                history.getId(),
                history.getTitle(),
                history.getSyopsis(),
                history.getChapters().stream()
                        .map(ChapterDTO::new)
                        .toList()
        );
    }
}
