package com.Bookie.service;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.repository.HistoryRepository;
import com.Bookie.repository.UserRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
                .build();
        HistoryEntity history = historyRepository.save(historyEntity);
        return new HistoryDtoResponse(history.getId(), history.getTitle(), history.getSyopsis(), history.getCreator().getId(), history.getGenre(), history.getImg());
    }

    public JsonNode getAll() throws JsonProcessingException {
        String jsonString = """
                {
                  "history": {
                    "id": 10,
                    "title": "Historia del monte embrujado",
                    "synopsis": "Encuantro sercano con almas en pena",
                    "publish": "true",
                    "img": "foto.jpg",
                    "genre": "MISTERY",
                    "complete": "false",
                    "chapters": [
                      {
                        "id": 12,
                        "title": "capitulo 1 obelisco Argentina",
                        "order": "1",
                        "img": "foto.jpg",
                        "latitude": "-34.603851",
                        "longitude": "-58.381775",
                        "publish": "true",
                        "complete": "false",
                        "page": [
                          {
                            "id": 12,
                            "description": "Texto de la pagina",
                            "order": "1",
                            "complete": "true"
                          },
                          {
                            "id": 31,
                            "description": "Texto de la pagina",
                            "order": "2",
                            "complete": "false"
                          }
                        ]
                      },
                      {
                        "id": 13,
                        "title": "capitulo 2 encuentro flor metalica Argentina",
                        "order": "2",
                        "img": "foto.jpg",
                        "latitude": "-34.603851",
                        "longitude": "-58.381775",
                        "publish": "true",
                        "complete": "true",
                        "page": [
                          {
                            "id": 19,
                            "description": "Texto de la pagina",
                            "order": "1",
                            "complete": "false"
                          },
                          {
                            "id": 51,
                            "description": "Texto de la pagina",
                            "order": "2",
                            "complete": "false"
                          }
                        ]
                      }
                    ]
                  }
                }
                               
                               
                """;

        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonNode = mapper.readTree(jsonString);
        return jsonNode;
        //  "": "",

    }
}
