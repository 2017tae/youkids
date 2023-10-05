package com.capsule.youkids.place.service;

import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.s3.service.AwsS3Service;
import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.dto.PlaceInfoDto;
import com.capsule.youkids.place.dto.PlaceRecommDto;
import com.capsule.youkids.place.dto.PlaceRecommItemDto;
import com.capsule.youkids.place.dto.ReviewDeleteRequestDto;
import com.capsule.youkids.place.dto.ReviewImageInfoDto;
import com.capsule.youkids.place.dto.ReviewInfoDto;
import com.capsule.youkids.place.dto.ReviewUpdateRequestDto;
import com.capsule.youkids.place.dto.ReviewWriteRequestDto;
import com.capsule.youkids.place.entity.Bookmark;
import com.capsule.youkids.place.entity.BookmarkMongo;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.entity.PlaceImage;
import com.capsule.youkids.place.entity.Review;
import com.capsule.youkids.place.entity.ReviewImage;
import com.capsule.youkids.place.entity.TopReviewPlace;
import com.capsule.youkids.place.repository.BookmarkMongoRepository;
import com.capsule.youkids.place.repository.BookmarkRepository;
import com.capsule.youkids.place.repository.PlaceRepository;
import com.capsule.youkids.place.repository.ReviewImageRepository;
import com.capsule.youkids.place.repository.ReviewRepository;
import com.capsule.youkids.place.repository.TopReviewPlaceRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService {

    // repository
    private final PlaceRepository placeRepository;
    private final BookmarkRepository bookmarkRepository;
    private final BookmarkMongoRepository bookmarkMongoRepository;
    private final ReviewRepository reviewRepository;
    private final ReviewImageRepository reviewImageRepository;
    private final UserRepository userRepository;
    private final AwsS3Service awsS3Service;
    private final TopReviewPlaceRepository topReviewPlaceRepository;

    // Review 엔티티의 내용을 ReviewInfoDto로 옮기는 작업
    private ReviewInfoDto moveToReviewDto(Review review) {
        // 리뷰 이미지 리스트를 꺼냄
        List<ReviewImage> reviewImages = review.getImages();

        // 리뷰 url을 담을 리스트 생성
        List<String> imageList = new ArrayList<>();
        for (ReviewImage image : reviewImages) {

            // url 넣어줌
            imageList.add(image.getImageUrl());
        }

        // 데이터 옮겨 담기
        return new ReviewInfoDto(review);
    }

    // Place 엔티티를 PlaceInfoDto로 옮기는 작업
    private PlaceInfoDto moveToPlaceDto(Place place) {

        // image 리스트 생성
        List<String> images = new ArrayList<>();
        for (PlaceImage image : place.getImages()) {

            // 이미지 url을 리스트에 저장
            images.add(image.getUrl());
        }

        // 데이터 옮기기
        return new PlaceInfoDto(place);
    }

    public List<ReviewImageInfoDto> getRecentImages(int placeId, int num) {
        // 해당 장소의 리뷰 이미지를 리스트로 조회
        List<ReviewImage> reviewImages = reviewImageRepository.findByPlaceId(placeId);

        // Dto의 리스트 생성
        List<ReviewImageInfoDto> list = new ArrayList<>();

        int end = reviewImages.size() - 1;
        for (int i = end; i >= 0; i--) {
            if (list.size() == num) {
                break;
            }
            ReviewImageInfoDto reviewImageInfo = new ReviewImageInfoDto(reviewImages.get(i));
            list.add(reviewImageInfo);
        }
        return list;
    }

    // 장소 상세보기
    @Override
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId) {

        // 장소 검색 결과를 Optional로 저장
        Optional<Place> result = placeRepository.findById(placeId);

        // 데이터 베이스에 해당 장소가 없다면 throw
        if (!result.isPresent()) {
            throw new RestApiException(Code.PLACE_NOT_FOUND);
        }

        // 장소 정보
        Place place = result.get();

        // 찜 여부를 확인하기 위한 MongoDB용 Key
        String mongoKey = userId.toString() + String.valueOf(placeId);

        // 찜 여부 체크
        Optional<BookmarkMongo> bookmarkCheck = bookmarkMongoRepository.findById(mongoKey);

        // MongoDB에 값이 없는 경우 찜을 클릭한 기록이 없는 것이기 때문에 false
        boolean bookmarkResult =
                bookmarkCheck.isPresent() ? bookmarkCheck.get().isBookmarked() : false;

        // Review 리스트 꺼내기
        List<Review> reviewList = place.getReviews();

        // 리뷰를 저장할 리스트 생성
        List<ReviewInfoDto> reviews = new ArrayList<>();

        // 리뷰 옮겨 담기
        for (Review review : reviewList) {
            // 위에 만든 메서드로 Dto를 리스트에 저장
            reviews.add(moveToReviewDto(review));
        }

        DetailPlaceResponseDto response = DetailPlaceResponseDto.builder()
                .place(moveToPlaceDto(place)).reviews(reviews)
                .recentImages(getRecentImages(placeId, 5)).bookmarked(bookmarkResult).build();

        return response;
    }

    // 찜 하기 / 취소하기
    @Transactional
    @Override
    public void doBookmark(BookmarkRequestDto bookmarkRequestDto) {
        UUID userId = bookmarkRequestDto.getUserId();
        int placeId = bookmarkRequestDto.getPlaceId();
        // true: insert / false: delete
        boolean flag = bookmarkRequestDto.isFlag();

        // 찜 개수 체크
        int cnt = bookmarkRepository.countByUserId(userId);
        if (cnt > 100) {
            throw new RestApiException(Code.PLACE_BOOKMARK_FULL);
        }

        // MongoDB를 위한 Key id
        String id = userId.toString() + String.valueOf(placeId);

        // RDB용 객체 생성
        Bookmark bookmark = Bookmark.builder().userId(userId).placeId(placeId).build();

        // MongoDB용 객체 생성
        BookmarkMongo bookmarkMongo = BookmarkMongo.builder().id(id).isBookmarked(flag).build();

        try {
            if (flag) {
                // RDB에 삽입
                bookmarkRepository.save(bookmark);
            } else {
                // RDB에서 삭제
                bookmarkRepository.deleteByUserIdAndPlaceId(userId, placeId);
            }
        } catch (Exception e) {
            throw new RestApiException(Code.PLACE_BOOKMARK_FAILED);
        }

        try {
            // MongoDB 에 저장
            bookmarkMongoRepository.save(bookmarkMongo);
        } catch (Exception e) {
            throw new RestApiException(Code.PLACE_BOOKMARK_MONGO_FAILED);
        }
    }

    // 유저의 찜 리스트 조회하기
    @Override
    public BookmarkListResponseDto getBookmarkList(UUID userId) {

        // 1차로, 찜한 장소의 placeId 모두 조회
        List<Integer> placeIds = bookmarkRepository.findPlaceIdsByUserId(userId);

        // Bookmark 테이블에서 user에 해당하는 placeId가 없는 경우
        if (placeIds.isEmpty()) {
            throw new RestApiException(Code.PLACE_BOOKMARK_NOT_FOUND);
        }

        List<BookmarkListItemDto> list = placeRepository.getbookmarkPlaceInfos(placeIds);

        // placeId에는 조회 되지만, 일치하는 Place 정보가 없는 경우
        // 찜 리스트가 없다 처리
        if (list.isEmpty()) {
            throw new RestApiException(Code.PLACE_BOOKMARK_NOT_FOUND);
        }

        return BookmarkListResponseDto.builder().bookmarks(list).build();
    }

    private void saveImages(Review review, List<MultipartFile> files) throws IOException {
        // S3에 파일 업로드 및 이미지 리스트에 저장
        for (MultipartFile file : files) {
            ReviewImage image = ReviewImage.builder().imageUrl(awsS3Service.uploadFile(file))
                    .review(review).placeId(review.getPlace().getPlaceId()).build();

            // ReviewImage Table에 삽입
            reviewImageRepository.save(image);
        }
    }

    // 리뷰 작성하기
    @Transactional
    @Override
    public void writeReview(ReviewWriteRequestDto reviewWriteRequestDto,
            List<MultipartFile> files) {
        // RequestDto에서 파라미터 빼오기
        UUID userId = reviewWriteRequestDto.getUserId();
        int placeId = reviewWriteRequestDto.getPlaceId();
        double score = reviewWriteRequestDto.getScore();
        String description = reviewWriteRequestDto.getDescription();

        // User, Place 객체 가져오기
        Optional<User> user = userRepository.findById(userId);
        Optional<Place> place = placeRepository.findById(placeId);

        // user와 place 중 하나라도 RDB에 없으면 스킵
        if (!user.isPresent()) {
            throw new RestApiException(Code.USER_NOT_FOUND);
        } else if (!place.isPresent()) {
            throw new RestApiException(Code.PLACE_NOT_FOUND);
        }

        // 리뷰 생성
        Review review = Review.builder().score(score).description(description).user(user.get())
                .place(place.get()).build();

        // image가 존재하는 경우 image 저장
        try {
            if (!files.isEmpty()) {
                saveImages(review, files);
            }
        } catch (IOException e) {
            throw new RestApiException(Code.S3_SAVE_ERROR);
        }

        reviewRepository.save(review);
    }

    // 리뷰 삭제하기
    @Transactional
    @Override
    public void deleteReview(ReviewDeleteRequestDto reviewDeleteRequestDto) {

        // reviewId 빼내기
        int reviewId = reviewDeleteRequestDto.getReviewId();

        // reviewId를 이용해 Review 객체 조회
        Optional<Review> result = reviewRepository.findById(reviewId);
        if (!result.isPresent()) {
            throw new RestApiException(Code.PLACE_REVIEW_NOT_FOUND);
        }

        Review review = result.get();

        // 리뷰 작성자와 현재 사용자가 다른 경우
        if (!reviewDeleteRequestDto.getUserId().equals(review.getUser().getUserId())) {
            throw new RestApiException(Code.PlACE_DIFFERENT_USER);
        }

        // place의 리뷰 수, 총점 갱신
        review.getPlace().downReviewNum();
        review.getPlace().subReviewSum(review.getScore());

        // 이미지 리스트 가져오기
        List<ReviewImage> images = review.getImages();

        // S3와 RDB에서 리뷰 이미지 삭제
        try {
            for (ReviewImage image : images) {

                // S3에서 파일 삭제
                awsS3Service.deleteFile(image.getImageUrl());

                // RDB에서 파일 삭제
                reviewImageRepository.delete(image);
            }
        } catch (Exception e) {
            throw new RestApiException(Code.PLACE_REVIEW_IMAGE_DELETE_FAILED);
        }

        // 리뷰 데이터 삭제
        try {
            reviewRepository.delete(review);
        } catch (Exception e) {
            throw new RestApiException(Code.PLACE_REVIEW_DELETE_FAILED);
        }
    }

    // 리뷰 수정하기
    @Transactional
    @Override
    public void updateReview(ReviewUpdateRequestDto reviewUpdateRequestDto,
            List<MultipartFile> files) {

        Optional<Review> reviewOptional = reviewRepository.findById(
                reviewUpdateRequestDto.getReviewId());

        if (!reviewOptional.isPresent()) {
            throw new RestApiException(Code.PLACE_REVIEW_NOT_FOUND);
        }

        Review review = reviewOptional.get();

        // 리뷰 작성자와 현재 사용자가 다른 경우
        if (!reviewUpdateRequestDto.getUserId().equals(review.getUser().getUserId())) {
            throw new RestApiException(Code.PlACE_DIFFERENT_USER);
        }

        // image가 존재한다면 업로드
        try {
            if (!files.isEmpty()) {
                saveImages(review, files);
            }
        } catch (IOException e) {
            throw new RestApiException(Code.S3_SAVE_ERROR);
        }

        // 삭제할 이미지 리스트 빼내기
        List<Integer> deleteImageIds = reviewUpdateRequestDto.getDeletedImageIds();
        List<ReviewImage> deleteImages = reviewImageRepository.findReviewImagesInImageIds(
                deleteImageIds);

        try {
            // 이미지 삭제 과정
            for (ReviewImage image : deleteImages) {

                // S3에서 파일 삭제
                awsS3Service.deleteFile(image.getImageUrl());

                // RDB에서 해당 Image 데이터 삭제
                reviewImageRepository.delete(image);
            }
        } catch (Exception e) {
            throw new RestApiException(Code.PLACE_REVIEW_IMAGE_DELETE_FAILED);
        }

        // score와 description 갱신
        double score = reviewUpdateRequestDto.getScore();
        String description = reviewUpdateRequestDto.getDescription();
        review.UpdateReview(score, description);
    }

    // 추천 장소 뿌리기 (일단 랜덤으로 100개만)
    @Override
    public PlaceRecommDto recommPlace() {
        Random random = new Random();
        List<Integer> placeIds = random.ints(100, 1, 288).boxed().collect(Collectors.toList());

        List<PlaceRecommItemDto> placeList = placeRepository.getRecommPlaceInfos(placeIds);
        Collections.shuffle(placeList);

        return PlaceRecommDto.builder().places(placeList).build();
    }

    // 리뷰 많은 순으로 10개 뿌리기
    @Override
    public PlaceRecommDto getReviewTopPlace() {
        // 전부 가져오기
        List<PlaceRecommItemDto> all = topReviewPlaceRepository.findTotal();
        return PlaceRecommDto.builder()
                .places(all)
                .build();
    }

    @Override
    public PlaceRecommDto getSearchPlace(String request) {
        return null;
    }
}
