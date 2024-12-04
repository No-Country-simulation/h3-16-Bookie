package com.Bookie.dto;

import com.Bookie.entities.ChapterEntity;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.ReaderEntity;
import com.Bookie.entities.UserEntity;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record ReaderRequest(
        @NotNull
        Long id,
        @NotNull
        UserReaderRequest user,
        @NotNull
        HistoryEntity history,
        @NotBlank
        Boolean complete,
        List<ChapterEntity> chapters
) {
        public ReaderRequest(ReaderEntity reader) {
                this(reader.getId(),new UserReaderRequest(reader.getUserId() ),
                        reader.getHistoryId() ,reader.getComplete(),null);
        }
}
