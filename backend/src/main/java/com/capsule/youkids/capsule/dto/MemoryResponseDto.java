package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;

@Getter
public class MemoryResponseDto {

    private int month;
    private int day;
    private List<MemoryImageDto> memoryImageDtoList;

    @Builder
    public MemoryResponseDto(int month, int day, List<MemoryImageDto> memoryImageDtoList){
        this.month = month;
        this.day = day;
        this.memoryImageDtoList = memoryImageDtoList;
    }

    public class MemoryImageDto {

        String url;
        List<Long> childrenList;

        @Builder
        public MemoryImageDto(String url, List<Long> childrenList){
            this.url = url;
            this.childrenList = childrenList;
        }

    }
}
