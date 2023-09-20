package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PlaceRecommDto {
    private List<PlaceInfoDto> places;

    @Builder
    public PlaceRecommDto(List<PlaceInfoDto> places) {
        this.places = places;
    }
}
