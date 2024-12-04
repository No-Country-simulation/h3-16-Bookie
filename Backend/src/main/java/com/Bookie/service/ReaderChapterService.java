package com.Bookie.service;

import com.Bookie.config.repository.ChapterRepository;
import com.Bookie.config.repository.ReaderChapterRespository;
import com.Bookie.config.repository.ReaderRepository;
import com.Bookie.dto.ReaderChapterDto;
import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.ReaderChapterEntity;
import com.Bookie.entities.ReaderEntity;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReaderChapterService {

    @Autowired
    private ReaderChapterRespository readerChapterRespository;

    @Autowired
    private ReaderRepository readerRepository;

    @Autowired
    private ChapterRepository chapterRepository;

    public ReaderChapterEntity createReaer(ReaderChapterDto readerChapterDto) {
        ReaderEntity reader = readerRepository.findById(readerChapterDto.readerId()).orElseThrow( ()-> new EntityNotFoundException("Reader not found"));
        ChapterEntity chapter = chapterRepository.findById(readerChapterDto.chapterId()).orElseThrow( ()-> new EntityNotFoundException("Chapter not found"));
        return readerChapterRespository.save(new ReaderChapterEntity(reader,chapter));
    }
}
