package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.entity.TopReviewPlace;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PlaceRecommItemDto {

    private int placeId;
    private String name;
    private String address;
    private String category;
    private String imageUrl;

    public PlaceRecommItemDto(Place place) {
        this.placeId = place.getPlaceId();
        this.name = place.getName();
        this.address = place.getAddress();
        this.category = place.getCategory();
        this.imageUrl = place.getImages().isEmpty() ? "" : place.getImages().get(0).getUrl();
    }

    public PlaceRecommItemDto(TopReviewPlace place) {
        this.placeId = place.getPlaceId();
        this.name = place.getName();
        this.address = place.getAddress();
        this.category = place.getCategory();
        this.imageUrl = place.getImageUrl();
    }
}
