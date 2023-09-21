package com.capsule.youkids.capsule.service;

import com.capsule.youkids.capsule.dto.CapsuleDto;
import com.capsule.youkids.capsule.dto.CapsuleListResponseDto;
import com.capsule.youkids.capsule.dto.CapsuleResponseDto;
import com.capsule.youkids.capsule.dto.CreateMemoryRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDeleteRequestDto;
import com.capsule.youkids.capsule.dto.MemoryDetailResponseDto;
import com.capsule.youkids.capsule.dto.MemoryListResponseDto;
import com.capsule.youkids.capsule.dto.MemoryResponseDto;
import com.capsule.youkids.capsule.dto.MemoryResponseDto.MemoryImageDto;
import com.capsule.youkids.capsule.dto.MemoryUpdateRequestDto;
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
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
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

            // 만약 그룹장이 탈퇴했다면
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

        // 캡슐을 가져온다.
        Optional<Capsule> capsule = capsuleRepository.findById(capsuleId);

        // 반환 하기 위한 dto 생성
        MemoryListResponseDto memoryListResponseDto = new MemoryListResponseDto();

        // 만약 캡슐이 없다면 에러
        if (!capsule.isEmpty()) {
            // 캡슐에서 메모리들을 가져온다.
            for (Memory memory : capsule.get().getMemories()) {
                // 반환할 이미지 dto 리스트 생성
                List<MemoryImageDto> memoryImageDtoList = new ArrayList<>();

                // 메모리에서 메모리 사진을 가져온다.
                for (MemoryImage memoryImage : memory.getMemoryImages()) {

                    // 아이들을 저장할 리스트 배열을 생성한다.
                    List<Long> childrenList = new ArrayList<>();

                    // 메모리 사진에 대한 아이들을 가져와서 리스트 배열에 저장한다.
                    for (MemoryChildren memoryChildren : memoryImage.getMemoryChildrenList()) {
                        childrenList.add(memoryChildren.getChildren().getChildrenId());
                    }

                    // 메모리 이미지 dto를 생성한다.
                    MemoryImageDto memoryImageDto = new MemoryImageDto(memoryImage.getMemoryUrl(),
                            childrenList);

                    // 리스트에 저장한다.
                    memoryImageDtoList.add(memoryImageDto);
                }

                // 반환값에 추가한다.
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

        MemoryDetailResponseDto memoryDetailResponseDto = MemoryDetailResponseDto.builder()
                .year(2000)
                .build();

        System.out.println(memoryDetailResponseDto.getImages());

        return memoryListResponseDto;
    }

    /**
     * 메모리를 생성한다.
     *
     * @param request
     * @param multipartFileList
     * @return 생성이 잘 되었는지 안 됐는지
     */
    @Override
    @Transactional
    public boolean createMemory(CreateMemoryRequestDto request,
            List<MultipartFile> multipartFileList) {

        // 우선 메모리를 생성한다.
        Memory memory = Memory.builder()
                .date()
                .description(request.getDescription())
                .location(request.getLocation())
                .build();

        // -----------------------------
        // 유저가 없으면 에러 발생~~~~~~~
        // -----------------------------
        User user = userRepository.findByEmail(request.getEmail()).orElseThrow();

        // 생성된 메모리에 메모리 이미지를 연결한다.
        // S3에 저장한다.
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

        // 사진에 하나 하나에 대한 아이 태그 확인
        // 사진에 태그를 연결 및 아이에게 사진을 연결
        List<List<Long>> childrenList = request.getChildrenList();
        // 만약 아이 리스트가 없다면 실행하지 않는다.
        if (childrenList != null && !childrenList.isEmpty()) {
            for (int idx = 0; idx < childrenList.size(); ++idx) {
                List<MemoryChildren> mcList = new ArrayList<>();
                if (childrenList.get(idx).isEmpty()) {
                    continue;
                }
                for (Long child : childrenList.get(idx)) {
                    Children children = childrenRepository.findById(child).orElse(null);

                    MemoryChildren memoryChildren = MemoryChildren.builder()
                            .memoryImage(memoryImages.get(idx))
                            .children(children)
                            .build();

                    memoryChildrenRepository.save(memoryChildren);

                    // 추가해야함
                    // children.add(memoryChildren) 해줘야한다.
                    memoryImages.get(idx).getMemoryChildrenList().add(memoryChildren);
                }
            }
        }

        // 캡슐이 있는지 확인 후 있다면 캡슐에 메모리 저장
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

    /**
     * 컨트롤러 단에서는 실행되지 않는 함수. 메모리 생성하는 함수에서 실행된다. 캡슐을 생성한다.
     *
     * @param user 현재 사용중인 유저
     * @param url
     * @return 캡슐이 생성 되었다면 캡슐을 리턴한다.
     */

    @Override
    @Transactional
    public Capsule createCapsule(User user, String url) {

        int year = LocalDate.now((ZoneId.of("Asia/Seoul"))).getYear();

        // 여기에서 파트너 아이디랑 확인해서 생성 해야한다.
        // 캡슐을 생성한다.
        Capsule capsule = Capsule.builder()
                .url(url)
                .year(year)
                .user(user)
                .build();

        return capsuleRepository.save(capsule);
    }

    /**
     * 메모리 수정 하는 함수
     *
     * @param request MemoryUpdateRequestDto 업데이트에 필요한 MemoryId, location, description
     * @return 업데이트가 잘 되었는지 확인
     */
    @Override
    public boolean updateMemory(MemoryUpdateRequestDto request) {

        LocalDate ld = LocalDate.now((ZoneId.of("Asia/Seoul")));

        // 수정할 메모리가 없다면 에러 보내야됨
        Memory memory = memoryRepository.findById(request.getMemory_id()).orElseThrow();

        // 여기 메모리의 주인이 누구인지 확인해야할거 같은데
        // 메모리의 주인이 아니라면 에러 처리 해야할거 같아.
        if (!memory.getCapsule().getUser().getEmail().equals(request.getEmail())) {
            if (memory.getCapsule().getUser().getPartnerId() != null) {
                User user = userRepository.findByUserId(
                        memory.getCapsule().getUser().getPartnerId()).get();

                if (!user.getEmail().equals(request.getEmail())) {
                    // 여기는 메모리의 주인이 아니라는 에러 던져줘야한다.
                    return false;
                }
            } else {
                // 이거는 메모리의 주인이 아니라는 에러 던져줘야한다.
                return false;
            }
        }

        LocalDate memoryDay = LocalDate.of(memory.getYear(), memory.getMonth(), memory.getDay());

        long dayDiff = ChronoUnit.DAYS.between(memoryDay, ld);

        if (dayDiff > 5) {
            // 이거 에러  처리 해줘야하나?
            // 수정 가능 날짜가 지나버림!
            return false;
        }

        memory.updateMemory(request);

        return true;
    }

    /**
     * 메모리를 삭제하는 함수
     *
     * @param request MemoryDeleteRequestDto : {memory_id, email}
     * @return 삭제가 됐는지 안됐는지 리턴
     */
    @Override
    public boolean deleteMemory(MemoryDeleteRequestDto request) {

        // 유저가 없어. 그러면 삐이ㅏ이잉익 에러
        User user = userRepository.findByEmail(request.getEmail()).orElseThrow();

        // 메모리가 없으면 오류!!!! 보내줘야해
        Memory memory = memoryRepository.findById(request.getMemory_id()).orElseThrow();

        // 파트너를 저장할 객체 생성
        User partner = null;

        if (user.getPartnerId() != null) {
            partner = userRepository.findByUserId(user.getPartnerId()).get();
        }

        if (partner == null && user != memory.getCapsule().getUser()) {
            return false;
        }

        if (partner != memory.getCapsule().getUser() && user != memory.getCapsule().getUser()) {
            return false;
        }

        memoryRepository.delete(memory);

        return true;
    }

    /**
     * 특정 메모리 상세 정보를 리턴하는 함수
     *
     * @param memoryId
     * @return MemoryDetailResponseDto : {year, month, day, description, location, images[],
     * childrenImageList[]}
     */
    @Override
    public MemoryDetailResponseDto getMemoryDetail(long memoryId) {

        // 메모리가 없다면 에러 호출
        Memory memory = memoryRepository.findById(memoryId).orElseThrow();

        // 모든 사진들에 대한 아이의 중복을 없애기 위해 사용
        Set<String> child = new HashSet<>();

        List<MemoryImage> memoryImageList = memory.getMemoryImages();

        List<String> childrenImageList;
        List<String> imageList = new ArrayList<>();

        for(MemoryImage memoryImage : memoryImageList){
            imageList.add(memoryImage.getMemoryUrl());
            for(MemoryChildren memoryChildren: memoryImage.getMemoryChildrenList()){
                child.add(memoryChildren.getChildren().getChildrenImage());
            }
        }

        childrenImageList = new ArrayList<>(child);

        MemoryDetailResponseDto response = MemoryDetailResponseDto.builder()
                .year(memory.getYear())
                .month(memory.getMonth())
                .day(memory.getDay())
                .description(memory.getDescription())
                .location(memory.getLocation())
                .images(imageList)
                .childrenImageList(childrenImageList)
                .build();

        return response ;
    }
}
