package com.Bookie.Controllers;

import com.Bookie.dto.ChapterDtoRequest;
import com.Bookie.dto.ChapterDtoResponse;
import com.Bookie.dto.ChapterDtoUpdateRequest;
import com.Bookie.service.ChapterService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/chapters")
@CrossOrigin("*")
public class ChapterController {

    private final ChapterService chapterService;

    public ChapterController(ChapterService chapterService) {
        this.chapterService = chapterService;
    }

    @PostMapping
    public ResponseEntity<ChapterDtoResponse> createChapter(@RequestBody @Valid ChapterDtoRequest chapterDto) {
        ChapterDtoResponse response = chapterService.createChapter(chapterDto);
        return ResponseEntity.status(201).body(response);
    }

    @GetMapping("/history/{historyId}")
    public ResponseEntity<List<ChapterDtoResponse>> getChaptersByHistory(@PathVariable Long historyId) {
        List<ChapterDtoResponse> chapters = chapterService.getChaptersByHistoryId(historyId);
        return ResponseEntity.ok(chapters);
    }

    @PutMapping("/{chapterId}")
    public ResponseEntity<ChapterDtoResponse> updateChapter(
            @PathVariable Long chapterId,
            @RequestBody @Valid ChapterDtoUpdateRequest updateRequest) {
        ChapterDtoResponse response = chapterService.updateChapter(chapterId, updateRequest);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{chapterId}")
    public ResponseEntity<String> deleteChapter(@PathVariable Long chapterId) {
        String message = chapterService.deleteChapter(chapterId);
        return ResponseEntity.ok(message);
    }
}
