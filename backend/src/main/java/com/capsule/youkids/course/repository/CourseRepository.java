package com.capsule.youkids.course.repository;

import com.capsule.youkids.course.entity.Course;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseRepository extends JpaRepository<Course, Integer> {
    List<Course> findAllByUser_UserId(UUID userId);
}
