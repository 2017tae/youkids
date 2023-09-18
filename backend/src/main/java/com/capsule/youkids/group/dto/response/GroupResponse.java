package com.capsule.youkids.group.dto.response;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Getter
public class GroupResponse {
    private UUID groupId;
    private UUID leaderId;
    private String groupName;
    private String groupImg;

    @Builder
    public GroupResponse(UUID groupId, UUID leaderId, String groupName, String groupImg) {
        this.groupId = groupId;
        this.leaderId = leaderId;
        this.groupName = groupName;
        this.groupImg = groupImg;
    }
}
