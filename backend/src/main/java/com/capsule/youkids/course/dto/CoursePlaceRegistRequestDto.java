package com.capsule.youkids.course.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CoursePlaceRegistRequestDto {

    private Integer placeId;
    private Integer order;

    @Builder
    public CoursePlaceRegistRequestDto(Integer placeId, Integer order) {
        this.placeId = placeId;
        this.order = order;
    }
}
