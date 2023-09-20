package com.capsule.youkids.place.dto;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewWriteRequestDto {
    private int placeId;
    private UUID userId;
    private double score;
    private String description;

    @Builder
    public ReviewWriteRequestDto(int placeId, UUID userId, double score, String description) {
        this.placeId = placeId;
        this.userId = userId;
        this.score = score;
        this.description = description;
    }
}
