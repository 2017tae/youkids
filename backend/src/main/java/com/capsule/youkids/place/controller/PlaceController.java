package com.capsule.youkids.place.controller;

import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.service.PlaceService;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/place")
@RequiredArgsConstructor
public class PlaceController {

    private final PlaceService placeService;

    @GetMapping("/{userId}/{placeId}")
    public ResponseEntity<?> viewDetailPlace(@PathVariable UUID userId, @PathVariable int placeId) {
        DetailPlaceResponseDto response = placeService.viewPlace(userId, placeId);
        if (response == null) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        } else {
            return new ResponseEntity<DetailPlaceResponseDto>(response, HttpStatus.OK);
        }
    }
}
