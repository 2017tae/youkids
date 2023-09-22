package com.capsule.youkids.children.dto.request;

import java.time.LocalDate;
import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@Builder
@NoArgsConstructor
public class ChildrenRequest {

    private Long childrenId;
    private String parentEmail;
    private String name;
    private int gender;
    private LocalDate birthday;
    private String childrenImage;

    // 애기 성향
}
