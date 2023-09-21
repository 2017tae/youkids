package com.capsule.youkids.capsule.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class MemoryUpdateRequestDto {

    private long memory_id;
    private String description;
    private String location;
    private String email;
}