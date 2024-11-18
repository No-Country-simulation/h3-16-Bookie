package com.Bookie.Controllers;

import com.Bookie.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/webhooks/auth0")
public class Auth0WebhookController {

    private final UserService userService;

    @Autowired
    public Auth0WebhookController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/user-created")
    public ResponseEntity<String> handleUserCreated(@RequestBody Map<String, Object> userData) {
        String auth0UserId = userData.get("user_id").toString();
        String email = userData.get("email").toString();
        String name = userData.containsKey("name") ? userData.get("name").toString() : "Unnamed User";

        // Sincroniza con la base de datos
        userService.saveUser(auth0UserId, email, name);

        return ResponseEntity.ok("User synchronized successfully.");
    }
}
