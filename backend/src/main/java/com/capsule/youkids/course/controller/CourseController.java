package com.capsule.youkids.course.controller;

import com.capsule.youkids.course.dto.DeleteCourseRequestDto;
import com.capsule.youkids.course.dto.CourseRequestDto;
import com.capsule.youkids.course.dto.ModifyCourseRequestDto;
import com.capsule.youkids.course.service.CourseService;
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.response.BaseResponse;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/course")
@RequiredArgsConstructor
public class CourseController {

    private final CourseService courseService;

    @PostMapping("")
    public BaseResponse saveCourse(
            @RequestBody CourseRequestDto courseRequestDto) {
        try {
            courseService.save(courseRequestDto);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    @GetMapping("/{userId}")
    public BaseResponse getCourse(
            @PathVariable("userId") UUID userId) {
        try {
            return BaseResponse.success(Code.SUCCESS, courseService.getCourseIdsByUserId(userId));
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    @PutMapping("")
    public BaseResponse updateCourse(
            @RequestBody ModifyCourseRequestDto modifyCourseRequestDto) {
        try {
            courseService.update(modifyCourseRequestDto);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    @DeleteMapping("")
    public BaseResponse deleteCourse(
            @RequestBody DeleteCourseRequestDto deleteCourseRequestDto) {
        try {
            courseService.delete(deleteCourseRequestDto);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }
}
