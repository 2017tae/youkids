package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.dto.CourseResponseDto;
import com.capsule.youkids.course.dto.CourseUpdateRequestDto;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface CourseService {

    void save(CourseRegistRequestDto courseRegistRequestDto);

    List<CourseResponseDto> getCourseIdsByUserId(UUID userID);

    void update(CourseUpdateRequestDto courseUpdateRequestDto);
}
