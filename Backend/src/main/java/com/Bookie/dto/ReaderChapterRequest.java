package com.Bookie.dto;

import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.ReaderChapterEntity;
import com.Bookie.entities.ReaderEntity;

public record ReaderChapterRequest(
        Long id,
        ReaderEntity reader,
        ChapterEntity chapter,
        Boolean complete
) {
    public ReaderChapterRequest(ReaderChapterEntity readerChapterDb) {
        this(readerChapterDb.getId(), readerChapterDb.getReader(),readerChapterDb.getChapter(),readerChapterDb.getComplete());
    }
}
