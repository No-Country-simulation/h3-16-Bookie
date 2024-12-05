package com.Bookie.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;


public class JsonUtil {


    public static void toJsonPrint(String title, Object object) throws JsonProcessingException {
        final ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        String formattedJson = objectMapper.writeValueAsString(object);
        System.out.println(title + " : " + formattedJson);


    }

    public static  ResponseEntity<?> PatchMetodTest(String urlDto) {
        RestTemplate restTemplate = new CustomRestTemplate();
        String url = urlDto;

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> entity = new HttpEntity<>( headers);
        ResponseEntity<?> response = restTemplate.exchange(url, HttpMethod.PATCH, entity, Object.class);
       return response;
    }
}



