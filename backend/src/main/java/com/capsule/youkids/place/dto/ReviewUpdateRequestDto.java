package com.capsule.youkids.place.dto;

import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewUpdateRequestDto {
    private int reviewId;
    private double score;
    private String description;
    private List<Integer> deletedImageIds;

    @Builder
    public ReviewUpdateRequestDto(int reviewId, double score, String description, UUID userId,
            List<Integer> deletedImageIds) {
        this.reviewId = reviewId;
        this.score = score;
        this.description = description;
        this.deletedImageIds = deletedImageIds;
    }
}
