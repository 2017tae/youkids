package com.capsule.youkids.capsule.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryDeleteRequestDto {

    private long memory_id;
    private String email;
}
