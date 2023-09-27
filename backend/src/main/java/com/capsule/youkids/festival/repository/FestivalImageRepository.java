package com.capsule.youkids.festival.repository;

import com.capsule.youkids.festival.entity.Festival;
import com.capsule.youkids.festival.entity.FestivalImage;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FestivalImageRepository extends JpaRepository<FestivalImage, Long> {

    List<FestivalImage> findAllByFestival(Festival festival);
}
