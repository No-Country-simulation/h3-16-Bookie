package com.Bookie.testController;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class TestController {

    // Endpoint público (accesible sin autenticación)
    @GetMapping("/public")
    public String publicEndpoint() {
        return "Este es un endpoint público y no requiere autenticación.";
    }

    // Endpoint protegido (requiere autenticación)
    @GetMapping("/protected")
    public String protectedEndpoint() {
        return "Este es un endpoint protegido y requiere autenticación.";
    }
}