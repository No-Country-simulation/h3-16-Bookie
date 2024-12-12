package com.Bookie.Controllers;

import com.Bookie.dto.ChapterDtoRequest;
import com.Bookie.dto.ChapterDtoResponse;
import com.Bookie.dto.WishlistResponseCreate;
import com.Bookie.util.JsonUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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
class ChapterControllerTest {

    private TestRestTemplate testRestTemplate;

    @Autowired
    private RestTemplateBuilder restTemplateBuilder;

    @LocalServerPort
    private int port;


    HttpHeaders headers;

    @BeforeEach
    void setUp() {
        restTemplateBuilder = restTemplateBuilder.rootUri("http://localhost:" + port);
        testRestTemplate = new TestRestTemplate(restTemplateBuilder);
        headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
    }


    @Test
    void createChapter() throws JsonProcessingException {
        var chapter = new ChapterDtoRequest("capitulo 3 Baranquilla", "El regreso a casa ",
                10.96854, 74.78132, 50L,"http://img.jpg");

        String json = " { \"title\" : \"" + chapter.title() + "\" ,  \"content\" : \"" + chapter.content() + "\" ,  \"latitude\" : "
                + chapter.latitude() + " ,  \"longitude\" : " + chapter.longitude() + " ,  \"historyId\" : " + chapter.historyId() + " ,  \"image\" : \"" + chapter.image() +"\" } ";

        JsonUtil.toJsonPrint("json ", json);


        HttpEntity<String> request = new HttpEntity<>(json, headers);
        ResponseEntity<ChapterDtoResponse> result = testRestTemplate.exchange("/api/v1/chapters", HttpMethod.POST, request, ChapterDtoResponse.class);
        JsonUtil.toJsonPrint("WishlistResponseCreate ", result);

        assertAll(
                () -> assertEquals(201, result.getStatusCode().value()),
                () -> assertEquals(result.getBody().title(), chapter.title()),
                () -> assertEquals(result.getBody().historyId(), chapter.historyId())
        );
    }


    @Test
    void getChaptersByHistory() {
    }

    @Test
    void updateChapter() {
    }

    @Test
    void deleteChapter() {
    }
}