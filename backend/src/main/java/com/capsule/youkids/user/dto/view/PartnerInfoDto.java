package com.capsule.youkids.user.dto.view;

import com.capsule.youkids.user.entity.User;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PartnerInfoDto {

    private UUID partnerId;
    private String nickname;
    private String profileImage;
    private String partnerEmail;
    private String fcmToken;


    public PartnerInfoDto(User user) {
        this.partnerId = user.getUserId();
        this.nickname = user.getNickname();
        this.profileImage = user.getProfileImage();
        this.partnerEmail = user.getEmail();
        this.fcmToken = user.getFcmToken();
    }

}
