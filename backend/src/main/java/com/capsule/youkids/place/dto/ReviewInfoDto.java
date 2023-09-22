package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Review;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReviewInfoDto {
    private int reviewId;
    private double score;
    private String description;
    private UUID userId;
    private List<String> images;

    public ReviewInfoDto(Review review) {
        this.reviewId = review.getReviewId();
        this.score = review.getScore();
        this.description = review.getDescription();
        this.userId = review.getUser().getUserId();
        this.images = review.getImages().stream().map((image)->{return image.getImageUrl();}).collect(
                Collectors.toList());
    }
}
