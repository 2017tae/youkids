package com.capsule.youkids.place.dto;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewDeleteRequestDto {
    private int reviewId;
    private UUID userId;

    @Builder
    public ReviewDeleteRequestDto(int reviewId, UUID userId) {
        this.reviewId = reviewId;
        this.userId = userId;
    }
}
