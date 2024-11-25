package com.Bookie.Controllers;

import com.Bookie.enums.GenreLiterary;
import io.swagger.v3.oas.annotations.Operation;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("api/v1/genre")
@CrossOrigin("*")
@AllArgsConstructor
public class GenreController {

    @GetMapping
    @Operation(
            summary = "List all genre",
            description = "List all registered genre literary",
            tags = {"Genre enum"})
    public ResponseEntity getAllgenre() {

        return ResponseEntity.status(HttpStatus.OK).body(GenreLiterary.getGenreList());

    }
}
