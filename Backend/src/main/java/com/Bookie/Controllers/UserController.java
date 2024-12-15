package com.Bookie.Controllers;


import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.dto.UserWithHistoriesDTO;
import com.Bookie.entities.UserEntity;
import com.Bookie.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin("*")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    //este endpoint esta en duda...
    @GetMapping("/api/auth/sync")
    public ResponseEntity<String> getSyncInfo(Authentication authentication) {
        JwtAuthenticationToken jwtToken = (JwtAuthenticationToken) authentication;
        String userName = jwtToken.getName(); // O cualquier información que necesites
        return ResponseEntity.ok("Authenticated user: " + userName);
    }

    /**
     *
     * @param authentication
     * @return
     */
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


    /**
     *
     *
     *
     * @param authentication
     * @return
     */
    //IMPORTANTE este metodo despues abria que quitarlo o hacerlo solo para administrador!
    @GetMapping("/users")
    public ResponseEntity<List<UserWithHistoriesDTO>> getAllUsersWithHistoriesAndChapters() {
        List<UserWithHistoriesDTO> users = userService.getAllUsersWithHistoriesAndChapters();
        return ResponseEntity.ok(users);
    }

    /**
     *
     * @param authentication
     * @return
     */

    @Operation(
            summary = "get user",
            description = "get a user from postgresql from a token",
            tags = {"User"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Get user Succesfully",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = Authentication.class),
                            examples = @ExampleObject(name = "history",
                                    value = "{\"id\": 1,\"name\": \"Jorge\", \"email\": \"test@test.com\", \"auth0UserId\": google-oauth2|123456789\"}")))
    })
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

