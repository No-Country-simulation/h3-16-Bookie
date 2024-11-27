package com.Bookie.dto;

import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.enums.GenreLiterary;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record HistoryDtoResponse(
        @NotBlank
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
        boolean publish,
        @NotBlank
        String country,
        @NotBlank
        String province
) {
        public HistoryDtoResponse(HistoryEntity historyEntity){
                this(historyEntity.getId(),historyEntity.getTitle(),historyEntity.getSyopsis(),historyEntity.getCreator(),
                        historyEntity.getGenre(),historyEntity.getImg(),historyEntity.getPublish(),
                        historyEntity.getCountries().getName(),historyEntity.getCountries().getProvinces().get(0).getName());
        }
}
