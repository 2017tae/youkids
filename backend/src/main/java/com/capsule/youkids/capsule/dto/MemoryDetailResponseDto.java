package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryDetailResponseDto {

    private int year;
    private int month;
    private int day;
    private String description;
    private String location;
    private List<String> images;
    private List<String> childrenImageList;

    @Builder
    public MemoryDetailResponseDto(int year, int month, int day, String description,
            String location, List<String> images, List<String> childrenImageList) {
        this.year = year;
        this.month = month;
        this.day = day;
        this.description = description;
        this.location = location;
        this.images = images;
        this.childrenImageList = childrenImageList;
    }
}
