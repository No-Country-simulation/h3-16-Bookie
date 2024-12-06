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

        //setear la distancia total entre capitulos en metros
        if (history.getChapters().size() > 1) setdistanceOFChapter(history);

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

    /**
     * Arregla la ligica entre la distancia de cada capitulo en la historia en metros
     *
     * @param history
     */
    private void setdistanceOFChapter(HistoryEntity history) {
        HistoryEntity historyDb = history;
        Double latitude = 0D;
        Double longitude = 0D;
        Double totalKlometros = 0D;
        List<ChapterEntity> chapters = historyDb.getChapters();


        for (ChapterEntity chapter : chapters) {

            if (latitude != 0 && longitude != 0) {

                totalKlometros += calcularDistanciaPuntosSuperficieTierra(latitude, longitude, chapter.getLatitude(), chapter.getLongitude());

            }
            latitude = chapter.getLatitude();
            longitude = chapter.getLongitude();
        }

        historyDb.setDistance(totalKlometros);
        historyRepository.save(historyDb);
    }

    /**
     * <p>Funcion para calcular la diferencia de puntos cardinales en kilometros</p>
     *
     * @param latitud1
     * @param longitud1
     * @param latitud2
     * @param longitud2
     * @return
     */
    public static Double calcularDistanciaPuntosSuperficieTierra(Double latitud1, Double longitud1, Double latitud2, Double longitud2) {
        final Double tierra = 6371.01;;
        latitud1 = Math.toRadians(latitud1);
        longitud1 = Math.toRadians(longitud1);
        latitud2 = Math.toRadians(latitud2);
        longitud2 = Math.toRadians(longitud2);

        Double diferencia = tierra * Math.acos(Math.sin(latitud1) * Math.sin(latitud2)
                + Math.cos(latitud1) * Math.cos(latitud2) * Math.cos(longitud1 - longitud2)
        );
        //convertir los kilometros a metros 1 kilometro son 1000 metros
        return diferencia * 1000;
    }
}
