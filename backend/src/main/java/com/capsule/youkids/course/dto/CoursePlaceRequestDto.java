package com.capsule.youkids.course.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CoursePlaceRequestDto {

    private Integer placeId;
    private Integer order;

    @Builder
    public CoursePlaceRequestDto(Integer placeId, Integer order) {
        this.placeId = placeId;
        this.order = order;
    }
}
