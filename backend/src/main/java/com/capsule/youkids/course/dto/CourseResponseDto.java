package com.capsule.youkids.course.dto;

import java.util.List;

public class CourseResponseDto {
    private Integer courseId;
    private String courseName;
    private List<PlaceDto> places;

    public CourseResponseDto(Integer courseId, String courseName, List<PlaceDto> places) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.places = places;
    }

}

