package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.dto.PlaceInfoDto;
import com.capsule.youkids.place.dto.PlaceRecommItemDto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import com.capsule.youkids.place.entity.Place;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PlaceRepository extends JpaRepository<Place, Integer> {
    @Query("select new com.capsule.youkids.place.dto.BookmarkListItemDto(p.placeId, p.name, p.address, p.latitude, p.longitude, p.category)"
            + "from Place p where p.placeId in :placeIds")
    List<BookmarkListItemDto> getbookmarkPlaceInfos(@Param("placeIds") List<Integer> placeIds);

    @Query("select new com.capsule.youkids.place.dto.PlaceRecommItemDto(p)"
            + "from Place p where p.placeId in :placeIds")
    List<PlaceRecommItemDto> getRecommPlaceInfos(@Param("placeIds") List<Integer> placeIds);
}