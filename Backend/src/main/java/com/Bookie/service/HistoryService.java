package com.Bookie.service;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.repository.HistoryRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class HistoryService {

    @Autowired
    private HistoryRepository historyRepository;

    public HistoryDtoResponse createHistory(@Valid HistoryDtoRequest historyDto){
        HistoryEntity history = historyRepository.save(new HistoryEntity());
        return new HistoryDtoResponse(history.getId(),history.getTitle(),history.getSyopsis(),history.getCreator().getId(),history.getGenre(),history.getImg());
    }
}
