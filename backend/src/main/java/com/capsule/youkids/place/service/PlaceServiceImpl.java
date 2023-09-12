package com.capsule.youkids.place.service;

import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.dto.BookmarkListResponseDto;
import com.capsule.youkids.place.dto.BookmarkRequestDto;
import com.capsule.youkids.place.dto.DetailPlaceResponseDto;
import com.capsule.youkids.place.entity.Bookmark;
import com.capsule.youkids.place.entity.BookmarkMongo;
import com.capsule.youkids.place.entity.Place;
import com.capsule.youkids.place.repository.BookmarkMongoRepository;
import com.capsule.youkids.place.repository.BookmarkRepository;
import com.capsule.youkids.place.repository.PlaceRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService {

    // repository
    private final PlaceRepository placeRepository;
    private final BookmarkRepository bookmarkRepository;
    private final BookmarkMongoRepository bookmarkMongoRepository;

    // 장소 상세보기
    public DetailPlaceResponseDto viewPlace(UUID userId, int placeId) {
        // 컨트롤러에서
        DetailPlaceResponseDto response = null;
        Optional<Place> result = placeRepository.findById(placeId);
        String mongoKey = userId.toString() + String.valueOf(placeId);

        if (result.isPresent()) {
            // 장소 찾기
            response = new DetailPlaceResponseDto();
            response.setPlace(result.get());

            // 찜 여부 넣기
            Optional<BookmarkMongo> isBookmarked = bookmarkMongoRepository.findById(mongoKey);
            if (isBookmarked.isPresent()) {
                response.setBookmarked(isBookmarked.get().isBookmarked());
            } else {
                response.setBookmarked(false);
            }
        } else {
            // DB에 해당 ID 없음
            // 지금은 null을 반환하도록 아무 조치 안 함.
        }
        return response;
    }
}
