package com.Bookie.dto;

import com.Bookie.enums.GenreLiterary;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryDtoRequestUpdate(

        String title,

        String synopsis,

        GenreLiterary genre,
        String img

) {

}
