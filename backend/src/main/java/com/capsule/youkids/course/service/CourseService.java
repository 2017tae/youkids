package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CoursePlaceRegistRequestDto;
import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.dto.PlaceDto;
import com.capsule.youkids.course.entity.Course;
import com.capsule.youkids.course.entity.CourseMongo;
import com.capsule.youkids.course.repository.CourseMongoRepository;
import com.capsule.youkids.course.repository.CourseRepository;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.repository.PlaceRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.data.crossstore.ChangeSetPersister.NotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CourseService {

    private final CourseRepository courseRepository;
    private final CourseMongoRepository courseMongoRepository;
    private final PlaceRepository placeRepository;

    @Transactional
    public void save(CourseRegistRequestDto courseRegistRequestDto){

        UUID courseId = UUID.randomUUID();

        List<CoursePlaceRegistRequestDto> placeDtos = courseRegistRequestDto.getPlaces();
        List<PlaceDto> list = new ArrayList<>();
        for (int i = 0; i< placeDtos.size(); i++) {
            Optional<Place> place = placeRepository.findById(placeDtos.get(i).getPlaceId());
            Place place1 = place.get();
            PlaceDto place2 = place1.toMongoDto(place1, i+1);
            list.add(place2);
        }
        CourseMongo mongo = CourseMongo.builder()
                .course_id(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .places(list).build();
        courseMongoRepository.save(mongo);

        Course course = new Course(courseRegistRequestDto, courseId);
        courseRepository.save(course);
    }

}
