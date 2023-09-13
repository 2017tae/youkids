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
    @Transactional
    public void save(CourseRegistRequestDto courseRegistRequestDto) {

        // mongoDB와 RDBMS에 UUID courseID를 동일하게 유지
        UUID courseId = UUID.randomUUID();

        // 요청된 값에서 place 값만 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = courseRegistRequestDto.getPlaces();

        // mongoDB에 저장할 코스 아이템
        List<CourseMongo.PlaceItem> placeItems = new ArrayList<>();

        // 코스의 order(순서)
        int i = 0;

        // 리스트의 place 값들의 id로 place 정보를 조회 후 placeItem 생성
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
            placeItems.add(place2);
            i++;
        }

        // mongoDB에 저장할 코스 정보 생성
        CourseMongo mongo = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 코스 정보 저장
        courseMongoRepository.save(mongo);

        // 유저 정보 불러오기
        User user = userRepository.findByUserId(courseRegistRequestDto.getUserId()).get();

        // RDBMS에 저장할 코스 정보 생성
        Course course = Course.builder()
                .courseId(courseId)
                .courseName(courseRegistRequestDto.getCourseName())
                .flag(false)
                .user(new User(user.getUserId(), user.getProvider(), user.getProviderId(),
                        user.getEmail(), user.getRole()))
                .build();

        // RDBMS에 코스 저장
        courseRepository.save(course);

        // 유저의 코스 갯수 한개 증가
        user.changeCourseCount(1);
    }


    // 유저의 코스 불러오기
    public List<CourseResponseDto> getCourseIdsByUserId(UUID userId) {

        // 유저의 모든 코스 불러오기
        List<Course> courses = courseRepository.findAllByUser_UserId(userId);

        // 반환할 값을 저장할 리스트 생성
        List<CourseResponseDto> courseResponseDtos = new ArrayList<>();

        for (Course course : courses) {

            // 이미 삭제된 코스면 코스를 조회하지 않음
            if (course.getFlag() == true) {
                continue;
            }

            // mongoDB에서 해당 코스 아이디 조회
            CourseMongo courseMongo = courseMongoRepository.findByCourseId(course.getCourseId())
                    .get();

            // 조회된 데이터를 dto로 변환
            CourseResponseDto courseResponseDto = CourseResponseDto.builder()
                    .courseId(courseMongo.getCourseId())
                    .courseName(courseMongo.getCourseName())
                    .places(courseMongo.getPlaces())
                    .build();

            // 리스트에 dto 저장
            courseResponseDtos.add(courseResponseDto);
        }

        return courseResponseDtos;
    }


    // 코스 수정하기
    @Transactional
    public void update(CourseUpdateRequestDto courseUpdateRequestDto) {

        // mongoDB, RDBMS를 조회할 UUID courseId를 불러오기
        UUID courseId = courseUpdateRequestDto.getCourseId();

        // RDBMS, mongoDB에서 해당 코스 조회
        Course course = courseRepository.findByCourseId(courseId).get();
        CourseMongo courseMongo = courseMongoRepository.findCourseMongoByCourseId(courseId).get();

        // 요청받은 dto 중 place정보 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = courseUpdateRequestDto.getPlaces();

        // mongoDB에 저장할 placeItem 리스트 생성
        List<CourseMongo.PlaceItem> placeItems = new ArrayList<>();

        // 순서(order)
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
            placeItems.add(placeDto);
        }
        CourseMongo courseMongoUpdate = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseUpdateRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 수정(저장)
        courseMongoRepository.save(courseMongoUpdate);

        // RDBMS에 수정( Transactional 어노테이션 활용)
        course.updateCourse(courseUpdateRequestDto.getCourseName());
    }


    // 코스 삭제하기
    @Transactional
    public void delete(CourseDeleteDto courseDeleteDto) {

        // 삭제할 코스 정보 불러오기
        Course course = courseRepository.findByCourseId(courseDeleteDto.getCourseId()).get();

        // 불러온 코스 정보에서 유저 정보 불러오기
        User user = course.getUser();

        // mongoDB에서 코스 정보 삭제
        courseMongoRepository.deleteByCourseId(courseDeleteDto.getCourseId());

        // RDBMS에 수정(flag => true, Transactional 어노테이션 활용)
        course.deleteCourse();

        // 유저의 코스 갯수에서 한개 차감
        user.changeCourseCount(-1);

    }
}
