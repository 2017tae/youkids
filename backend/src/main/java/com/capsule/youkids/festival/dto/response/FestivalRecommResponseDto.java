package com.capsule.youkids.festival.dto.response;

import com.capsule.youkids.festival.dto.view.FestivalRecommItemDto;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FestivalRecommResponseDto {
    private List<FestivalRecommItemDto> festivals;

    @Builder
    public FestivalRecommResponseDto(List<FestivalRecommItemDto> festivals) {
        this.festivals = festivals;
    }
}
