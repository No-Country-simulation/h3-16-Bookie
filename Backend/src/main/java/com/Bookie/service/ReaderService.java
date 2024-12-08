package com.Bookie.service;

import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.config.repository.ReaderChapterRespository;
import com.Bookie.config.repository.ReaderRepository;
import com.Bookie.config.repository.UserRepository;
import com.Bookie.dto.ChapterCompeteRquest;
import com.Bookie.dto.ReaderCreateRequest;
import com.Bookie.dto.ReaderRequest;
import com.Bookie.dto.ReaderRequestList;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.ReaderEntity;
import com.Bookie.entities.UserEntity;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ReaderService {

    @Autowired
    private ReaderRepository readerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    private ReaderChapterRespository readerChapterRespository;

    public ReaderRequest createReaer(ReaderCreateRequest readerCreateRequest) {

        UserEntity user = userRepository.findById(readerCreateRequest.user_id()).orElseThrow(() -> new EntityNotFoundException("user not found"));
        HistoryEntity history = historyRepository.findById(readerCreateRequest.history_id()).orElseThrow(() -> new EntityNotFoundException("history not found"));

        //verificar si existe lo devuelva para no crearlo nuevamente
        ReaderEntity reader = readerRepository.findByUserIdAndHistoryId(user, history);
        if (reader != null) return new ReaderRequest(reader);

        ReaderEntity readerDb = readerRepository.save(new ReaderEntity(user, history));
        return new ReaderRequest(readerDb);
    }

    public List<ReaderRequestList> getReaderByUserId(@NotNull Long id) {
        UserEntity user = userRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("user not found"));
        List<ReaderEntity> readers = readerRepository.findByUser(user);
        if (readers == null) return new ArrayList<>();

        //agregar los chapter a los history
        List<ReaderRequestList> readerRequests =  agregarChaptersFromUser(readers);//readers.stream().map(ReaderRequestList::new).toList();
        return readerRequests;
    }

    private List<ReaderRequestList> agregarChaptersFromUser(List<ReaderEntity> readers) {
        List<ReaderRequestList> chaptersReturn = new ArrayList<>();
        for (ReaderEntity r : readers) {
            ReaderEntity reader =   readerRepository.findById(r.getId()).orElseThrow(() -> new EntityNotFoundException("reader not found"));
            List<ChapterCompeteRquest> chapters = readerChapterRespository.findAllByChapter(reader);
            var readerReturn = new ReaderRequestList(r,chapters);

            chaptersReturn.add(readerReturn);

        }
        return chaptersReturn;
    }
}
