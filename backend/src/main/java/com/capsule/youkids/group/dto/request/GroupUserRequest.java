package com.capsule.youkids.group.dto.request;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Getter
public class GroupUserRequest {
    private UUID leaderId;
    private UUID userId;

    @Builder
    public GroupUserRequest(UUID leaderId, UUID userId) {
        this.leaderId = leaderId;
        this.userId = userId;
    }
}
