package com.capsule.youkids.course.controller;

import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.entity.Course;
import com.capsule.youkids.course.service.CourseService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/course")
@RequiredArgsConstructor
public class CourseController {
    private final CourseService courseService;

    @PostMapping("")
    public void save(@RequestBody CourseRegistRequestDto courseRegistRequestDto){
        courseService.save(courseRegistRequestDto);
    }

    @GetMapping("/{userId}")
    public List<Course> getCourse(@PathVariable("userId") UUID userId) throws Exception {
        return courseService.getCourseIdsByUserId(userId);
    }
}
