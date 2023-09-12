package com.capsule.youkids.children.dto.response;

import java.time.LocalDate;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
@AllArgsConstructor
public class ChildrenResponse {

    private long childrenId;
    private UUID parentId;
    private String name;
    private int gender;
    private LocalDate birthday;
    private String childrenImage;
}
