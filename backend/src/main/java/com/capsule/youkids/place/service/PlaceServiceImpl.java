package com.capsule.youkids.place.service;

import com.capsule.youkids.global.s3.service.AwsS3Service;
import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.dto.PlaceInfoDto;
import com.capsule.youkids.place.dto.ReviewDeleteRequestDto;
import com.capsule.youkids.place.dto.ReviewImageInfoDto;
import com.capsule.youkids.place.dto.ReviewInfoDto;
import com.capsule.youkids.place.dto.ReviewWriteRequestDto;
import com.capsule.youkids.place.entity.Bookmark;
import com.capsule.youkids.place.entity.BookmarkMongo;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.entity.PlaceImage;
import com.capsule.youkids.place.entity.Review;
import com.capsule.youkids.place.entity.ReviewImage;
import com.capsule.youkids.place.repository.BookmarkMongoRepository;
import com.capsule.youkids.place.repository.BookmarkRepository;
import com.capsule.youkids.place.repository.PlaceRepository;
import com.capsule.youkids.place.repository.ReviewImageRepository;
import com.capsule.youkids.place.repository.ReviewRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
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

    // Review 엔티티의 내용을 ReviewInfoDto로 옮기는 작업
    private ReviewInfoDto moveToReviewDto(Review review) {
        // 리뷰 이미지 리스트를 꺼냄
        List<ReviewImage> reviewImages = review.getImages();
        
        // 리뷰 url을 담을 리스트 생성
        List<String> imageList = new ArrayList<>();
        for(ReviewImage image : reviewImages) {
            
            // url 넣어줌
            imageList.add(image.getImageUrl());
        }
        
        // 데이터 옮겨 담기
        return ReviewInfoDto.builder()
                .reviewId(review.getReviewId())
                .userId(review.getUser().getUserId())
                .score(review.getScore())
                .description(review.getDescription())
                .images(imageList)
                .build();
    }

    // Place 엔티티를 PlaceInfoDto로 옮기는 작업
    private PlaceInfoDto moveToPlaceDto(Place place) {

        // image 리스트 생성
        List<String> images = new ArrayList<>();
        for(PlaceImage image : place.getImages()) {
            
            // 이미지 url을 리스트에 저장
            images.add(image.getUrl());
        }

        // 데이터 옮기기
        return PlaceInfoDto.builder()
                .placeId(place.getPlaceId())
                .name(place.getName())
                .address(place.getAddress())
                .latitude(place.getLatitude())
                .longitude(place.getLongitude())
                .phoneNumber(place.getPhoneNumber())
                .category(place.getCategory())
                .homepage(place.getHomepage())
                .description(place.getDescription())
                .reviewSum(place.getReviewSum())
                .reviewNum(place.getReviewNum())
                .subwayFlag(place.isSubwayFlag())
                .subwayId(place.getSubwayId())
                .subwayDistance(place.getSubwayDistance())
                .images(images)
                .build();
    }

    public List<ReviewImageInfoDto> getRecentImages(int placeId, int num) {
        // 해당 장소의 리뷰 이미지를 리스트로 조회
        List<ReviewImage> reviewImages = reviewImageRepository.findByPlaceId(placeId);

        // Dto의 리스트 생성
        List<ReviewImageInfoDto> list = new ArrayList<>();

        int end = reviewImages.size() - 1;
        for(int i=end; i>=0; i--) {
            if(list.size() == num) break;
            ReviewImage reviewImage = reviewImages.get(i);
            ReviewImageInfoDto temp = ReviewImageInfoDto.builder()
                    .reviewImageId(reviewImage.getReviewImageId())
                    .reviewId(reviewImage.getReview().getReviewId())
                    .imageUrl(reviewImage.getImageUrl())
                    .build();
            list.add(temp);
        }
        return list;
    }

    // 장소 상세보기
    @Override
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId) {
        // 컨트롤러에서 null 확인을 위해 null로 초기화
        DetailPlaceResponseDto response = null;

        // 장소 검색 결과를 Optional로 저장
        Optional<Place> result = placeRepository.findById(placeId);

        // 찜 여부를 확인하기 위한 MongoDB용 Key
        String mongoKey = userId.toString() + String.valueOf(placeId);

        // 검색 결과가 존재한다면
        if (result.isPresent()) {
            // 장소 정보
            Place place = result.get();

            // 찜 여부 체크
            Optional<BookmarkMongo> bookmarkCheck = bookmarkMongoRepository.findById(mongoKey);

            // MongoDB에 값이 없는 경우 찜을 클릭한 기록이 없는 것이기 때문에 false
            boolean bookmarkResult = false;

            if (bookmarkCheck.isPresent()) {
                // MongoDB에 값이 있다면 그 값을 삽입
                bookmarkResult = bookmarkCheck.get().isBookmarked();
            }

            // Review 리스트 꺼내기
            List<Review> reviewList = place.getReviews();

            // 리뷰를 저장할 리스트 생성
            List<ReviewInfoDto> reviews = new ArrayList<>();

            // 리뷰 옮겨 담기
            for(Review review : reviewList) {
                // 위에 만든 메서드로 Dto를 리스트에 저장
                reviews.add(moveToReviewDto(review));
            }

            response = DetailPlaceResponseDto.builder()
                    .place(moveToPlaceDto(place))
                    .reviews(reviews)
                    .recentImages(getRecentImages(placeId, 5))
                    .bookmarked(bookmarkResult).build();
        }
        return response;
    }

    // 찜 하기 / 취소하기
    @Transactional
    @Override
    public String doBookmark(BookmarkRequestDto bookmarkRequestDto) {
        UUID userId = bookmarkRequestDto.getUserId();
        int placeId = bookmarkRequestDto.getPlaceId();
        boolean flag = bookmarkRequestDto.getFlag() == 0;

        // MongoDB를 위한 Key id
        String id = userId.toString() + String.valueOf(placeId);

        // RDB용 객체 생성
        Bookmark bookmark = Bookmark.builder()
                .userId(userId)
                .placeId(placeId)
                .build();

        // MongoDB용 객체 생성
        BookmarkMongo bookmarkMongo = BookmarkMongo.builder()
                .id(id)
                .isBookmarked(flag)
                .build();

        try {
            if (flag) {
                // RDB에 삽입
                bookmarkRepository.save(bookmark);
            } else {
                // RDB에서 삭제
                bookmarkRepository.delete(bookmark);
            }

            // MongoDB 에 저장
            bookmarkMongoRepository.save(bookmarkMongo);

            return "success";
        } catch (Exception e) {
            // 에러 발생
            return "error";
        }
    }

    // 유저의 찜 리스트 조회하기
    @Override
    public BookmarkListResponseDto getBookmarkList(UUID userId) {
        // response용 DTO
        BookmarkListResponseDto response = null;

        // 1차로, 찜한 장소의 placeId 조회
        List<Integer> placeIds = bookmarkRepository.findPlaceIdsByUserId(userId);

        // 찜한 리스트가 있는 경우만 취급
        if (!placeIds.isEmpty()) {
            List<BookmarkListItemDto> list = placeRepository.getbookmarkPlaceInfos(placeIds);

            // placeIds에 담긴 id들이 place 테이블에 있는 경우만 취급
            if (!list.isEmpty()) {
                response = BookmarkListResponseDto.builder().bookmarks(list).build();
            }
        }
        return response;
    }

    // 리뷰 작성하기
    @Transactional
    @Override
    public String writeReview(ReviewWriteRequestDto reviewWriteRequestDto,
            List<MultipartFile> files) {
        // RequestDto에서 파라미터 빼오기
        UUID userId = reviewWriteRequestDto.getUserId();
        int placeId = reviewWriteRequestDto.getPlaceId();
        double score = reviewWriteRequestDto.getScore();
        String description = reviewWriteRequestDto.getDescription();

        // User, Place 객체 가져오기
        Optional<User> user = userRepository.findById(userId);
        Optional<Place> place = placeRepository.findById(placeId);

        if(!user.isPresent() || !place.isPresent())
            return "error";

        Review review = Review.builder()
                .score(score)
                .description(description)
                .user(user.get())
                .place(place.get())
                .build();

        if (!files.isEmpty()) {
            // S3에 파일 업로드 및 이미지 리스트에 저장
            try {
                for (MultipartFile file : files) {
                    ReviewImage image = ReviewImage.builder()
                            .imageUrl(awsS3Service.uploadImg(file))
                            .review(review)
                            .placeId(placeId)
                            .build();

                    // ReviewImage Table에 삽입
                    reviewImageRepository.save(image);
                }
            } catch (IOException e) {
                return "error";
            }
        }

        try {
            reviewRepository.save(review);
        } catch (Exception e) {
            return "error";
        }
        return "success";
    }

    // 리뷰 삭제하기
    @Transactional
    @Override
    public String deleteReview(ReviewDeleteRequestDto reviewDeleteRequestDto) {

        // reviewId 빼내기
        int reviewId = reviewDeleteRequestDto.getReviewId();

        // reviewId를 이용해 Review 객체 조회
        Optional<Review> result = reviewRepository.findById(reviewId);

        // 해당 데이터가 존재한다면
        if(result.isPresent()) {
            Review review = result.get();

            // place의 리뷰 수, 총점 갱신
            review.getPlace().downReviewNum();
            review.getPlace().subReviewSum(review.getScore());

            // 이미지 리스트 가져오기
            List<ReviewImage> images = review.getImages();

            try {
                // S3와 RDB에서 리뷰 이미지 삭제
                for(ReviewImage image : images) {
                    awsS3Service.deleteFile(image.getImageUrl());
                    reviewImageRepository.delete(image);
                }

                // 리뷰 데이터 삭제
                reviewRepository.delete(review);

                return "delete success";
            } catch (Exception e) {
                return "error";
            }
        }
        else {
            return "bad request";
        }
    }
}
