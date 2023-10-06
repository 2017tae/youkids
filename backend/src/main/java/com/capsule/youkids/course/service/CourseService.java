package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.DeleteCourseRequestDto;
import com.capsule.youkids.course.dto.CourseRequestDto;
import com.capsule.youkids.course.dto.DetailCourseResponseDto;
import com.capsule.youkids.course.dto.ModifyCourseRequestDto;
import com.capsule.youkids.global.common.exception.RestApiException;
import java.util.List;
import java.util.UUID;

public interface CourseService {

    // 코스 저장
    void save(CourseRequestDto courseRequestDto) throws RestApiException;

    // 유저의 코스 불러오기
    List<DetailCourseResponseDto> getCourseIdsByUserId(UUID userId) throws RestApiException;

    // 코스 수정
    void update(ModifyCourseRequestDto modifyCourseRequestDto) throws RestApiException;

    // 코스 삭제
    void delete(DeleteCourseRequestDto deleteCourseRequestDto) throws RestApiException;
}
