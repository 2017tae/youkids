package com.capsule.youkids.place.dto;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookmarkRequestDto {

    private UUID userId;
    private int placeId;
    private boolean flag;

    @Builder
    public BookmarkRequestDto(UUID userId, int placeId, boolean flag) {
        this.userId = userId;
        this.placeId = placeId;
        this.flag = flag;
    }
}
