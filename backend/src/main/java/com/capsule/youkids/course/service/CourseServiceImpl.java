package com.capsule.youkids.course.service;

import com.capsule.youkids.course.dto.CoursePlaceItemResponseDto;
import com.capsule.youkids.course.dto.DeleteCourseRequestDto;
import com.capsule.youkids.course.dto.CoursePlaceRequestDto;
import com.capsule.youkids.course.dto.CourseRequestDto;
import com.capsule.youkids.course.dto.DetailCourseResponseDto;
import com.capsule.youkids.course.dto.ModifyCourseRequestDto;
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
    public boolean save(CourseRequestDto courseRequestDto) {

        // mongoDB와 RDBMS에 UUID courseID를 동일하게 유지
        UUID courseId = UUID.randomUUID();

        // 요청된 값에서 place(placeId, order)값만 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = courseRequestDto.getPlaces();

        // mongoDB에 저장할 코스 아이템
        List<CourseMongo.PlaceItem> placeItems = new ArrayList<>();

        // 리스트의 place 값들의 id로 place 정보를 조회 후 placeItem 생성
        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {

            // placeId로 place 조회
            Optional<Place> place = placeRepository.findById(placeRequestDto.getPlaceId());
            Place place1 = place.get();

            // place를 통해 내부 클래스인 placeItem 생성
            CourseMongo.PlaceItem place2 = CourseMongo.PlaceItem.builder()
                    .placeId(place1.getPlaceId())
                    .name(place1.getName())
                    .latitude(place1.getLatitude())
                    .longitude(place1.getLongitude())
                    .address(place1.getAddress())
                    .category(place1.getCategory())
                    .order(placeRequestDto.getOrder())
                    .build();

            // placeItem 리스트에 저장
            placeItems.add(place2);
        }

        // mongoDB에 저장할 코스 정보 생성
        CourseMongo mongo = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 코스 정보 저장
        courseMongoRepository.save(mongo);

        // 유저 정보 불러오기
        User user = userRepository.findByUserId(courseRequestDto.getUserId()).get();

        // RDBMS에 저장할 코스 정보 생성
        Course course = Course.builder()
                .courseId(courseId)
                .courseName(courseRequestDto.getCourseName())
                .flag(false)
                .user(new User(user.getUserId(), user.getProvider(), user.getProviderId(),
                        user.getEmail(), user.getRole()))
                .build();

        // RDBMS에 코스 저장
        courseRepository.save(course);

        // 유저의 코스 갯수 한개 증가
        user.changeCourseCount(1);

        return true;
    }


    // 유저의 코스 불러오기
    public List<DetailCourseResponseDto> getCourseIdsByUserId(UUID userId) {

        // 유저의 모든 코스 불러오기
        List<Course> courses = courseRepository.findAllByUser_UserId(userId);

        // 반환할 값을 저장할 리스트 생성
        List<DetailCourseResponseDto> detailCourseResponseDtos = new ArrayList<>();

        for (Course course : courses) {

            // 이미 삭제된 코스면 코스를 조회하지 않음
            if (course.getFlag() == true) {
                continue;
            }

            // mongoDB에서 해당 코스 아이디 조회
            CourseMongo courseMongo = courseMongoRepository.findByCourseId(course.getCourseId())
                    .get();

            // 코스의 placeItemResponse 를 담을 리스트 생성
            List<CoursePlaceItemResponseDto> coursePlaceItemResponseDtos = new ArrayList<>();

            // CourseMongo를 CoursePlaceListResponseDto 로 변환
            for (CourseMongo.PlaceItem placeItem : courseMongo.getPlaces()) {
                CoursePlaceItemResponseDto coursePlaceItemResponseDto = CoursePlaceItemResponseDto.builder()
                        .placeId(placeItem.getPlaceId())
                        .name(placeItem.getName())
                        .address(placeItem.getAddress())
                        .category(placeItem.getCategory())
                        .latitude(placeItem.getLatitude())
                        .longitude(placeItem.getLongitude())
                        .order(placeItem.getOrder())
                        .build();

                coursePlaceItemResponseDtos.add(coursePlaceItemResponseDto);
            }

            // 조회된 데이터를 dto로 변환
            DetailCourseResponseDto detailCourseResponseDto = DetailCourseResponseDto.builder()
                    .courseId(courseMongo.getCourseId())
                    .courseName(courseMongo.getCourseName())
                    .places(coursePlaceItemResponseDtos)
                    .build();

            // 리스트에 dto 저장
            detailCourseResponseDtos.add(detailCourseResponseDto);
        }

        return detailCourseResponseDtos;
    }


    // 코스 수정하기
    @Transactional
    public boolean update(ModifyCourseRequestDto modifyCourseRequestDto) {

        // mongoDB, RDBMS를 조회할 UUID courseId를 불러오기
        UUID courseId = modifyCourseRequestDto.getCourseId();

        // RDBMS, mongoDB에서 해당 코스 조회
        Course course = courseRepository.findByCourseId(courseId)
                .orElseThrow(()-> new IllegalArgumentException());

        CourseMongo courseMongo = courseMongoRepository.findCourseMongoByCourseId(courseId).get();

        // 요청받은 dto 중 place정보 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = modifyCourseRequestDto.getPlaces();

        // mongoDB에 저장할 placeItem 리스트 생성
        List<CourseMongo.PlaceItem> placeItems = new ArrayList<>();

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
                    .order(placeRequestDto.getOrder())
                    .build();
            placeItems.add(placeDto);
        }

        CourseMongo courseMongoUpdate = CourseMongo.builder()
                .courseId(courseId)
                .courseName(modifyCourseRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 수정(저장)
        courseMongoRepository.save(courseMongoUpdate);

        // RDBMS에 수정( Transactional 어노테이션 활용)
        course.updateCourse(modifyCourseRequestDto.getCourseName());

        return true;
    }


    // 코스 삭제하기
    @Transactional
    public boolean delete(DeleteCourseRequestDto deleteCourseRequestDto) {

        // 삭제할 코스 정보 불러오기
        Course course = courseRepository.findByCourseId(deleteCourseRequestDto.getCourseId())
                .orElseThrow(()-> new IllegalArgumentException());

        if(course.getFlag() == true){
            return false;
        }
        // 불러온 코스 정보에서 유저 정보 불러오기
        User user = course.getUser();

        // mongoDB에서 코스 정보 삭제
        courseMongoRepository.deleteByCourseId(deleteCourseRequestDto.getCourseId());

        // RDBMS에 수정(flag => true, Transactional 어노테이션 활용)
        course.deleteCourse();

        // 유저의 코스 갯수에서 한개 차감
        user.changeCourseCount(-1);

        return true;
    }
}
