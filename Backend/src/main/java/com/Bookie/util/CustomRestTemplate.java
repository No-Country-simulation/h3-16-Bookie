package com.Bookie.util;

import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

public class CustomRestTemplate extends RestTemplate {
    public CustomRestTemplate() {
        super(new HttpComponentsClientHttpRequestFactory());
    }
}
