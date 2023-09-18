package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.entity.ReviewImage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewImageRepository extends JpaRepository<ReviewImage, Integer> {
    public List<ReviewImage> findByPlaceId(int placeId);
}
