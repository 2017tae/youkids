package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleDto;
import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CapsuleResponseDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryResponseDto;
import com.capsule.youkids.capsule.entity.Capsule;
import com.capsule.youkids.capsule.entity.Memory;
import com.capsule.youkids.capsule.repository.CapsuleRepository;
import com.capsule.youkids.capsule.repository.MemoryImageRepository;
import com.capsule.youkids.capsule.repository.MemoryRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CapsuleServiceImpl implements CapsuleService {

    private final CapsuleRepository capsuleRepository;
    private final MemoryRepository memoryRepository;
    private final MemoryImageRepository memoryImageRepository;
    private final UserRepository userRepository;
    //private final GroupRepository groupRepository;
    //private final GroupInfoRepository groupInfoRepository;

    /**
     * 유저 아이디를 통해서 아이디가 가입된 모든 그룹을 확인하고, 모든 그룹들의 리스트를 가져온다.
     *
     * @param userId
     * @return CapsuleListResponseDto
     */
    @Override
    public CapsuleListResponseDto getCapsuleList(UUID userId) {

        // List<Integer> groupList = groupRepository(userId);
        // 위 배열로 교체해야한다.
        List<Integer> groups = new ArrayList<>();

        List<CapsuleResponseDto> capsuleResponseDtos = new LinkedList<>();

        for (int group : groups) {
            // UUID groupLeader = groupInfoRepository.findByGroupId(group);
            // 위의 식으로 변경 해줘야 한다.
            UUID groupLeader = null;

            // leader의 객체를 가져온다.
            // 유저를 가져올 때 유효한 role인지도 확인 해줘야함.
            Optional<User> leader = userRepository.findById(groupLeader);

            // 만약 그룹장이
            if (leader.isEmpty()) {
                continue;
            }

            // 그룹장의 id로 모든 캡슐을 검색해서 가져온다.
            List<Capsule> capsules = capsuleRepository.findAllByUser(leader.get());

            // 가져온 캡슐에 대한 내용을 dto에 담는다.
            List<CapsuleDto> capsuleDtoList = new ArrayList<>();

            for (Capsule capsule : capsules) {

                // url을 넣을지 말지 생각해봐야해.
                // Capsule entity를 DTO로 변환 시켜준다.
                CapsuleDto capsuleDto = CapsuleDto.builder()
                        .capsuleId(capsule.getCapsuleId())
                        .year(capsule.getYear())
                        .url(capsule.getUrl())
                        .build();

                capsuleDtoList.add(capsuleDto);
            }

            // 한 그룹에 대한 캡슐 전체 리스트를 저장
            CapsuleResponseDto capsuleResponseDto = CapsuleResponseDto.builder()
                    .groupLeader(groupLeader)
                    .capsules(capsuleDtoList)
                    .groupId(group)
                    .build();

            // 내 아이디랑 같은 그룹을 먼저 보여준다.
            if (groupLeader.equals(userId)) {
                capsuleResponseDtos.add(0, capsuleResponseDto);
            } else {
                capsuleResponseDtos.add(capsuleResponseDto);
            }
        }

        // CapsuleListReponseDto로 묶어서 보내준다.
        CapsuleListResponseDto capsuleListResponseDto = CapsuleListResponseDto.builder()
                .capsuleResponses(capsuleResponseDtos)
                .build();

        return capsuleListResponseDto;
    }

    /**
     * 캡슐 아이디를 통해서 캡슐 아이디에 해당하는 모든 메모리를 반환한다.
     *
     * @param capsuleId
     * @return MemoryListResponseDto
     */
    @Override
    public MemoryListResponseDto getMemoryList(int capsuleId) {

        Optional<Capsule> capsule = capsuleRepository.findById(capsuleId);

        MemoryListResponseDto memoryListResponseDto;

        if(!capsule.isEmpty()){
            for(Memory memory: capsule.get().getMemories()){
                MemoryResponseDto.MemoryImageDto memoryImageDto;
            }
        } else{

        }

        return null;
    }
}
