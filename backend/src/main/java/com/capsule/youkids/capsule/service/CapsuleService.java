package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import java.util.UUID;

public interface CapsuleService {

    /**
     * 유저 아이디를 통해서 아이디가 가입된 모든 그룹을 확인하고, 모든 그룹의 캡슐 리스트를 가져온다.
     *
     * @param userId
     * @return CapsuleListResponseDto
     */
    public CapsuleListResponseDto getCapsuleList(UUID userId);

    /**
     * 캡슐 아이디를 통해서 캡슐 아이디에 해당하는 모든 메모리를 반환한다.
     *
     * @param capsuleId
     * @return MemoryListResponseDto
     */
    public MemoryListResponseDto getMemoryList(int capsuleId);
}
