package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import java.util.UUID;

public interface CapsuleService {

    /**
     * 유저 아이디를 통해서 아이디가 가입된 모든 그룹을 확인하고, 모든 그룹의 캡슐 리스트를 가져온다.
     *
     * @param userId
     * @return CapsuleListResponseDto
     */
    public CapsuleListResponseDto getCapsuleList(UUID userId);
}
