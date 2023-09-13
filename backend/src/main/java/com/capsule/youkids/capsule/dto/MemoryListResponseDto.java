package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryListResponseDto {
    List<MemoryResponseDto> memoryResponseDtoList;

    private class MemoryResponseDto{
        int month;
        int day;
        List<MemoryImageDto> memoryImageDtoList;
    }

    private class MemoryImageDto{

    }
}
