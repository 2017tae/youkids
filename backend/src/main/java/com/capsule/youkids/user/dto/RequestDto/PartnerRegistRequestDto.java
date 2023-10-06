package com.capsule.youkids.user.dto.RequestDto;

import java.util.UUID;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PartnerRegistRequestDto {
    private UUID userId;
    private UUID partnerId;
}
