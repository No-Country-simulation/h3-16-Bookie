package com.Bookie.Controllers;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.dto.ReaderCreateRequest;
import com.Bookie.dto.ReaderRequest;
import com.Bookie.enums.GenreLiterary;
import com.Bookie.util.JsonUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
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
class ReaderControllerTest {

    private TestRestTemplate testRestTemplate;

    private HttpHeaders headers;


    @Autowired
    private RestTemplateBuilder restTemplateBuilder;

    @LocalServerPort
    private int port;

    @BeforeEach
    void setUp() {
        restTemplateBuilder = restTemplateBuilder.rootUri("http://localhost:" + port);
        testRestTemplate = new TestRestTemplate(restTemplateBuilder);
        headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

    }

    @Test
    void createReader() throws JsonProcessingException {

        ReaderCreateRequest readerCreateRequest = new ReaderCreateRequest(1L, 58L);


        String json = " { \"user_id\" : " + readerCreateRequest.user_id() + ", \"history_id\" : " + readerCreateRequest.history_id() + " }";

        HttpEntity<String> request = new HttpEntity<>(json, headers);
        ResponseEntity<ReaderRequest> crateHistoryResult = testRestTemplate.exchange("/api/vi/reader", HttpMethod.POST, request, ReaderRequest.class);

        System.out.println("HistoryDtoRequest = " + json);
        JsonUtil.toJsonPrint("crateHistoryResult", crateHistoryResult);


        assertAll(
                () -> assertEquals(HttpStatus.CREATED, crateHistoryResult.getStatusCode()),
                () -> assertEquals(201, crateHistoryResult.getStatusCode().value()),
                () -> assertEquals(crateHistoryResult.getBody().user().id(), readerCreateRequest.user_id()),
                () -> assertEquals(crateHistoryResult.getBody().history().getId(), readerCreateRequest.history_id())
        );
    }
}
