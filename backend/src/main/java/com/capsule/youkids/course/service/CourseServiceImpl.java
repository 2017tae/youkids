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
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.repository.PlaceRepository;
import com.capsule.youkids.user.entity.Role;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
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
    @Override
    public void save(CourseRequestDto courseRequestDto) throws RestApiException {

        // 삭제하지 않은 유저 정보 불러오기
        User user = getLeader(courseRequestDto.getUserId());

        if (!checkCount(user)) {
            throw new RestApiException(Code.COURSE_COUNT_FULL);
        }

        // mongoDB와 RDBMS에 UUID courseID를 동일하게 유지
        UUID courseId = UUID.randomUUID();

        // 요청된 값에서 place(placeId, order)값만 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = courseRequestDto.getPlaces();

        // place 정보를 통해 mongoDB에 저장할 placeItem 생성
        List<CourseMongo.PlaceItem> placeItems = createPlaceItems(placeRequestDtos);

        // mongoDB에 저장할 코스 정보 생성
        CourseMongo mongo = CourseMongo.builder()
                .courseId(courseId)
                .courseName(courseRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 코스 정보 저장
        courseMongoRepository.save(mongo);

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

    }


    // 유저의 코스 불러오기
    @Override
    public List<DetailCourseResponseDto> getCourseIdsByUserId(UUID userId)
            throws RestApiException {

        // 리더 유저 정보 갖고오기
        User user = getLeader(userId);

        // 유저의 모든 코스 불러오기
        List<Course> courses = courseRepository.findAllByUser_UserId(user.getUserId());

        // 불러온 해당 유저의 코스가 비었으면
        if (courses.isEmpty()) {
            throw new RestApiException(Code.COURSE_LIST_NOT_FOUND);
        }

        // 반환할 값을 저장할 리스트 생성
        List<DetailCourseResponseDto> detailCourseResponseDtos = new ArrayList<>();

        for (Course course : courses) {

            // 이미 삭제된 코스면 코스를 조회하지 않음
            if (!skipCourse(course)) {

                // mongoDB에서 해당 코스 아이디 조회
                CourseMongo courseMongo = getCourseMongoByCourseId(course.getCourseId());

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
        }

        return detailCourseResponseDtos;
    }


    // 코스 수정하기
    @Transactional
    @Override
    public void update(ModifyCourseRequestDto modifyCourseRequestDto) throws RestApiException {

        // mongoDB, RDBMS를 조회할 UUID courseId를 불러오기
        UUID courseId = modifyCourseRequestDto.getCourseId();

        // RDBMS, mongoDB에서 해당 코스 조회
        Course course = getCourseByCourseId(courseId);

        // 수정할 권한이 있는지 확인
        if (!checkAuthority(modifyCourseRequestDto.getUserId(), course.getUser())) {
            throw new RestApiException(Code.COURSE_AUTH_FAIL);
        }

        // 요청받은 dto 중 place정보 리스트로 저장
        List<CoursePlaceRequestDto> placeRequestDtos = modifyCourseRequestDto.getPlaces();

        // place 정보를 통해 mongoDB에 저장할 placeItem 생성
        List<CourseMongo.PlaceItem> placeItems = createPlaceItems(placeRequestDtos);

        CourseMongo courseMongoUpdate = CourseMongo.builder()
                .courseId(courseId)
                .courseName(modifyCourseRequestDto.getCourseName())
                .places(placeItems)
                .build();

        // mongoDB에 수정(저장)
        courseMongoRepository.save(courseMongoUpdate);

        // RDBMS에 수정( Transactional 어노테이션 활용)
        course.updateCourse(modifyCourseRequestDto.getCourseName());
    }


    // 코스 삭제하기
    @Transactional
    @Override
    public void delete(DeleteCourseRequestDto deleteCourseRequestDto) throws RestApiException {

        // 삭제할 코스 정보 불러오기
        Course course = getCourseByCourseId(deleteCourseRequestDto.getCourseId());

        // 불러온 코스 정보에서 유저 정보 불러오기
        User user = course.getUser();

        // 삭제할 권한이 있는지 확인
        if (!checkAuthority(deleteCourseRequestDto.getUserId(), user)) {
            throw new RestApiException(Code.COURSE_AUTH_FAIL);
        }

        if (course.getFlag() == true) {
            throw new RestApiException(Code.COURSE_NOT_FOUND);
        }

        // mongoDB에서 코스 정보 삭제
        courseMongoRepository.deleteByCourseId(deleteCourseRequestDto.getCourseId());

        // RDBMS에 수정(flag => true, Transactional 어노테이션 활용)
        course.deleteCourse();

        // 유저의 코스 갯수에서 한개 차감
        user.changeCourseCount(-1);

    }

    // 삭제된 코스면 조회 생략
    private boolean skipCourse(Course course) {
        return course.getFlag() == true;
    }

    private CourseMongo getCourseMongoByCourseId(UUID courseId) throws RestApiException {
        return courseMongoRepository.findByCourseId(courseId)
                .orElseThrow(() -> new RestApiException(Code.COURSE_PLACE_ITEM_NOT_FOUND));
    }

    private Course getCourseByCourseId(UUID courseId) throws RestApiException {
        return courseRepository.findByCourseId(courseId)
                .orElseThrow(() -> new RestApiException(Code.COURSE_NOT_FOUND));
    }

    private List<CourseMongo.PlaceItem> createPlaceItems(
            List<CoursePlaceRequestDto> placeRequestDtos) throws RestApiException {

        // mongoDB에 저장할 placeItem 리스트 생성
        List<CourseMongo.PlaceItem> placeItems = new ArrayList<>();

        for (CoursePlaceRequestDto placeRequestDto : placeRequestDtos) {

            // placeId로 place 조회
            Place place = placeRepository.findById(placeRequestDto.getPlaceId())
                    .orElseThrow(() -> new RestApiException(Code.PLACE_NOT_FOUND));

            // place를 통해 내부 클래스인 placeItem 생성
            CourseMongo.PlaceItem placeItem = CourseMongo.PlaceItem.builder()
                    .placeId(place.getPlaceId())
                    .name(place.getName())
                    .latitude(place.getLatitude())
                    .longitude(place.getLongitude())
                    .address(place.getAddress())
                    .category(place.getCategory())
                    .order(placeRequestDto.getOrder())
                    .build();

            placeItems.add(placeItem);
        }

        return placeItems;
    }

    private User getLeader(UUID userId) throws RestApiException {
        // 삭제하지 않은 유저 정보 불러오기
        User user = userRepository.findByUserIdAndRoleNot(userId, Role.DELETED)
                .orElseThrow(() -> new RestApiException(Code.USER_NOT_FOUND));

        // 리더가 false라면
        if (!user.isLeader()) {
            System.out.println("changeId");
            // user 정보를 리더인 파트너 정보로 변경
            user = userRepository.findById(user.getPartnerId()).get();
        }
        return user;
    }

    private boolean checkAuthority(UUID userId, User courseUser) throws RestApiException {
        // 리더의 유저 정보 갖고옴
        User user = getLeader(userId);

        // 리더의 유저 정보와 게시글의 유저 정보 일치 확인
        if (user.equals(courseUser)) {
            return true;
        } else {
            return false;
        }
    }

    private boolean checkCount(User user) throws RestApiException {

        if (user.getCourseCount() < 10) {
            // 코스 갯수 10개 미만인 경우 코스 생성 가능
            return true;
        } else {
            // 코스 갯수가 10개 이상인 경우 코스 생성 불가
            return false;
        }
    }
}
