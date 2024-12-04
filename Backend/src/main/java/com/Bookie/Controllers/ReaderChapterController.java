package com.Bookie.Controllers;

import com.Bookie.dto.ReaderChapterDto;
import com.Bookie.dto.ReaderCreateRequest;
import com.Bookie.service.ReaderChapterService;
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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

@Controller
@RequestMapping("/api/v1/reader-chapter")
@AllArgsConstructor
@CrossOrigin("*")
public class ReaderChapterController {

    private ReaderChapterService readerChapterService;

    @PostMapping
    @Operation(
            summary = "Create a ReaderChapter",
            description = "Create a new ReaderChapterEntity",
            tags = {"Reader-Chapter"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Creating a new chapter of a story for reader",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ReaderChapterDto.class),
                            examples = @ExampleObject(name = "HistoryDtoRequest",
                                    value = "{\"id\":352,\"user\":{\"id\":1,\"name\":\"Osecactest\"},\"history\":{\"id\":58,\"title\":\"La leyenda del MAGO 2\",\"syopsis\":\"Una aventura épica sobre un MAGO y su MAGIA divina.\",\"publish\":false,\"genre\":\"FANTASIA\",\"img\":\"http://imagen-del-dragon.jpg/\",\"chapters\":[]},\"complete\":false}"


                            )))
    })
    public ResponseEntity<?> createReaderChapter(@RequestBody @Valid ReaderChapterDto readerChapterDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(readerChapterService.createReaer(readerChapterDto));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
        }
    }

}
