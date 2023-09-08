package com.capsule.youkids.course.dto;


import com.capsule.youkids.place.entity.Place;
import java.util.List;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CourseRegistRequestDto {
    private String courseName;
    private UUID userId;
    private List<Place> places;
}
