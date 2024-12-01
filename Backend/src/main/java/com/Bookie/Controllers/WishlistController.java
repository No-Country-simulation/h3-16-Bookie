package com.Bookie.Controllers;

import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.dto.WishlistRequestCreate;
import com.Bookie.service.WishlistService;
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
@RequestMapping("/api/v1/wishlist")
@CrossOrigin("*")
@AllArgsConstructor
public class WishlistController {

    private WishlistService wishlistService;



    @PostMapping
    @Operation(
            summary = "Create a wishlist",
            description = "Create a new WishlistEntity",
            tags = {"WishlistEntity"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Wishlist created successfully",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = WishlistRequestCreate.class),
                            examples = @ExampleObject(name = "HistoryDtoRequest",
                                    value = "{\"id\": 1,\"title\": \"new title\", \"synopsis\": \"description of history\", \"creator_id\": 1,\"genre\": \"NOVEL\",\"img\": \"Base64:veryletterandnumber\",\"country\": \"ARGENTINA\",\"province\": \"BUENOS AIRES\"}")))
    })
    public ResponseEntity<?> crateWishlist(@RequestBody @Valid WishlistRequestCreate wishlist) {
        try {
            return ResponseEntity.status(HttpStatus.CREATED).body(wishlistService.createHistory(wishlist));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
        }
    }



    @GetMapping("/All/{id}")
    @Operation(
            summary = "Get wishlist",
            description = "Get wishlist by ID",
            tags = {"Wishlist"}
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Obtener historias de la lista de deseos",
                    content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = HistoryDtoResponse.class),
                            examples = @ExampleObject(name = "HistoryDtoResponse",
                                    value = "List<History>: { { \"id\": 1,\"title\": \"new title\", \"synopsis\": \"description of history\", \"creator_id\": 1,\"genre\": \"NOVEL\",\"img\": \"Base64:veryletterandnumber\",\"country\": \"ARGENTINA\",\"province\": \"BUENOS AIRES\"}, { \"id\": 2,\"title\": \"new title2\", \"synopsis\": \"description of history 2\", \"creator_id\": 1,\"genre\": \"NOVEL\",\"img\": \"Base64:veryletterandnumber 2\",\"country\": \"ARGENTINA\",\"province\": \"BUENOS AIRES\"} }")))
    })
    public ResponseEntity<?> getWishlist(@PathVariable Long id) {
        try {
            return ResponseEntity.status(HttpStatus.OK).body(wishlistService.getWishlist(id));
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", ex.getMessage()));

        }
    }
}
