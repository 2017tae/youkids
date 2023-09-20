package com.capsule.youkids.place.controller;

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
    public ResponseEntity<?> viewDetailPlace(@PathVariable UUID userId, @PathVariable int placeId) {
        DetailPlaceResponseDto response = placeService.viewPlace(userId, placeId);

        if (response == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            return new ResponseEntity<>(response, HttpStatus.OK);
        }
    }

    // 찜하기 / 취소하기
    @PostMapping("/bookmark")
    public ResponseEntity<?> doBookmark(@RequestBody BookmarkRequestDto bookmarkRequestDto) {
        String result = placeService.doBookmark(bookmarkRequestDto);
        if (result.equals("success")) {
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    // 찜한 장소 리스트 조회하기
    @GetMapping("/bookmark/{userId}")
    public ResponseEntity<?> getBookmarkList(@PathVariable UUID userId) {
        BookmarkListResponseDto response = placeService.getBookmarkList(userId);
        if (response == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            return new ResponseEntity<BookmarkListResponseDto>(response, HttpStatus.OK);
        }
    }

    // 리뷰 작성하기
    @PostMapping("/review")
    public ResponseEntity<?> writeReview(@RequestPart ReviewWriteRequestDto reviewWriteRequestDto, @RequestPart(required = false)
    List<MultipartFile> files) {
        String result = null;
        try {
            result = placeService.writeReview(reviewWriteRequestDto, files);
        } catch (IOException e) {
            return new ResponseEntity<>("리뷰 작성 중 에러 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        if(result.equals("success"))
            return new ResponseEntity<>("리뷰 작성 성공", HttpStatus.CREATED);
        else if(result.equals("empty"))
            return new ResponseEntity<>("일치하는 장소 또는 유저 정보가 없습니다.", HttpStatus.BAD_REQUEST);
        else
            return new ResponseEntity<>("리뷰 작성 중 에러 발생", HttpStatus.INTERNAL_SERVER_ERROR);
    }

    // 리뷰 삭제하기
    @DeleteMapping("/review")
    public ResponseEntity<?> deleteReview(@RequestBody ReviewDeleteRequestDto reviewDeleteRequestDto) {
        String result = placeService.deleteReview(reviewDeleteRequestDto);
        if(result.equals("bad request"))
            return new ResponseEntity<>("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        else if(result.equals("error"))
            return new ResponseEntity<>("삭제 과정 중 에러 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        else
            return new ResponseEntity<>("삭제 성공", HttpStatus.OK);
    }

    // 리뷰 수정하기
    @PutMapping("/review")
    public ResponseEntity<?> updateReview(@RequestPart ReviewUpdateRequestDto reviewUpdateRequestDto, @RequestPart(required = false)
    List<MultipartFile> files) {
        String result = null;
        try {
            result = placeService.updateReview(reviewUpdateRequestDto, files);
        } catch (IOException e) {
            return new ResponseEntity<>("리뷰 수정 중 에러 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        if(result.equals("success"))
            return new ResponseEntity<>("리뷰 수정 성공", HttpStatus.CREATED);
        else if(result.equals("error"))
            return new ResponseEntity<>("리뷰 수정 중 에러 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        else
            return new ResponseEntity<>("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
    }

}