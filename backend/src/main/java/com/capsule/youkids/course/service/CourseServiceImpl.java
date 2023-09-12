package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CoursePlaceRequestDto;
import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.dto.CourseResponseDto;
import com.capsule.youkids.course.dto.CourseUpdateRequestDto;
import com.capsule.youkids.course.dto.PlaceDto;
import com.capsule.youkids.course.entity.Course;
import com.capsule.youkids.course.entity.CourseMongo;
import com.capsule.youkids.course.repository.CourseMongoRepository;
import com.capsule.youkids.course.repository.CourseRepository;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.repository.PlaceRepository;
import com.capsule.youkids.user.entity.User;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final CourseMongoRepository courseMongoRepository;
    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public void save(CourseRegistRequestDto courseRegistRequestDto) {

        UUID courseId = UUID.randomUUID();

        List<CoursePlaceRequestDto> placeRequestDtos = courseRegistRequestDto.getPlaces();
        List<PlaceDto> placeDtos = new ArrayList<>();
        int i = 0;
        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {
            Optional<Place> place = placeRepository.findById(placeRequestDto.getPlaceId());
            Place place1 = place.get();
            PlaceDto place2 = PlaceDto.builder()
                    .placeId(place1.getPlaceId())
                    .name(place1.getName())
                    .latitude(place1.getLatitude())
                    .longitude(place1.getLongitude())
                    .address(place1.getAddress())
                    .category(place1.getCategory())
                    .order(i + 1)
                    .build();
            placeDtos.add(place2);
            i++;
        }
        CourseMongo mongo = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .places(placeDtos)
                .build();
        courseMongoRepository.save(mongo);

        Course course = Course.builder()
                .courseId(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .flag(false)
                .user(new User(courseRegistRequestDto.getUserId()))
                .build();
        courseRepository.save(course);
    }

    @Override
    public List<CourseResponseDto> getCourseIdsByUserId(UUID userId) {
        List<Course> courses = courseRepository.findAllByUser_UserId(userId);
        List<CourseResponseDto> courseResponseDtos = new ArrayList<>();

        for (Course course : courses) {
            UUID courseId = course.getCourseId();
            CourseResponseDto courseResponseDto = courseMongoRepository.findByCourseId(courseId)
                    .get();
            courseResponseDtos.add(courseResponseDto);
        }
        return courseResponseDtos;
    }

    @Override
    @Transactional
    public void update(CourseUpdateRequestDto courseUpdateRequestDto) {
        UUID courseId = courseUpdateRequestDto.getCourseId();

        CourseResponseDto courseResponseDto = courseMongoRepository.findByCourseId(courseId).get();

        List<CoursePlaceRequestDto> placeRequestDtos = courseUpdateRequestDto.getPlaces();
        List<PlaceDto> placeDtos = new ArrayList<>();
        int i = 0;
        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {
            Optional<Place> place = placeRepository.findById(placeRequestDto.getPlaceId());
            Place place1 = place.get();
            PlaceDto placeDto = PlaceDto.builder()
                    .placeId(place1.getPlaceId())
                    .name(place1.getName())
                    .address(place1.getAddress())
                    .category(place1.getCategory())
                    .latitude(place1.getLatitude())
                    .longitude(place1.getLongitude())
                    .order(i + 1)
                    .build();
            i++;
            placeDtos.add(placeDto);
        }
        CourseMongo courseMongo = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseResponseDto.getCourseName())
                .places(placeDtos)
                .build();

        courseMongoRepository.save(courseMongo);
    }
}
