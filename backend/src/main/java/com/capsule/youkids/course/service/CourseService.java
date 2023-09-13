package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.DeleteCourseRequestDto;
import com.capsule.youkids.course.dto.CourseRequestDto;
import com.capsule.youkids.course.dto.DetailCourseResponseDto;
import com.capsule.youkids.course.dto.ModifyCourseRequestDto;
import java.util.List;
import java.util.UUID;

public interface CourseService {

    // 코스 저장
    boolean save(CourseRequestDto courseRequestDto);

    // 유저의 코스 불러오기
    List<DetailCourseResponseDto> getCourseIdsByUserId(UUID userId);

    // 코스 수정
    boolean update(ModifyCourseRequestDto modifyCourseRequestDto);

    // 코스 삭제
    boolean delete(DeleteCourseRequestDto deleteCourseRequestDto);
}
