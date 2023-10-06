package com.capsule.youkids.capsule.dto;

import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryDetailResponseDto {

    private String nickname;
    private String userImage;
    private long memoryId;
    private int year;
    private int month;
    private int day;
    private String description;
    private String location;
    private List<String> images;
    private List<String> childrenImageList;

    @Builder
    public MemoryDetailResponseDto(String nickname, String userImage, long memoryId, int year, int month, int day, String description,
            String location, List<String> images, List<String> childrenImageList) {
        this.nickname = nickname;
        this.userImage = userImage;
        this.memoryId = memoryId;
        this.year = year;
        this.month = month;
        this.day = day;
        this.description = description;
        this.location = location;
        this.images = images;
        this.childrenImageList = childrenImageList;
    }
}
