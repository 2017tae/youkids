package com.capsule.youkids.course.dto;

import java.util.List;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CourseResponseDto {

    private UUID courseId;
    private String courseName;
    private List<PlaceDto> places;

    public CourseResponseDto(UUID courseId, String courseName, List<PlaceDto> places) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.places = places;
    }
}

