package com.capsule.youkids.festival.repository;

import com.capsule.youkids.festival.entity.FestivalReserve;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FestivalReserveRepository extends JpaRepository<FestivalReserve, Long> {

    List<FestivalReserve> findAllByFestivalChildId(String festivalChildId);
}
