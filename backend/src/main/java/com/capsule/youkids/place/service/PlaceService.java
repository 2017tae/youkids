package com.capsule.youkids.place.service;

import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import java.util.UUID;

public interface PlaceService {

    // 장소 상세보기
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId);

    // 찜 하기 / 취소하기
    public String doBookmark(BookmarkRequestDto bookmarkRequestDto);
}
