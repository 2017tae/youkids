package com.capsule.youkids.place.controller;

import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.common.response.BaseResponse;
import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.dto.ReviewDeleteRequestDto;
import com.capsule.youkids.place.dto.ReviewUpdateRequestDto;
import com.capsule.youkids.place.dto.ReviewWriteRequestDto;
import com.capsule.youkids.place.service.PlaceService;
import java.io.IOException;
import java.util.List;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/place")
@RequiredArgsConstructor
public class PlaceController {

    private final PlaceService placeService;

    // 장소 상세보기
    @GetMapping("/{userId}/{placeId}")
    public BaseResponse<?> viewDetailPlace(@PathVariable UUID userId, @PathVariable int placeId) {
        try {
            return BaseResponse.success(Code.SUCCESS, placeService.viewPlace(userId, placeId));
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 찜하기 / 취소하기
    @PostMapping("/bookmark")
    public BaseResponse<?> doBookmark(@RequestBody BookmarkRequestDto bookmarkRequestDto) {
        try {
            placeService.doBookmark(bookmarkRequestDto);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 찜한 장소 리스트 조회하기
    @GetMapping("/bookmark/{userId}")
    public BaseResponse<?> getBookmarkList(@PathVariable UUID userId) {
        try {
            return BaseResponse.success(Code.SUCCESS, placeService.getBookmarkList(userId));
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 리뷰 작성하기
    @PostMapping("/review")
    public BaseResponse<?> writeReview(@RequestPart ReviewWriteRequestDto reviewWriteRequestDto, @RequestPart(required = false)
    List<MultipartFile> files) {
        try {
            placeService.writeReview(reviewWriteRequestDto, files);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 리뷰 삭제하기
    @DeleteMapping("/review")
    public BaseResponse<?> deleteReview(@RequestBody ReviewDeleteRequestDto reviewDeleteRequestDto) {
        try {
            placeService.deleteReview(reviewDeleteRequestDto);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 리뷰 수정하기
    @PutMapping("/review")
    public BaseResponse<?> updateReview(@RequestPart ReviewUpdateRequestDto reviewUpdateRequestDto, @RequestPart(required = false)
    List<MultipartFile> files) {
        try {
            placeService.updateReview(reviewUpdateRequestDto, files);
            return BaseResponse.success(Code.SUCCESS);
        } catch (RestApiException e) {
            return BaseResponse.error(e.getErrorCode());
        }
    }

    // 장소 랜덤 추천
    @GetMapping("/recomm")
    public BaseResponse<?> recommPlaces() {
        return BaseResponse.success(Code.SUCCESS, placeService.recommPlace());
    }

    // 리뷰 많은 순으로 n개 장소 추천
    @GetMapping("/reviewtop")
    public BaseResponse<?> recommTopReviewPlaces() {
        return BaseResponse.success(Code.SUCCESS, placeService.getReviewTopPlace());
    }

    @GetMapping("/search/{searchPlace}")
    public BaseResponse<?> searchPlaces(@PathVariable String searchPlace) {
        return BaseResponse.success(Code.SUCCESS, placeService.getSearchPlace(searchPlace));
    }
}