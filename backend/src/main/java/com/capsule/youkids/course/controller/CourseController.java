package com.capsule.youkids.course.controller;

import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.entity.Course;
import com.capsule.youkids.course.service.CourseServiceImpl;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    private final CourseServiceImpl courseService;

    @PostMapping("")
    public ResponseEntity<String> save(@RequestBody CourseRegistRequestDto courseRegistRequestDto){
        courseService.save(courseRegistRequestDto);
        return new ResponseEntity<>("success",HttpStatus.OK);
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<Course>> getCourse(@PathVariable("userId") UUID userId){
        return new ResponseEntity<>(courseService.getCourseIdsByUserId(userId), HttpStatus.OK);
    }
}
