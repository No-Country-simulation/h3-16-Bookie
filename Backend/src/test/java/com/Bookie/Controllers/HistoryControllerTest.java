package com.Bookie.Controllers;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.enums.GenreLiterary;
import com.fasterxml.jackson.databind.JsonNode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class HistoryControllerTest {


    private TestRestTemplate testRestTemplate;

    @Autowired
    private RestTemplateBuilder restTemplateBuilder;

    @LocalServerPort
    private int port;

    @BeforeEach
    void setUp() {
        restTemplateBuilder = restTemplateBuilder.rootUri("http://localhost:" + port);
        testRestTemplate = new TestRestTemplate(restTemplateBuilder);
    }
    @Test
    void getAllHistoties() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> request = new HttpEntity<>(headers);

        ResponseEntity<JsonNode> result = testRestTemplate.exchange("/api/v1/history/all", HttpMethod.GET,request, JsonNode.class);
        System.out.println("getAllHistoties = " + result);

        assertAll(
                () -> assertEquals(HttpStatus.OK, result.getStatusCode()),
                () -> assertEquals(200, result.getStatusCode().value()),
                () -> assertTrue(!result.getBody().isEmpty())
        );
    }

    @Test
    void crateHistory(){
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HistoryDtoRequest HistoryDtoRequest = new HistoryDtoRequest("Historia del monte embrujado",
                "Encuantro sercano con almas en pena",1L, GenreLiterary.FANTASIA,"http://portada.jpg");

        String json = """
                {
                  "title":"Historia del monte embrujado",             \s
                                  gi   "synopsis": "Encuantro sercano con almas en pena",
                                     "creator_id": "1",
                                     "genre": "SUSPENSO",
                                     "img": "http://portada.jpg"
                }
                """;
        HttpEntity<String> request = new HttpEntity<>(json,headers);
        ResponseEntity<HistoryDtoRequest> crateHistoryResult = testRestTemplate.exchange("/api/v1/history", HttpMethod.POST, request, HistoryDtoRequest.class);
        System.out.println("crateHistoryResult = " + crateHistoryResult);
        System.out.println("HistoryDtoRequest = " + json);

        assertAll(
                () -> assertEquals(HttpStatus.CREATED, crateHistoryResult.getStatusCode()),
                () -> assertEquals(201, crateHistoryResult.getStatusCode().value()),
                () -> assertEquals(crateHistoryResult.getBody().title(),HistoryDtoRequest.title()),
                () -> assertEquals(crateHistoryResult.getBody().genre(),HistoryDtoRequest.genre())
        );
    }
}