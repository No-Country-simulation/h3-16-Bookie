package com.Bookie.Controllers;

import com.Bookie.dto.WishlistByUser;
import com.Bookie.dto.WishlistResponseCreate;
import com.Bookie.entities.HistoryEntity;
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
        Long historyID = 35L;

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
        ResponseEntity<List<HistoryEntity>> result = testRestTemplate.exchange("/api/v1/wishlist/1", HttpMethod.GET, request, new ParameterizedTypeReference<List<HistoryEntity>>() {});
        JsonUtil.toJsonPrint("List<HistotyEntity> = " , result);

        assertAll(
                () -> assertEquals(HttpStatus.OK, result.getStatusCode()),
                () -> assertEquals(200, result.getStatusCode().value()),
                () -> assertTrue(!result.getBody().isEmpty())

        );
    }


    @Test
    void deleteHistoryWishlist() throws JsonProcessingException {


        HttpEntity<String> request = new HttpEntity<>( headers);
        ResponseEntity<JsonNode> result = testRestTemplate.exchange("/api/v1/wishlist/22", HttpMethod.DELETE, request, JsonNode.class);
        JsonUtil.toJsonPrint("List<HistotyEntity> = " , result);

        assertAll(
                () -> assertEquals(HttpStatus.ACCEPTED, result.getStatusCode()),
                () -> assertEquals(202, result.getStatusCode().value())


        );
    }

    @Test
    void getWishlistByUserId() throws JsonProcessingException {


        HttpEntity<String> request = new HttpEntity<>( headers);
        ResponseEntity<List<WishlistByUser>> result = testRestTemplate.exchange("/api/v1/wishlist/user/1", HttpMethod.GET, request, new ParameterizedTypeReference<List<WishlistByUser>>() {});
        JsonUtil.toJsonPrint("List<HistotyEntity> = " , result);

        assertAll(
                () -> assertEquals(HttpStatus.OK, result.getStatusCode()),
                () -> assertEquals(200, result.getStatusCode().value()),
                () -> assertTrue(!result.getBody().isEmpty())

        );
    }
}