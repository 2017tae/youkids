package com.capsule.youkids.festival.dto.view;

import com.capsule.youkids.festival.entity.FestivalReserve;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FestivalReserveDto {

    private String reserveUrl;
    private String reserveSite;

    public FestivalReserveDto(FestivalReserve festivalReserve){
        this.reserveSite = festivalReserve.getSite();
        this.reserveUrl = festivalReserve.getUrl();
    }
}
