package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.dto.PlaceRecommItemDto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import com.capsule.youkids.place.entity.Place;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PlaceRepository extends JpaRepository<Place, Integer> {
    @Query("select new com.capsule.youkids.place.dto.BookmarkListItemDto(p)"
            + "from Place p where p.placeId in :placeIds")
    List<BookmarkListItemDto> getbookmarkPlaceInfos(@Param("placeIds") List<Integer> placeIds);

    @Query("select new com.capsule.youkids.place.dto.PlaceRecommItemDto(p)"
            + "from Place p where p.placeId in :placeIds")
    List<PlaceRecommItemDto> getRecommPlaceInfos(@Param("placeIds") List<Integer> placeIds);

    @Query("select new com.capsule.youkids.place.dto.PlaceRecommItemDto(p)"
            + "from Place p where p.name like %:name% "
            + "order by p.naverReviewNum desc")
    List<PlaceRecommItemDto> findTop100ByNameContainingOrderByNaverReviewNumDesc(@Param("name") String name);
}