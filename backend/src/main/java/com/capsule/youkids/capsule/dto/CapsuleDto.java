package com.capsule.youkids.capsule.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CapsuleDto {

    int capsuleId;
    int year;
    String url;

    @Builder
    public CapsuleDto(int capsuleId, int year, String url) {
        this.capsuleId = capsuleId;
        this.year = year;
        this.url = url;
    }
}
