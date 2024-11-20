package com.Bookie.service;

import com.Bookie.entities.UserEntity;
import com.Bookie.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserService {

    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void syncUser(OAuth2AuthenticationToken authentication) {
        Map<String, Object> attributes = authentication.getPrincipal().getAttributes();
        String auth0UserId = attributes.get("sub").toString();
        String email = attributes.get("email").toString();
        String name = attributes.get("name").toString();

        userRepository.findByEmail(email).ifPresentOrElse(
                user -> {
                    // Actualiza datos si es necesario
                    user.setName(name);
                    userRepository.save(user);
                },
                () -> {
                    // Crea un nuevo usuario si no existe
                    UserEntity newUser = new UserEntity();
                    newUser.setAuth0UserId(auth0UserId);
                    newUser.setEmail(email);
                    newUser.setName(name);
                    //newUser.setPassword(""); // Opcional, ya que Auth0 maneja la autenticación
                    userRepository.save(newUser);
                }
        );
    }

    public void saveUser(String auth0UserId, String email, String name) {
        userRepository.findByEmail(email).ifPresentOrElse(
                user -> {
                    user.setName(name);
                    userRepository.save(user);
                },
                () -> {
                    UserEntity newUser = new UserEntity();
                    newUser.setAuth0UserId(auth0UserId);
                    newUser.setEmail(email);
                    newUser.setName(name);
                    userRepository.save(newUser);
                }
        );
    }

    // IMPORTANTE este metodo despues abria que borrarlo o hacerlo solo para admins
    public List<UserEntity> getAllUsers() {
        return userRepository.findAll();
    }

    public UserEntity getUserByAuth0Id(String auth0UserId) {
        return userRepository.findByAuth0UserId(auth0UserId).orElse(null);
    }
}
