package com.Bookie.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;


public class JsonUtil {


    public static void toJsonPrint(String title, Object object) throws JsonProcessingException {
        final ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
        String formattedJson = objectMapper.writeValueAsString(object);
        System.out.println(title + " : " + formattedJson);


    }
}


