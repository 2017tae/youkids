package com.capsule.youkids.course.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CoursePlaceItemResponseDto {

    private Integer placeId;
    private String name;
    private String address;
    private Double latitude;
    private Double longitude;
    private String category;
    private Integer order;

    @Builder
    public CoursePlaceItemResponseDto(Integer placeId, String name, String address, Double latitude,
            Double longitude,
            String category, Integer order) {
        this.placeId = placeId;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.category = category;
        this.order = order;
    }

}
