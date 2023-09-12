package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.entity.Course;
import java.util.List;
import java.util.UUID;

public interface CourseService {
    void save(CourseRegistRequestDto courseRegistRequestDto);

    List<Course> getCourseIdsByUserId(UUID userID);
}
