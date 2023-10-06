package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.ReviewImage;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewImageInfoDto {

    private int reviewImageId;
    private String imageUrl;
    private int reviewId;

    public ReviewImageInfoDto(ReviewImage reviewImage) {
        this.reviewImageId = reviewImage.getReviewImageId();
        this.imageUrl = reviewImage.getImageUrl();
        this.reviewId = reviewImage.getReview().getReviewId();
    }
}
