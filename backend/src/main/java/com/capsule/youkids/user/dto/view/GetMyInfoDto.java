package com.capsule.youkids.user.dto.view;

import com.capsule.youkids.user.entity.User;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GetMyInfoDto {

    private String email;

    private String nickname;

    private boolean leader;

    private String profileImage;

    private String description;

    private boolean car;

    public GetMyInfoDto(User user) {
        this.email = user.getEmail();
        this.nickname = user.getNickname();
        this.leader = user.isLeader();
        this.profileImage = user.getProfileImage();
        this.description = user.getDescription();
        this.car = user.isCar();
    }

}
