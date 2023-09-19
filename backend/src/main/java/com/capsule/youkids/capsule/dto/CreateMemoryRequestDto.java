package com.capsule.youkids.capsule.dto;

import com.capsule.youkids.capsule.dto.MemoryResponseDto.MemoryImageDto;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CreateMemoryRequestDto {

    private String description;
    private String location;
    private List<List<Long>> childrenList;

    @Builder
    public CreateMemoryRequestDto(String description, String location,
            List<List<Long>> childrenList) {
        this.description = description;
        this.location = location;
        this.childrenList = childrenList;
    }
}
