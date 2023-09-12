package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class DetailPlaceResponseDto {

    private Place place;
    private boolean bookmarked;
}
