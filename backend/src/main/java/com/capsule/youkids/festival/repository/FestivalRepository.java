package com.capsule.youkids.festival.repository;

import com.capsule.youkids.festival.dto.view.FestivalRecommItemDto;
import com.capsule.youkids.festival.entity.Festival;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface FestivalRepository extends JpaRepository<Festival, Long> {
    @Query("select new com.capsule.youkids.festival.dto.view.FestivalRecommItemDto(f)"
            + "from Festival f where f.festivalChildId in :festivalIds")
    List<FestivalRecommItemDto> getMixedRecommfestivals(@Param("festivalIds") List<Long> festivalIds);

    // state가 '공연중'이고 최대 30개의 랜덤 데이터 가져오기
    @Query(value = "SELECT * FROM festival_child WHERE state = '공연중' ORDER BY RAND() LIMIT 10", nativeQuery = true)
    List<Festival> getRandomFestivalsInStateOngoing();

    // state가 '공연예정'이고 최대 30개의 랜덤 데이터 가져오기
    @Query(value ="SELECT * FROM festival_child WHERE state = '공연예정' ORDER BY RAND() LIMIT 10", nativeQuery = true)
    List<Festival> getRandomFestivalsInStateUpcoming();

    // state가 '공연마감'이고 최대 30개의 랜덤 데이터 가져오기
    @Query(value ="SELECT * FROM festival_child WHERE state = '공연마감' ORDER BY RAND() LIMIT 10", nativeQuery = true)
    List<Festival> getRandomFestivalsInStateClosed();
}
