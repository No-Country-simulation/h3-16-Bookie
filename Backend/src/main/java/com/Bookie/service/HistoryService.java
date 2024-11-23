package com.Bookie.service;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoRequestUpdate;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.config.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class HistoryService {

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    private UserRepository userRepository;

    public HistoryDtoResponse createHistory(@Valid HistoryDtoRequest historyDto) {
        Optional<UserEntity> user = userRepository.findById(historyDto.creator_id());
        HistoryEntity historyEntity = HistoryEntity.builder()
                .creator(user.get())
                .genre(historyDto.genre())
                .title(historyDto.title())
                .syopsis(historyDto.synopsis())
                .img(historyDto.img())
                .publish(false)
                .build();
        HistoryEntity history = historyRepository.save(historyEntity);


        return new HistoryDtoResponse(history.getId(), history.getTitle(), history.getSyopsis(), history.getCreator(), history.getGenre(), history.getImg());

    }

    public List<HistoryEntity> getAll() {
        return historyRepository.findAll();

    }

    public HistoryDtoResponse updateHistory(HistoryDtoRequestUpdate historyDto, @NotNull Long id) {
     HistoryEntity history = historyRepository.findById(id).orElseThrow(()->   new EntityNotFoundException("Entity not found"));

     if(historyDto.title() != null) history.setTitle(historyDto.title());
        if(historyDto.img() != null) history.setImg(historyDto.img());
        if(historyDto.synopsis() != null) history.setSyopsis(historyDto.synopsis());
        if(historyDto.genre() != null) history.setGenre(historyDto.genre());

        HistoryEntity historyDb = historyRepository.save(history);
       // return new HistoryDtoResponse(historyDb);
        return new HistoryDtoResponse(historyDb.getId(),historyDb.getTitle(),historyDb.getSyopsis(),historyDb.getCreator(),historyDb.getGenre(),historyDb.getImg());
    }
}
