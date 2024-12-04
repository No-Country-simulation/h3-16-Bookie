package com.Bookie.service;

import com.Bookie.config.repository.ChapterRepository;
import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.dto.ChapterDtoRequest;
import com.Bookie.dto.ChapterDtoResponse;
import com.Bookie.dto.ChapterDtoUpdateRequest;
import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.HistoryEntity;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ChapterService {

    private final ChapterRepository chapterRepository;
    private final HistoryRepository historyRepository;

    public ChapterService(ChapterRepository chapterRepository, HistoryRepository historyRepository) {
        this.chapterRepository = chapterRepository;
        this.historyRepository = historyRepository;
    }

    public ChapterDtoResponse createChapter(ChapterDtoRequest chapterDto) {
        HistoryEntity history = historyRepository.findById(chapterDto.historyId())
                .orElseThrow(() -> new EntityNotFoundException("History not found"));

        ChapterEntity chapter = ChapterEntity.builder()
                .title(chapterDto.title())
                .content(chapterDto.content())
                .latitude(chapterDto.latitude())
                .longitude(chapterDto.longitude())
                .img(chapterDto.image()) // Agregar la imagen
                .history(history)
                .build();

        ChapterEntity savedChapter = chapterRepository.save(chapter);
        return new ChapterDtoResponse(savedChapter);
    }

    public List<ChapterDtoResponse> getChaptersByHistoryId(Long historyId) {
        List<ChapterEntity> chapters = chapterRepository.findByHistoryId(historyId);
        return chapters.stream().map(ChapterDtoResponse::new).collect(Collectors.toList());
    }

    public ChapterDtoResponse updateChapter(Long chapterId, ChapterDtoUpdateRequest updateRequest) {
        ChapterEntity chapter = chapterRepository.findById(chapterId)
                .orElseThrow(() -> new EntityNotFoundException("Chapter not found"));

        chapter.setTitle(updateRequest.title());
        chapter.setContent(updateRequest.content());
        chapter.setLatitude(updateRequest.latitude());
        chapter.setLongitude(updateRequest.longitude());

        if (updateRequest.image() != null) {
            chapter.setImg(updateRequest.image()); // Actualizar la imagen si se proporciona
        }

        ChapterEntity updatedChapter = chapterRepository.save(chapter);
        return new ChapterDtoResponse(updatedChapter);
    }

    public String deleteChapter(Long chapterId) {
        if (!chapterRepository.existsById(chapterId)) {
            throw new EntityNotFoundException("Chapter not found");
        }

        chapterRepository.deleteById(chapterId);
        return "Chapter deleted successfully";
    }
}
