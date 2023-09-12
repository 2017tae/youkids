package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import lombok.Builder;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class DetailPlaceResponseDto {

    private Place place;
    private boolean bookmarked;

    @Builder
    public DetailPlaceResponseDto(Place place, boolean bookmarked) {
        this.place = place;
        this.bookmarked = bookmarked;
    }
}
