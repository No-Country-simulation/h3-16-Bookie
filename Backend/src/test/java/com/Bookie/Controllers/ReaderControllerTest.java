package com.Bookie.Controllers;

import com.Bookie.dto.*;
import com.Bookie.entities.ReaderEntity;
import com.Bookie.util.CustomRestTemplate;
import com.Bookie.util.JsonUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;

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

        ReaderCreateRequest readerCreateRequest = new ReaderCreateRequest(3L, 50L);


        String json = " { \"user_id\" : " + readerCreateRequest.user_id() + ", \"history_id\" : " + readerCreateRequest.history_id() + " }";

        HttpEntity<String> request = new HttpEntity<>(json, headers);
        ResponseEntity<ReaderRequest> crateHistoryResult = testRestTemplate.exchange("/api/v1/reader", HttpMethod.POST, request, ReaderRequest.class);

        System.out.println("HistoryDtoRequest = " + json);
        JsonUtil.toJsonPrint("crateHistoryResult", crateHistoryResult);


        assertAll(
                () -> assertEquals(HttpStatus.CREATED, crateHistoryResult.getStatusCode()),
                () -> assertEquals(201, crateHistoryResult.getStatusCode().value()),
                () -> assertEquals(crateHistoryResult.getBody().user().id(), readerCreateRequest.user_id()),
                () -> assertEquals(crateHistoryResult.getBody().history().getId(), readerCreateRequest.history_id())
        );


    }

    @Test
    void getReaderByUserId() throws JsonProcessingException {

        int id = 3;




        HttpEntity<String> request = new HttpEntity<>( headers);
        ResponseEntity< List<ReaderRequestList>> crateHistoryResult = testRestTemplate.exchange("/api/v1/reader/" + id, HttpMethod.GET, request, new ParameterizedTypeReference<List<ReaderRequestList>>() {});

        JsonUtil.toJsonPrint("crateHistoryResult", crateHistoryResult);


        assertAll(
                () -> assertEquals(HttpStatus.OK, crateHistoryResult.getStatusCode()),
                () -> assertEquals(200, crateHistoryResult.getStatusCode().value()),
                () -> assertNotNull(crateHistoryResult.getBody())

        );


    }

    @Test
    void createReaderChapter() throws JsonProcessingException {

        ReaderChapterDto readerChapterDto = new ReaderChapterDto(452L, 352L);


        String json = " { \"readerId\" : " + readerChapterDto.readerId() + ", \"chapterId\" : " + readerChapterDto.chapterId() + " }";

        HttpEntity<String> request = new HttpEntity<>(json, headers);
        ResponseEntity<ReaderChapterRequest> crateHistoryResult = testRestTemplate.exchange("/api/v1/reader-chapter", HttpMethod.POST, request, ReaderChapterRequest.class);

        System.out.println("HistoryDtoRequest = " + json);
        JsonUtil.toJsonPrint("crateHistoryResult", crateHistoryResult);


        assertAll(
                () -> assertEquals(HttpStatus.CREATED, crateHistoryResult.getStatusCode()),
                () -> assertEquals(201, crateHistoryResult.getStatusCode().value()),
                () -> assertEquals(crateHistoryResult.getBody().chapter().getId(), readerChapterDto.chapterId()),
                () -> assertEquals(crateHistoryResult.getBody().reader().getId(), readerChapterDto.readerId())
        );
    }


    @Test
    void publishReaderChapter() throws JsonProcessingException {
        RestTemplate restPatchTemplate = new CustomRestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>(headers);


        int id = 602;

        ResponseEntity<ReaderChapterRequest> crateHistoryResult = restPatchTemplate.exchange(testRestTemplate.getRootUri() + "/api/v1/reader-chapter/" + id, HttpMethod.PATCH, entity, ReaderChapterRequest.class);


        JsonUtil.toJsonPrint("crateHistoryResult", crateHistoryResult);


        assertAll(
                () -> assertEquals(HttpStatus.ACCEPTED, crateHistoryResult.getStatusCode()),
                () -> assertEquals(202, crateHistoryResult.getStatusCode().value()),
                () -> assertEquals(crateHistoryResult.getBody().id(), id),
                () -> assertTrue(crateHistoryResult.getBody().complete())

        );
    }


}
