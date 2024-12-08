package com.Bookie.service;

import com.Bookie.config.repository.ChapterRepository;
import com.Bookie.config.repository.ReaderChapterRespository;
import com.Bookie.config.repository.ReaderRepository;
import com.Bookie.dto.ChapterCompeteRquest;
import com.Bookie.dto.ReaderChapterDto;
import com.Bookie.dto.ReaderChapterRequest;
import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.ReaderChapterEntity;
import com.Bookie.entities.ReaderEntity;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReaderChapterService {

    @Autowired
    private ReaderChapterRespository readerChapterRespository;

    @Autowired
    private ReaderRepository readerRepository;

    @Autowired
    private ChapterRepository chapterRepository;

    public ReaderChapterRequest createReaer(ReaderChapterDto readerChapterDto) {
        ReaderEntity reader = readerRepository.findById(readerChapterDto.readerId()).orElseThrow(() -> new EntityNotFoundException("Reader not found"));
        ChapterEntity chapter = chapterRepository.findById(readerChapterDto.chapterId()).orElseThrow(() -> new EntityNotFoundException("Chapter not found"));

        //verificar si existe lo devuelva
        ReaderChapterEntity readerChapter = readerChapterRespository.findByReaderAndChapter(reader, chapter);
        if (readerChapter != null) return new ReaderChapterRequest(readerChapter);

        ReaderChapterEntity readerChapterDb = readerChapterRespository.save(new ReaderChapterEntity(reader, chapter));

        return new ReaderChapterRequest(readerChapterDb);
    }

    public ReaderChapterRequest publishReaderChapter(@NotNull Long id) {
        ReaderChapterEntity readerChapter = readerChapterRespository.findById(id).orElseThrow(() -> new EntityNotFoundException("reader-chapter not found"));
        readerChapter.setComplete(true);
        readerChapter = readerChapterRespository.save(readerChapter);

        //agregar la siguiente historia al reader-chapter
        pasarChapterAListReaderChapter(readerChapter);

        //verificar si todos los capitules fueron leidos para pasar la historia a completada
        Boolean readerChapterIsComplete = ReaderIsComplete(readerChapter.getReader().getReaderChapter());

        if (readerChapterIsComplete) readerComplete(readerChapter);

        return new ReaderChapterRequest(readerChapter);
    }


    /**
     * <p>Metodo para cargar el siguiente chapter a la lista de reader-chapter</p>
     *
     * @param readerChapter
     */
    private void pasarChapterAListReaderChapter(ReaderChapterEntity readerChapter) {
        List<ChapterEntity> chaptersHistory = readerChapter.getReader().getHistoryId().getChapters();
        List<ChapterCompeteRquest> chaptersReaderChapter = readerChapterRespository.findAllByChapter(readerChapter.getReader());
        if(chaptersReaderChapter.size() == chaptersHistory.size()) return;
        ChapterEntity chapter = chaptersHistory.get(chaptersReaderChapter.size());
        ReaderChapterEntity newReaderChapter = new ReaderChapterEntity();
        newReaderChapter.setChapter(chapter);
        newReaderChapter.setReader(readerChapter.getReader());
        newReaderChapter.setComplete(false);
        readerChapterRespository.save(newReaderChapter);
    }

    /**
     * <p>Pasar el reader a complete true si todos los capitulos estan leidos</p>
     *
     * @param readerChapter
     */
    private void readerComplete(ReaderChapterEntity readerChapter) {
        ReaderEntity reader = readerChapter.getReader();
        reader.setComplete(true);
        readerRepository.save(reader);
    }

    /**
     * <p>Verifica si en la lista todos los capitulos fueron leidos</p>
     *
     * @param readerChapter
     * @return boolean
     */
    private Boolean ReaderIsComplete(List<ReaderChapterEntity> readerChapter) {

        List<ReaderChapterEntity> readerChapterFilter = readerChapter.stream().filter(ReaderChapterEntity::getComplete).toList();

        return readerChapter.size() == readerChapterFilter.size();
    }
}
