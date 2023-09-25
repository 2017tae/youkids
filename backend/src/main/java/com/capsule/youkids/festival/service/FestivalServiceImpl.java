package com.capsule.youkids.festival.service;

import com.capsule.youkids.festival.dto.response.FestivalDivRecommResponseDto;
import com.capsule.youkids.festival.dto.response.FestivalRecommResponseDto;
import com.capsule.youkids.festival.dto.view.FestivalRecommItemDto;
import com.capsule.youkids.festival.repository.FestivalRepository;
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FestivalServiceImpl implements FestivalService{

    private final FestivalRepository festivalRepository;

    @Override
    public FestivalRecommResponseDto getMixedFestivalRecomm() {
        Random random = new Random();
        List<Long> festivalIds = random.longs(10, 2, 500).boxed().collect(Collectors.toList());

        List<FestivalRecommItemDto> festivalList = festivalRepository.getMixedRecommfestivals(festivalIds);
        Collections.shuffle(festivalList);

        if(festivalList.isEmpty()) throw new RestApiException(Code.FESTIVAL_EMPTY);

        return FestivalRecommResponseDto.builder().festivals(festivalList).build();
    }

    @Override
    public FestivalDivRecommResponseDto getDivFestivalRecomm() {

        // 공연 중인 공연 조회
        List<FestivalRecommItemDto> onGoingFestivals = festivalRepository.getRandomFestivalsInStateOngoing()
                .stream().map(festival -> {return new FestivalRecommItemDto(festival);})
                .collect(Collectors.toList());

        // 공연 예정인 공연 조회
        List<FestivalRecommItemDto> upCommingFestivals = festivalRepository.getRandomFestivalsInStateUpcoming()
                .stream().map(festival -> {return new FestivalRecommItemDto(festival);})
                .collect(Collectors.toList());
        
        // 공연 마감인 공연 조회
        List<FestivalRecommItemDto> closedFestivals = festivalRepository.getRandomFestivalsInStateClosed()
                .stream().map(festival -> {return new FestivalRecommItemDto(festival);})
                .collect(Collectors.toList());

        // 모두 다 없으면 예외처리
        if(onGoingFestivals.isEmpty() && upCommingFestivals.isEmpty() && closedFestivals.isEmpty())
            throw new RestApiException(Code.FESTIVAL_EMPTY);

        // response에 넣기
        return FestivalDivRecommResponseDto.builder()
                .onGoingFestivals(onGoingFestivals)
                .upCommingFestivals(upCommingFestivals)
                .closedFestivals(closedFestivals)
                .build();
    }
}
