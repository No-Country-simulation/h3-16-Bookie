package com.Bookie.dto;

import com.Bookie.entities.UserEntity;

public record UserReaderRequest(
       Long id,
       String name
) {
    public UserReaderRequest(UserEntity userId) {
        this(userId.getId(), userId.getName());
    }
}
