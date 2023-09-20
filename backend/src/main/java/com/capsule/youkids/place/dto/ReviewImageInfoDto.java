package com.capsule.youkids.place.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewImageInfoDto {

    private int reviewImageId;
    private String imageUrl;
    private int reviewId;

    @Builder
    public ReviewImageInfoDto(int reviewImageId, String imageUrl, int reviewId) {
        this.reviewImageId = reviewImageId;
        this.imageUrl = imageUrl;
        this.reviewId = reviewId;
    }
}
