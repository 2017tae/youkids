package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.entity.ReviewImage;
import com.capsule.youkids.user.entity.User;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import lombok.Builder;
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

    @Builder
    public ReviewInfoDto(int reviewId, double score, String description, UUID userId,
            List<String> images) {
        this.reviewId = reviewId;
        this.score = score;
        this.description = description;
        this.userId = userId;
        this.images = images;
    }
}
