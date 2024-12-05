package com.Bookie.Controllers;

import com.Bookie.dto.ReaderCreateRequest;
import com.Bookie.dto.WishlistRequestCreate;
import com.Bookie.service.ReaderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("api/v1/reader")
@CrossOrigin("*")
@AllArgsConstructor
public class ReaderController {

    private final ReaderService readerService;

    @PostMapping
    @Operation(
            summary = "Create a reader",
            description = "Create a new ReaderEntity",
            tags = {"Reader"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Creating a new reading of a story",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ReaderCreateRequest.class),
                            examples = @ExampleObject(name = "HistoryDtoRequest",
                                    value =  "{\"id\":352,\"user\":{\"id\":1,\"name\":\"Osecactest\"},\"history\":{\"id\":58,\"title\":\"La leyenda del MAGO 2\",\"syopsis\":\"Una aventura épica sobre un MAGO y su MAGIA divina.\",\"publish\":false,\"genre\":\"FANTASIA\",\"img\":\"http://imagen-del-dragon.jpg/\",\"chapters\":[]},\"complete\":false}"


                            )))
    })
    public ResponseEntity<?> createReader (@RequestBody @Valid ReaderCreateRequest readerCreateRequest){
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(readerService.createReaer(readerCreateRequest));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
        }
    }


    @GetMapping("/{id}")
    @Operation(
            summary = "get a reader",
            description = "get reader by user id",
            tags = {"Reader"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "get all history reader of user",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ReaderCreateRequest.class),
                            examples = @ExampleObject(name = "HistoryDtoRequest",
                                    value =  "{\"id\":352,\"user\":{\"id\":1,\"name\":\"Osecactest\"},\"history\":{\"id\":58,\"title\":\"La leyenda del MAGO 2\",\"syopsis\":\"Una aventura épica sobre un MAGO y su MAGIA divina.\",\"publish\":false,\"genre\":\"FANTASIA\",\"img\":\"http://imagen-del-dragon.jpg/\",\"chapters\":[]},\"complete\":false}"


                            )))
    })
    public ResponseEntity<?> getReaderByUserId (@PathVariable Long id){
        try {
            return ResponseEntity.status(HttpStatus.OK).body(readerService.getReaderByUserId(id));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", ex.getMessage()));
        }
    }
}
