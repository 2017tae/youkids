package com.capsule.youkids.user.dto.ResponseDto;

import com.capsule.youkids.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GetMyInfoResponseDto {

    private String email;

    private String nickname;

    private String profileImage;

    public GetMyInfoResponseDto (User user){
        this.email=user.getEmail();
        this.nickname=user.getNickname();
        this.profileImage=user.getProfileImage();
    }

}
