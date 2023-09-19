package com.capsule.youkids.user.dto.RequestDto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class addUserInfoRequestDto {

    private UUID userId;

    private String nickname;

    private boolean car;

    private UUID partnerId;

    private String description;


}
