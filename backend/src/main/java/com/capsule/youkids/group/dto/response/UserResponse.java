package com.capsule.youkids.group.dto.response;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Builder
@Getter
public class UserResponse {
    private UUID userId;
    private String nickname;
    private String profileImage;
}
