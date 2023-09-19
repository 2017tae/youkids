package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.entity.Capsule;
import com.capsule.youkids.capsule.entity.Memory;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.UUID;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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

    /**
     * 메모리를 생성한다.
     *
     * @param createMemoryRequestDto
     * @param multipartFileList
     * @return 생성이 잘 되었는지 안 됐는지
     */

    public Memory createMemory(CreateMemoryRequestDto createMemoryRequestDto, List<MultipartFile> multipartFileList);

    public Capsule createCapsule(User user, String url);
}
