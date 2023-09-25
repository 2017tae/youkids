package com.capsule.youkids.festival.dto.response;

import com.capsule.youkids.festival.dto.view.FestivalRecommItemDto;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FestivalDivRecommResponseDto {
    private List<FestivalRecommItemDto> onGoingFestivals;
    private List<FestivalRecommItemDto> upCommingFestivals;
    private List<FestivalRecommItemDto> closedFestivals;

    @Builder
    public FestivalDivRecommResponseDto(List<FestivalRecommItemDto> onGoingFestivals,
            List<FestivalRecommItemDto> upCommingFestivals,
            List<FestivalRecommItemDto> closedFestivals) {
        this.onGoingFestivals = onGoingFestivals;
        this.upCommingFestivals = upCommingFestivals;
        this.closedFestivals = closedFestivals;
    }
}
