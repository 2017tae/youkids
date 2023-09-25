package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.entity.Bookmark;
import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BookmarkRepository extends JpaRepository<Bookmark, Integer> {
    @Query("select b.placeId from Bookmark b where b.userId = :userId")
    List<Integer> findPlaceIdsByUserId(@Param("userId") UUID userId);

    int countByUserId(UUID userId);
}