package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryUpdateRequestDto;
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

    public boolean createMemory(CreateMemoryRequestDto createMemoryRequestDto,
            List<MultipartFile> multipartFileList);

    /**
     * 컨트롤러 단에서는 실행되지 않는 함수. 메모리 생성하는 함수에서 실행된다. 캡슐을 생성한다.
     *
     * @param user 현재 사용중인 유저
     * @param url
     * @return 캡슐이 생성 되었다면 캡슐을 리턴한다.
     */
    public Capsule createCapsule(User user, String url);

    /**
     * 메모리 수정 하는 함수
     *
     * @param dto MemoryUpdateRequestDto 업데이트에 필요한 MemoryId, location, description
     * @return 업데이트가 잘 되었는지 확인
     */
    public boolean updateMemory(MemoryUpdateRequestDto dto);
}
