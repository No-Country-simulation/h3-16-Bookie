package com.Bookie.dto;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.enums.GenreLiterary;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryReaderResponse(@NotBlank
                                    Long id,
                                    @NotBlank
                                    String title,
                                    @NotBlank
                                    String syopsis,
                                    @NotNull
                                    UserEntity creator_id,
                                    @NotNull
                                    GenreLiterary genre,
                                    String img,

                                    @NotBlank
                                    String country,
                                    @NotBlank
                                    String province) {
    public HistoryReaderResponse(HistoryEntity historyId) {
        this(historyId.getId(), historyId.getTitle(), historyId.getSyopsis(), historyId.getCreator(),
                historyId.getGenre(), historyId.getImg(),historyId.getProvince().getCountry().getName(),historyId.getProvince().getName() );
    }
}
