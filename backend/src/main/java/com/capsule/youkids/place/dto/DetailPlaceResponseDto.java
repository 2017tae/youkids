package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DetailPlaceResponseDto {

    private PlaceInfoDto place;
    private boolean bookmarked;
    private List<ReviewInfoDto> reviews;
    private List<ReviewImageInfoDto> recentImages;

    @Builder
    public DetailPlaceResponseDto(PlaceInfoDto place, boolean bookmarked, List<ReviewInfoDto> reviews, List<ReviewImageInfoDto> recentImages) {
        this.place = place;
        this.bookmarked = bookmarked;
        this.reviews = reviews;
        this.recentImages = recentImages;
    }
}
