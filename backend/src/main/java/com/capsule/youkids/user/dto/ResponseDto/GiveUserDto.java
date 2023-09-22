package com.capsule.youkids.user.dto.ResponseDto;

import com.capsule.youkids.user.entity.User;
import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class GiveUserDto {

    private UUID userId;
    private boolean newUser;

    public GiveUserDto(User user, boolean newUser){
        this.userId = user.getUserId();
        this.newUser = newUser;
    }

}
