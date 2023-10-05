package com.capsule.youkids.place.service;

import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.dto.PlaceRecommDto;
import com.capsule.youkids.place.dto.ReviewDeleteRequestDto;
import com.capsule.youkids.place.dto.ReviewUpdateRequestDto;
import com.capsule.youkids.place.dto.ReviewWriteRequestDto;
import java.util.List;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface PlaceService {

    // 장소 상세보기
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId);

    // 찜 하기 / 취소하기
    public void doBookmark(BookmarkRequestDto bookmarkRequestDto);

    // 유저의 찜 리스트 조회하기
    public BookmarkListResponseDto getBookmarkList(UUID userId);

    // 리뷰 작성하기
    public void writeReview(ReviewWriteRequestDto reviewWriteRequestDto, List<MultipartFile> files);

    // 리뷰 삭제하기
    public void deleteReview(ReviewDeleteRequestDto reviewDeleteRequestDto);

    // 리뷰 수정하기
    public void updateReview(ReviewUpdateRequestDto reviewUpdateRequestDto, List<MultipartFile> files);

    // 추천 장소 뿌리기 (일단 랜덤으로 100개)
    public PlaceRecommDto recommPlace();

    // 리뷰 많은 순으로 장소 뿌리기
    public PlaceRecommDto getReviewTopPlace();
}