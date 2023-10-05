package com.capsule.youkids.place.repository;

import com.capsule.youkids.festival.entity.Festival;
import com.capsule.youkids.place.dto.PlaceRecommItemDto;
import com.capsule.youkids.place.entity.TopReviewPlace;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TopReviewPlaceRepository extends JpaRepository<TopReviewPlace, Integer> {
    // 전체 반환
    @Query("select new com.capsule.youkids.place.dto.PlaceRecommItemDto(p)"
    + "from TopReviewPlace p")
    List<PlaceRecommItemDto> findTotal();
}
