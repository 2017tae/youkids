package com.capsule.youkids.course.dto;

import com.capsule.youkids.course.entity.CourseMongo;
import com.capsule.youkids.course.entity.CourseMongo.PlaceItem;
import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CourseResponseDto {

    private UUID courseId;
    private String courseName;
    private List<CourseMongo.PlaceItem> places;

    @Builder
    public CourseResponseDto(UUID courseId, String courseName, List<PlaceItem> places) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.places = places;
    }
}

