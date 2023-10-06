package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CapsuleListResponseDto {

    private List<CapsuleResponseDto> capsuleResponses;

    @Builder
    public CapsuleListResponseDto(List<CapsuleResponseDto> capsuleResponses) {
        this.capsuleResponses = capsuleResponses;
    }
}
