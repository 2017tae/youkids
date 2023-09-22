package com.capsule.youkids.course.dto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class DeleteCourseRequestDto {

    private UUID courseId;
    private UUID userId;
}
