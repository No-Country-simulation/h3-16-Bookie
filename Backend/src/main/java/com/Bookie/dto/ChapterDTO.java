package com.Bookie.dto;

public record ChapterDTO(
        Long id,
        String title,
        String content,
        String img
) {
    public ChapterDTO(com.Bookie.entities.ChapterEntity chapter) {
        this(chapter.getId(), chapter.getTitle(), chapter.getContent(),chapter.getImg());
    }
}
