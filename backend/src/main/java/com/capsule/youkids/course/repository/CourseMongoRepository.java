package com.capsule.youkids.course.repository;

import com.capsule.youkids.course.entity.CourseMongo;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface CourseMongoRepository extends MongoRepository<CourseMongo, Integer> {

}
