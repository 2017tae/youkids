package com.capsule.youkids.children.dto.request;

import java.time.LocalDate;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChildrenRegistRequest {
    private UUID parentId;
    private String name;
    private int gender;
    private LocalDate birthday;
    private String childrenImage;
}
