package com.Bookie;

import com.Bookie.config.repository.UserRepository;
import com.Bookie.entities.UserEntity;
import com.Bookie.util.JsonUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserTest {

    @Autowired
    private UserRepository UserRepository;
    private TestRestTemplate testRestTemplate;

    @Autowired
    private RestTemplateBuilder restTemplateBuilder;

    @LocalServerPort
    private int port;

    private  ObjectMapper mapper;

    @BeforeEach
    void setUp() {
        restTemplateBuilder = restTemplateBuilder.rootUri("http://localhost:" + port);
        testRestTemplate = new TestRestTemplate(restTemplateBuilder);
        mapper = new ObjectMapper();
        mapper.enable(SerializationFeature.INDENT_OUTPUT);
    }

    @Test
    void createUser() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);


        String json = """
                {
                  "name":"Dario",
                    
                         "user_id": "326Dario",
                      
                         "email": "Dario@gmail.com"
                    
                }
                """;
        HttpEntity<String> request = new HttpEntity<>(json,headers);
        ResponseEntity<String> result = testRestTemplate.exchange("/api/webhooks/auth0/user-created", HttpMethod.POST, request, String.class);
        System.out.println("result = " + result);

        assertAll(
                () -> assertEquals(HttpStatus.OK, result.getStatusCode()),
                () -> assertEquals(200, result.getStatusCode().value()),
                () -> assertEquals(result.getBody(),"User synchronized successfully.")
        );
    }

    /**
     * http://deploy-bookie-production.up.railway.app/api/webhooks/auth0/user-created
     * deploy
     */
    @Test
    @Disabled("solo para el crear ususarios en el deploy")
    void createUserDeploy() {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);


        String json = """
                {
                  "name":"Dario",
                    
                         "user_id": "326Dario",
                      
                         "email": "Dario@gmail.com"
                    
                }
                """;
        HttpEntity<String> request = new HttpEntity<>(json,headers);
        ResponseEntity<String> result = testRestTemplate.exchange("http://deploy-bookie-production.up.railway.app/api/webhooks/auth0/user-created", HttpMethod.POST, request, String.class);
        System.out.println("result = " + result);

        assertAll(
                () -> assertEquals(HttpStatus.OK, result.getStatusCode()),
                () -> assertEquals(200, result.getStatusCode().value()),
                () -> assertEquals(result.getBody(),"User synchronized successfully.")
        );
    }

    
    @Test
    @Transactional
    void allUser() throws JsonProcessingException {
   List<UserEntity> users = UserRepository.findAll();

   //mapeando arreglo a json

         String json = mapper.writeValueAsString(users);
         System.out.println(json);

        assertNotEquals(users.isEmpty(),null);
    }



}
