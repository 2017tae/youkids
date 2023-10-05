package com.capsule.youkids.capsule.dto;

import java.util.List;
import java.util.UUID;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CapsuleResponseDto {

    private UUID groupId;
    private UUID groupLeader;
    private String groupLeaderImage;
    private List<CapsuleDto> capsules;

    @Builder
    public CapsuleResponseDto(UUID groupId, UUID groupLeader, String groupLeaderImage, List<CapsuleDto> capsules) {
        this.groupId = groupId;
        this.groupLeader = groupLeader;
        this.groupLeaderImage = groupLeaderImage;
        this.capsules = capsules;
    }

}
