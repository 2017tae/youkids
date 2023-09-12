package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CourseDeleteDto;
import com.capsule.youkids.course.dto.CoursePlaceRequestDto;
import com.capsule.youkids.course.dto.CourseRegistRequestDto;
import com.capsule.youkids.course.dto.CourseResponseDto;
import com.capsule.youkids.course.dto.CourseUpdateRequestDto;
import com.capsule.youkids.course.entity.Course;
import com.capsule.youkids.course.entity.CourseMongo;
import com.capsule.youkids.course.repository.CourseMongoRepository;
import com.capsule.youkids.course.repository.CourseRepository;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.repository.PlaceRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
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
    private final UserRepository userRepository;

    // 코스 저장하기
    @Override
    @Transactional
    public void save(CourseRegistRequestDto courseRegistRequestDto) {

        UUID courseId = UUID.randomUUID();

        List<CoursePlaceRequestDto> placeRequestDtos = courseRegistRequestDto.getPlaces();
        List<CourseMongo.PlaceItem> placeDtos = new ArrayList<>();
        int i = 0;
        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {
            Optional<Place> place = placeRepository.findById(placeRequestDto.getPlaceId());
            Place place1 = place.get();
            CourseMongo.PlaceItem place2 = CourseMongo.PlaceItem.builder()
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

        User user = userRepository.findByUserId(courseRegistRequestDto.getUserId()).get();

        Course course = Course.builder()
                .courseId(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .flag(false)
                .user(new User(user.getUserId(), user.getProvider(), user.getProviderId(), user.getEmail(), user.getRole()))
                .build();
        courseRepository.save(course);
    }


    // 유저의 코스 불러오기
    @Override
    public List<CourseResponseDto> getCourseIdsByUserId(UUID userId) {
        List<Course> courses = courseRepository.findAllByUser_UserId(userId);
        List<CourseResponseDto> courseResponseDtos = new ArrayList<>();

        for (Course course : courses) {
            if (course.getFlag() == true) {
                continue;
            }
            UUID courseId = course.getCourseId();

            CourseResponseDto courseResponseDto = courseMongoRepository.findByCourseId(courseId)
                    .get();
            courseResponseDtos.add(courseResponseDto);
        }
        return courseResponseDtos;
    }


    // 코스 수정하기
    @Override
    @Transactional
    public void update(CourseUpdateRequestDto courseUpdateRequestDto) {
        UUID courseId = courseUpdateRequestDto.getCourseId();

        Course course = courseRepository.findByCourseId(courseId).get();

        CourseMongo courseMongo = courseMongoRepository.findCourseMongoByCourseId(courseId).get();

        List<CoursePlaceRequestDto> placeRequestDtos = courseUpdateRequestDto.getPlaces();
        List<CourseMongo.PlaceItem> placeDtos = new ArrayList<>();
        int i = 0;
        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {
            Optional<Place> place = placeRepository.findById(placeRequestDto.getPlaceId());
            Place place1 = place.get();
            CourseMongo.PlaceItem placeDto = CourseMongo.PlaceItem.builder()
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
        CourseMongo courseMongoUpdate = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseUpdateRequestDto.getCourseName())
                .places(placeDtos)
                .build();
        courseMongoRepository.save(courseMongoUpdate);
        course.updateCourse(courseUpdateRequestDto.getCourseName(), course.getFlag());
    }


    // 코스 삭제하기
    @Override
    @Transactional
    public void delete(CourseDeleteDto courseDeleteDto) {
        Course course = courseRepository.findByCourseId(courseDeleteDto.getCourseId()).get();

        courseMongoRepository.deleteByCourseId(courseDeleteDto.getCourseId());
        course.updateCourse(course.getCourseName(), true);
    }
}
