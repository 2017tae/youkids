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

            // 찜 여부 넣기
            // 1차로 Optional로 값을 받음
            Optional<BookmarkMongo> bookmarkCheck = bookmarkMongoRepository.findById(mongoKey);

            // MongoDB에 값이 없는 경우 찜을 클릭한 기록이 없는 것이기 때문에 false
            boolean bookmarkResult = false;

            if (bookmarkCheck.isPresent()) {
                // MongoDB에 값이 있다면 그 값을 삽입
                bookmarkResult = bookmarkCheck.get().isBookmarked();
            }
            response = new DetailPlaceResponseDto(result.get(), bookmarkResult);
        }
        return response;
    }

    // 찜 하기 / 취소하기
    @Transactional
    public String doBookmark(BookmarkRequestDto bookmarkRequestDto) {
        UUID userId = bookmarkRequestDto.getUserId();
        int placeId = bookmarkRequestDto.getPlaceId();
        boolean flag = bookmarkRequestDto.getFlag() == 0;

        // MongoDB를 위한 Key id
        String id = userId.toString() + String.valueOf(placeId);

        // RDB용 객체 생성
        Bookmark bookmark = new Bookmark(userId, placeId);

        // MongoDB용 객체 생성
        BookmarkMongo bookmarkMongo = new BookmarkMongo(id, flag);

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
}
