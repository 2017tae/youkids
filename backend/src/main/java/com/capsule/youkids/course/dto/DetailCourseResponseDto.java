package com.capsule.youkids.course.dto;

import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DetailCourseResponseDto {

    private UUID courseId;
    private String courseName;
    private List<CoursePlaceItemResponseDto> places;

    @Builder
    public DetailCourseResponseDto(UUID courseId, String courseName, List<CoursePlaceItemResponseDto> places) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.places = places;
    }
}

