package com.capsule.youkids.place.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Getter
public class TopReviewPlacesDto {
    List<PlaceRecommItemDto> mixed;
    List<PlaceRecommItemDto> themeParks;
    List<PlaceRecommItemDto> kidsCafe;
    List<PlaceRecommItemDto> museum;

    @Builder
    public TopReviewPlacesDto(List<PlaceRecommItemDto> mixed,
            List<PlaceRecommItemDto> themeParks,
            List<PlaceRecommItemDto> kidsCafe,
            List<PlaceRecommItemDto> museum) {
        this.mixed = mixed;
        this.themeParks = themeParks;
        this.kidsCafe = kidsCafe;
        this.museum = museum;
    }
}
