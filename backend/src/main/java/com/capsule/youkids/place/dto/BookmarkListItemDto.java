package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookmarkListItemDto {

    int placeId;
    String name;
    String address;
    Double latitude;
    Double longitude;
    String category;

    public BookmarkListItemDto(Place place) {
        this.placeId = place.getPlaceId();
        this.name = place.getName();
        this.address = place.getAddress();
        this.latitude = place.getLatitude();
        this.longitude = place.getLongitude();
        this.category = place.getCategory();
    }
}
