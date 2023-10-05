package com.capsule.youkids.place.repository;

import com.capsule.youkids.festival.entity.Festival;
import com.capsule.youkids.place.entity.TopReviewPlace;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface TopReviewPlaceRepository extends JpaRepository<TopReviewPlace, Integer> {
    // 전체에서 리뷰수 순으로 10개
    @Query(value = "SELECT * FROM top_review_place ORDER BY naver_review_num DESC LIMIT 10", nativeQuery = true)
    List<TopReviewPlace> findTen();

    // 전체 반환
    @Query(value = "SELECT * FROM top_review_place", nativeQuery = true)
    List<TopReviewPlace> findTotal();
}
