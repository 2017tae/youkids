package com.capsule.youkids.capsule.dto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryUpdateRequestDto {

    private long memoryId;
    private String description;
    private String location;
    private UUID userId;
}
