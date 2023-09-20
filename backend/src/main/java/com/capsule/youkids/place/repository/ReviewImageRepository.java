package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.dto.BookmarkListItemDto;
import com.capsule.youkids.place.entity.ReviewImage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ReviewImageRepository extends JpaRepository<ReviewImage, Integer> {
    public List<ReviewImage> findByPlaceId(int placeId);

    @Query("SELECT i FROM ReviewImage i WHERE i.reviewImageId IN :imageIds")
    List<ReviewImage> findReviewImagesInImageIds(@Param("imageIds") List<Integer> imageIds);
}
