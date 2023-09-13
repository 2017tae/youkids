package com.capsule.youkids.course.dto;


import java.util.List;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CourseRequestDto {

    private String courseName;
    private UUID userId;
    private List<CoursePlaceRequestDto> places;

}
