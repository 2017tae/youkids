package com.capsule.youkids.place.service;

import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.dto.ReviewWriteRequestDto;
import com.capsule.youkids.place.entity.Review;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public interface PlaceService {

    // 장소 상세보기
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId);

    // 찜 하기 / 취소하기
    public String doBookmark(BookmarkRequestDto bookmarkRequestDto);

    // 유저의 찜 리스트 조회하기
    public BookmarkListResponseDto getBookmarkList(UUID userId);

    // 리뷰 작성하기
    public String writeReview(ReviewWriteRequestDto reviewWriteRequestDto, List<MultipartFile> files);
}