package com.capsule.youkids.place.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DetailPlaceResponseDto {

    private PlaceInfoDto place;
    private boolean bookmarked;

    @Builder
    public DetailPlaceResponseDto(PlaceInfoDto place, boolean bookmarked) {
        this.place = place;
        this.bookmarked = bookmarked;
    }
}
