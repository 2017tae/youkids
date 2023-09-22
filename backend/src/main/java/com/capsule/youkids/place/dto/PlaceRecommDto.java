package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PlaceRecommDto {
    private List<PlaceRecommItemDto> places;

    @Builder
    public PlaceRecommDto(List<PlaceRecommItemDto> places) {
        this.places = places;
    }
}
