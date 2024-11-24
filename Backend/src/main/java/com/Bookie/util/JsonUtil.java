package com.Bookie.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Bean;


public class JsonUtil {


    private static final ObjectMapper objectMapper = new ObjectMapper();


    public static String toJson(Object object) throws JsonProcessingException {

        return objectMapper.writeValueAsString(object);

    }
}



