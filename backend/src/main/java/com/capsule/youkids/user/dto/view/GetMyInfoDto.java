package com.capsule.youkids.user.dto.view;

import com.capsule.youkids.user.entity.User;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GetMyInfoDto {

    private String email;

    private String nickname;

    private String profileImage;

    private String description;

    public GetMyInfoDto(User user) {
        this.email = user.getEmail();
        this.nickname = user.getNickname();
        this.profileImage = user.getProfileImage();
        this.description = user.getDescription();
    }

}
