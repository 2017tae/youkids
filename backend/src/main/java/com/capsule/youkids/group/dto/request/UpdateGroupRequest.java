package com.capsule.youkids.group.dto.request;

import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateGroupRequest {
    private UUID groupId;
    private String email;
    private String groupName;

//    @Builder
//    public UpdateGroupRequest(UUID groupId, String email, String groupName) {
//        this.groupId = groupId;
//        this.email = email;
//        this.groupName = groupName;
//    }
}
