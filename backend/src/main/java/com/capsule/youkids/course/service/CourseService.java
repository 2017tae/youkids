package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CourseDeleteDto;
import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.dto.CourseResponseDto;
import com.capsule.youkids.course.dto.CourseUpdateRequestDto;
import java.util.List;
import java.util.UUID;

public interface CourseService {

    // 코스 저장
    void save(CourseRegistRequestDto courseRegistRequestDto);

    // 유저의 코스 불러오기
    List<CourseResponseDto> getCourseIdsByUserId(UUID userID);

    // 코스 수정
    void update(CourseUpdateRequestDto courseUpdateRequestDto);

    // 코스 삭제
    void delete(CourseDeleteDto courseDeleteDto);
}
