package com.capsule.youkids.course.dto;

import com.capsule.youkids.course.entity.CourseMongo;
import java.util.List;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CourseResponseDto {

    private UUID courseId;
    private String courseName;
    private List<CourseMongo.PlaceItem> places;

}

