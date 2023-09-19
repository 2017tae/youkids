package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleDto;
import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CapsuleResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryResponseDto;
import com.capsule.youkids.capsule.dto.MemoryResponseDto.MemoryImageDto;
import com.capsule.youkids.capsule.entity.Capsule;
import com.capsule.youkids.capsule.entity.Memory;
import com.capsule.youkids.capsule.entity.MemoryChildren;
import com.capsule.youkids.capsule.entity.MemoryImage;
import com.capsule.youkids.capsule.repository.CapsuleRepository;
import com.capsule.youkids.capsule.repository.MemoryChildrenRepository;
import com.capsule.youkids.capsule.repository.MemoryImageRepository;
import com.capsule.youkids.capsule.repository.MemoryRepository;
import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.children.repository.ChildrenRepository;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class CapsuleServiceImpl implements CapsuleService {

    private final CapsuleRepository capsuleRepository;
    private final MemoryRepository memoryRepository;
    private final MemoryImageRepository memoryImageRepository;
    private final MemoryChildrenRepository memoryChildrenRepository;
    private final UserRepository userRepository;
    private final GroupJoinRepository groupJoinRepository;
    private final GroupInfoRepository groupInfoRepository;
    private final ChildrenRepository childrenRepository;

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

        MemoryListResponseDto memoryListResponseDto = new MemoryListResponseDto();

        if (!capsule.isEmpty()) {
            for (Memory memory : capsule.get().getMemories()) {
                List<MemoryImageDto> memoryImageDtoList = new ArrayList<>();
                for (MemoryImage memoryImage : memory.getMemoryImages()) {

                    List<Long> childrenList = new ArrayList<>();
                    for (MemoryChildren memoryChildren : memoryImage.getChildren()) {
                        childrenList.add(memoryChildren.getChildren().getChildrenId());
                    }
                    MemoryImageDto memoryImageDto = MemoryImageDto.builder()
                            .childrenList(childrenList)
                            .url(memoryImage.getMemoryUrl())
                            .build();

                    memoryImageDtoList.add(memoryImageDto);
                }

                MemoryResponseDto memoryResponseDto = MemoryResponseDto.builder()
                        .month(memory.getMonth())
                        .day(memory.getDay())
                        .memoryImageDtoList(memoryImageDtoList)
                        .build();

                memoryListResponseDto.getMemoryResponseDtoList().add(memoryResponseDto);
            }
        } else {
            // 해당하는 캡슐이 없다는 오류를 보내주면 된다.
        }

        return memoryListResponseDto;
    }

    /**
     * 메모리를 생성한다.
     *
     * @param createMemoryRequestDto
     * @param multipartFileList
     * @return 생성이 잘 되었는지 안 됐는지
     */
    @Override
    @Transactional
    public boolean createMemory(CreateMemoryRequestDto createMemoryRequestDto,
            List<MultipartFile> multipartFileList) {

        Memory memory = Memory.builder()
                .date()
                .description(createMemoryRequestDto.getDescription())
                .location(createMemoryRequestDto.getLocation())
                .build();

        List<MemoryImage> memoryImages = new ArrayList<>();
        for (MultipartFile multipartFile : multipartFileList) {
            // S3를 사용해서 파일 저장 해야한다.
            // 변경해줘야해.
            String fileUrl = "";
            MemoryImage memoryImage = MemoryImage.builder()
                    .memoryUrl(fileUrl)
                    .memory(memory)
                    .build();

            memoryImageRepository.save(memoryImage);
            memoryImages.add(memoryImage);
        }

        List<List<Long>> childrenList = createMemoryRequestDto.getChildrenList();

        if (childrenList != null && !childrenList.isEmpty()) {
            for (int idx = 0; idx < childrenList.size(); ++idx) {
                List<MemoryChildren> mcList = new ArrayList<>();
                for (Long child : childrenList.get(idx)) {
                    Children children = childrenRepository.findById(child).orElseThrow();

                    MemoryChildren memoryChildren = MemoryChildren.builder()
                            .memoryImage(memoryImages.get(idx))
                            .children(children)
                            .build();

                    memoryChildrenRepository.save(memoryChildren);

                    // children.add(memoryChildren) 해줘야한다.
                    memoryImages.get(idx).getMemoryChildrenList().add(memoryChildren);
                }
            }
        }

        // 여기 유저 부분 변경해야된다.
        // 변경점
        Capsule capsule = capsuleRepository.findByUserAndYear(userRepository.findByUserId(
                UUID.fromString("1")).get(), memory.getYear()).orElse(null);

        if (capsule.equals(null)) {
            // 유저 변경해야해.
            capsule = createCapsule(new User(), memoryImages.get(0).getMemoryUrl());
        }

        capsule.getMemories().add(memory);

        return memory.equals(memoryRepository.save(memory));
    }

    @Override
    @Transactional
    public Capsule createCapsule(User user, String url) {

        int year = LocalDate.now().getYear();

        Capsule capsule = Capsule.builder()
                .url(url)
                .year(year)
                .user(user)
                .build();

        return capsuleRepository.save(capsule);
    }
}
