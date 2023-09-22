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
public class GroupUserRequest {
    private String leaderEmail;
    private String userEmail;

//    @Builder
//    public GroupUserRequest(String leaderEmail, String userEmail) {
//        this.leaderEmail = leaderEmail;
//        this.userEmail = userEmail;
//    }
}
