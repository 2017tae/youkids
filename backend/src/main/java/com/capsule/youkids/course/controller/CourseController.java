package com.capsule.youkids.course.controller;

import com.capsule.youkids.course.dto.DeleteCourseRequestDto;
import com.capsule.youkids.course.dto.CourseRequestDto;
import com.capsule.youkids.course.dto.DetailCourseResponseDto;
import com.capsule.youkids.course.dto.ModifyCourseRequestDto;
import com.capsule.youkids.course.service.CourseService;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/course")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;

    @PostMapping("")
    public ResponseEntity<?> saveCourse(
            @RequestBody CourseRequestDto courseRequestDto) {
        boolean check = courseService.save(courseRequestDto);

        if (check) {
            return new ResponseEntity<>("등록 성공", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("등록 실패", HttpStatus.BAD_REQUEST);
        }

    }

    @GetMapping("/{userId}")
    public ResponseEntity<?> getCourse(
            @PathVariable("userId") UUID userId) {
        List<DetailCourseResponseDto> response = courseService.getCourseIdsByUserId(userId);

        if (response.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            return new ResponseEntity<>(response, HttpStatus.OK);
        }
    }

    @PutMapping("")
    public ResponseEntity<?> updateCourse(
            @RequestBody ModifyCourseRequestDto modifyCourseRequestDto) {
        boolean check = courseService.update(modifyCourseRequestDto);

        if (check) {
            return new ResponseEntity<>("수정 성공", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("수정 실패", HttpStatus.BAD_REQUEST);
        }
    }

    @DeleteMapping("")
    public ResponseEntity<?> deleteCourse(
            @RequestBody DeleteCourseRequestDto deleteCourseRequestDto) {
        boolean check = courseService.delete(deleteCourseRequestDto);

        if (check) {
            return new ResponseEntity<>("삭제 성공", HttpStatus.OK);
        } else {
            return new ResponseEntity<>("삭제 실패", HttpStatus.BAD_REQUEST);
        }
    }
}
