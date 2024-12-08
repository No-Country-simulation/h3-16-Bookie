package com.Bookie.dto;

import com.Bookie.entities.ChapterEntity;

public record ChapterCompeteRquest(
        ChapterEntity chapter,
        Boolean complete
) {
}
