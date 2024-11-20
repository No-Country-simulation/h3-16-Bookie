package com.Bookie.Controllers;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.service.HistoryService;
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
@RequestMapping("api/v1/history")
@CrossOrigin("*")
@AllArgsConstructor
public class HistoryController {

    private final HistoryService historyService;



    @PostMapping
    @Operation(
            summary = "Create a history",
            description = "Create a new history",
            tags = {"History"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "History created successfully",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = HistoryDtoRequest.class),
                            examples = @ExampleObject(name = "history",
                                     value = "{\"id\": 1,\"title\": \"new title\", \"synopsis\": \"description of history\", \"creator_id\": 1,\"genre\": \"NOVEL\",\"img\": \"Base64:veryletterandnumber\"}")))
    })
    public ResponseEntity<?> crateHistory(@RequestBody @Valid HistoryDtoRequest historyDto) {
        try {
return ResponseEntity.status(HttpStatus.CREATED).body(historyService.createHistory(historyDto));
        } catch (Exception ex){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error",ex.getMessage()));
        }
    }



    @GetMapping("/all")
    @Operation(
            summary = "List all histories",
            description = "List all registered histories",
            tags = {"History"}
    )
    public ResponseEntity<?> getAllHistoties() {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(historyService.getAll());
        } catch (Exception ex){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error",ex.getMessage()));
        }
    }
}
