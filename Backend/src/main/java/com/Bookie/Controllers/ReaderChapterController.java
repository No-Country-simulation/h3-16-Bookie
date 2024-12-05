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
import org.springframework.web.bind.annotation.*;

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
                                    value =   "{ \"id\": 302, \"reader\": { \"id\": 402, \"complete\": false }, \"chapter\": { \"id\": 2, \"title\": \"capitulo 2\", \"content\": \"En un bosque se encontraron dos personas 2\", \"latitude\": 35.6037, \"longitude\": 56.3816, \"img\": \"imagen.jpg\" }, \"complete\": false }"
                            )))
    })
    public ResponseEntity<?> readerReaderChapter(@RequestBody @Valid ReaderChapterDto readerChapterDto) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(readerChapterService.createReaer(readerChapterDto));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
        }
    }

    @PatchMapping("/{id}")
    @Operation(
            summary = "read a chapter a ReaderChapter",
            description = "Convert to true  complete of ReaderChapterEntity",
            tags = {"Reader-Chapter"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "202", description = "Creating a new chapter of a story for reader",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = ReaderChapterDto.class),
                            examples = @ExampleObject(name = "HistoryDtoRequest",
                                    value =   "{ \"id\": 302, \"reader\": { \"id\": 402, \"complete\": false/true }, \"chapter\": { \"id\": 2, \"title\": \"capitulo 2\", \"content\": \"En un bosque se encontraron dos personas 2\", \"latitude\": 35.6037, \"longitude\": 56.3816, \"img\": \"imagen.jpg\" }, \"complete\": true }"

                            )))
    })
    public ResponseEntity<?> publishReaderChapter(@PathVariable  Long id) {
        try {
            return ResponseEntity.status(HttpStatus.ACCEPTED).body(readerChapterService.publishReaderChapter(id));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", ex.getMessage()));
        }
    }

}
