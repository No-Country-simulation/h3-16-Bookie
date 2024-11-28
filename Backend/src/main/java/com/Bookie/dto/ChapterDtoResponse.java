package com.Bookie.dto;

import com.Bookie.entities.ChapterEntity;

public record ChapterDtoResponse(
        Long id,
        String title,
        String content,
        Double latitude,
        Double longitude,
        Long historyId
) {
    public ChapterDtoResponse(ChapterEntity chapter) {
        this(chapter.getId(), chapter.getTitle(), chapter.getContent(), chapter.getLatitude(), chapter.getLongitude(), chapter.getHistory().getId());
    }
}
