package com.capsule.youkids.festival.service;

import com.capsule.youkids.festival.dto.response.FestivalDetailResponseDto;
import com.capsule.youkids.festival.dto.response.FestivalDivRecommResponseDto;
import com.capsule.youkids.festival.dto.response.FestivalRecommResponseDto;

public interface FestivalService {
    // 공연 추천 뿌리기 (혼합 형태)
    public FestivalRecommResponseDto getMixedFestivalRecomm();

    // 공연 추천 뿌리기 (공연 상태별로)
    public FestivalDivRecommResponseDto getDivFestivalRecomm();

    // 공연 상세 보기
    FestivalDetailResponseDto getDetailFestival(Long festivalId);
}
