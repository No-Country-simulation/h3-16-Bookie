package com.Bookie.Controllers;

import com.Bookie.dto.WishlistResponseCreate;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.util.JsonUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import jakarta.validation.constraints.NotNull;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class WishlistControllerTest {

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
    void crateWishlist() throws JsonProcessingException {
        Long userId = 1L;
        Long historyID = 74L;

        String json = " { \"userID\" : "+ userId +" ,  \"historyID\" : "+ historyID +" } ";

        JsonUtil.toJsonPrint("json " , json);


        HttpEntity<String> request = new HttpEntity<>(json, headers);
        ResponseEntity<WishlistResponseCreate> result = testRestTemplate.exchange("/api/v1/wishlist", HttpMethod.POST, request, WishlistResponseCreate.class);
        JsonUtil.toJsonPrint("WishlistResponseCreate " , result);

        assertAll(
                () -> assertEquals(HttpStatus.CREATED, result.getStatusCode()),
                () -> assertEquals(201, result.getStatusCode().value()),
                () -> assertEquals(result.getBody().userID().getId(), userId),
                () -> assertEquals(result.getBody().historyID().getId(), historyID)
        );
    }

    @Test
    void getWishlist() throws JsonProcessingException {


        HttpEntity<String> request = new HttpEntity<>( headers);
        ResponseEntity<List> result = testRestTemplate.exchange("/api/v1/wishlist/all", HttpMethod.GET, request, List.class);
        JsonUtil.toJsonPrint("List<HistotyEntity> = " , result);

        assertAll(
                () -> assertEquals(HttpStatus.CREATED, result.getStatusCode()),
                () -> assertEquals(201, result.getStatusCode().value()),
                () -> assertTrue(!result.getBody().isEmpty())

        );
    }


}