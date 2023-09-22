package com.capsule.youkids.group.dto.response;

import java.util.UUID;
import lombok.Builder;
import lombok.Getter;

@Getter
public class GroupResponse {
    private UUID groupId;
    private String leaderEmail;
    private String groupName;
    private String groupImg;

    @Builder
    public GroupResponse(UUID groupId, String leaderEmail, String groupName, String groupImg) {
        this.groupId = groupId;
        this.leaderEmail = leaderEmail;
        this.groupName = groupName;
        this.groupImg = groupImg;
    }
}
