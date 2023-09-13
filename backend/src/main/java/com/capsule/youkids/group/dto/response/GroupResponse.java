package com.capsule.youkids.group.dto.response;

import com.capsule.youkids.group.entity.GroupInfo;
import java.util.List;
import java.util.UUID;
import lombok.Builder;

public class GroupResponse {
    private long groupId;
    private UUID leaderId;
    private String groupName;
    private String groupImg;

    @Builder
    public GroupResponse(long groupId, UUID leaderId, String groupName, String groupImg) {
        this.groupId = groupId;
        this.leaderId = leaderId;
        this.groupName = groupName;
        this.groupImg = groupImg;
    }
}
