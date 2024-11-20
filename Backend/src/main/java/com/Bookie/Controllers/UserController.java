package com.Bookie.Controllers;

import com.Bookie.entities.UserEntity;
import com.Bookie.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/api/auth/sync")
    public ResponseEntity<String> getSyncInfo(Authentication authentication) {
        JwtAuthenticationToken jwtToken = (JwtAuthenticationToken) authentication;
        String userName = jwtToken.getName(); // O cualquier información que necesites
        return ResponseEntity.ok("Authenticated user: " + userName);
    }

    @GetMapping("/sync")
    public ResponseEntity<Map<String, Object>> getSyncInfo2(Authentication authentication) {
        JwtAuthenticationToken jwtToken = (JwtAuthenticationToken) authentication;
        Map<String, Object> tokenAttributes = jwtToken.getTokenAttributes();


        Map<String, Object> response = new HashMap<>();
        response.put("user_id", tokenAttributes.get("sub")); // Identificador del usuario
        response.put("email", tokenAttributes.get("email")); // Email del usuario
        response.put("name", tokenAttributes.get("name"));   // Nombre del usuario
        response.put("roles", tokenAttributes.get("roles")); // Roles (si están configurados en el token)
        response.put("custom_claims", tokenAttributes);      // Agrega todos los atributos si deseas verlos

        return ResponseEntity.ok(response);
    }

    //IMPORTANTE este metodo despues abria que quitarlo o hacerlo solo para administrador!
    @GetMapping("/users")
    public ResponseEntity<List<UserEntity>> getAllUsers(Authentication authentication) {
        List<UserEntity> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/user")
    public ResponseEntity<UserEntity> getAuthenticatedUser(Authentication authentication) {
        JwtAuthenticationToken jwtToken = (JwtAuthenticationToken) authentication;
        String auth0UserId = jwtToken.getTokenAttributes().get("sub").toString();

        UserEntity user = userService.getUserByAuth0Id(auth0UserId);

        if (user != null) {
            return ResponseEntity.ok(user);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}

