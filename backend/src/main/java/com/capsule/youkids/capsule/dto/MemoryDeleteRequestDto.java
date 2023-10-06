package com.capsule.youkids.capsule.dto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryDeleteRequestDto {

    private long memoryId;
    private UUID userId;
}
