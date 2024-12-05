package com.Bookie.config.repository;

import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.ReaderChapterEntity;
import com.Bookie.entities.ReaderEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReaderChapterRespository extends JpaRepository<ReaderChapterEntity,Long> {

    @Query("""
            SELECT r FROM ReaderChapterEntity r WHERE r.reader = :reader AND r.chapter = :chapter
            """)
    ReaderChapterEntity findByReaderAndChapter(@Param("reader") ReaderEntity reader, @Param("chapter")  ChapterEntity chapter);
}
