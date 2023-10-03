package com.capsule.youkids.user.dto.RequestDto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FcmTokenRequestDto {
    private UUID userId;
    private String fcmToken;
}
