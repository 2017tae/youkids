package com.capsule.youkids.group.dto.request;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Getter
public class UpdateGroupRequest {
    private UUID groupId;
    private UUID userId;
    private String groupName;

    @Builder
    public UpdateGroupRequest(UUID groupId, UUID userId, String groupName) {
        this.groupId = groupId;
        this.userId = userId;
        this.groupName = groupName;
    }
}
