package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewRepository extends JpaRepository<Review, Integer> {
}
