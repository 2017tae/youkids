package com.capsule.youkids.place.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class BookmarkListItemDto {

    int placeId;
    String name;
    String address;
    double latitude;
    double longitude;
    String category;

    @Builder
    public BookmarkListItemDto(int placeId, String name, String address, double latitude,
            double longitude, String category) {
        this.placeId = placeId;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.category = category;
    }
}
