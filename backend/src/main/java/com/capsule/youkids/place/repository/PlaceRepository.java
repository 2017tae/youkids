package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.dto.BookmarkListItemDto;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

import com.capsule.youkids.place.entity.Place;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface PlaceRepository extends JpaRepository<Place, Integer> {

}
