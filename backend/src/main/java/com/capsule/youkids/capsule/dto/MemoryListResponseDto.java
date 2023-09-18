package com.capsule.youkids.capsule.dto;

import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryListResponseDto {

    List<MemoryResponseDto> memoryResponseDtoList = new ArrayList<>();
}
