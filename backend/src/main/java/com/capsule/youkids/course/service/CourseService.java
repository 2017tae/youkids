package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.repository.CourseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository courseRepository;

    @Transactional
    public void registCourse(CourseRegistRequestDto courseRegistRequestDto){

    }
}
