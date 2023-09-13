package com.capsule.youkids.course.dto;


import java.util.List;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ModifyCourseRequestDto {

    private UUID courseId;
    private String courseName;
    private List<CoursePlaceRequestDto> places;

}
