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
import com.capsule.youkids.global.common.constant.Code;
import com.capsule.youkids.global.common.exception.RestApiException;
import com.capsule.youkids.global.s3.service.AwsS3Service;
import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.entity.Role;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.io.IOException;
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
    private final ChildrenRepository childrenRepository;
    private final AwsS3Service awsS3Service;

    /**
     * 유저 아이디를 통해서 아이디가 가입된 모든 그룹을 확인하고, 모든 그룹들의 리스트를 가져온다.
     *
     * @param userId
     * @return CapsuleListResponseDto
     */
    @Override
    public CapsuleListResponseDto getCapsuleList(UUID userId) {

        // userId를 통해서 탈퇴되지 않은 유저인지 확인 후 User 리턴
        User user = userRepository.findByUserIdAndRoleNot(userId, Role.DELETED)
                .orElseThrow(() -> new RestApiException(Code.USER_NOT_FOUND));

        // 유저의 그룹을 가져온다.
        List<GroupJoin> groups = groupJoinRepository.findByUserIdOrderByCreatedTime(userId);

        // 반환할 리스트를 선언해준다.
        List<CapsuleResponseDto> capsuleResponseDtos = new LinkedList<>();

        for (GroupJoin group : groups) {
            // 그룹의 그룹 리더를 가져온다.
            UUID groupLeader = group.getGroupId();

            // leader의 객체를 가져온다.
            // 유저를 가져올 때 유효한 role인지도 확인 해줘야함.
            Optional<User> leader = userRepository.findByUserIdAndRoleNot(groupLeader,
                    Role.DELETED);

            // 만약 그룹장이 탈퇴했다면 캡슐을 읽어오지 않는다.
            if (leader.isEmpty()) {
                continue;
            }

            // 만약 그룹장이 리더가 아니라면 (파트너에게 종속 되어 버렸다면)
            else if (!leader.get().isLeader()) {
                // 만약 본인이라면 파트너 아이디로 바꿔서 가져오고 아니라면 그냥 다른 그룹을 확인한다.
                if (!leader.get().equals(user)) {
                    continue;
                } else {
                    leader = userRepository.findByUserIdAndRoleNot(leader.get().getPartnerId(),
                            Role.DELETED);
                }
            }

            // 그룹장의 id로 모든 캡슐을 검색해서 가져온다.
            List<Capsule> capsules = capsuleRepository.findAllByUser(leader.get());

            // 가져온 캡슐에 대한 내용을 dto에 담는다.
            List<CapsuleDto> capsuleDtoList = new ArrayList<>();

            for (Capsule capsule : capsules) {

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
                    .groupId(group.getGroupId())
                    .build();

            capsuleResponseDtos.add(capsuleResponseDto);
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
        // 캡슐이 없다면 에러 발생
        Capsule capsule = capsuleRepository.findById(capsuleId)
                .orElseThrow(() -> new RestApiException(Code.CAPSULE_NOT_FOUND));

        // 반환 하기 위한 dto 생성
        MemoryListResponseDto memoryListResponseDto = new MemoryListResponseDto();

        // 캡슐에서 메모리들을 가져온다.
        for (Memory memory : capsule.getMemories()) {
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
                    .memoryId(memory.getMemoryId())
                    .month(memory.getMonth())
                    .day(memory.getDay())
                    .memoryImageDtoList(memoryImageDtoList)
                    .build();

            memoryListResponseDto.getMemoryResponseDtoList().add(memoryResponseDto);
        }

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
    public void createMemory(CreateMemoryRequestDto request,
            List<MultipartFile> multipartFileList) {

        // 우선 메모리를 생성한다.
        Memory memory = Memory.builder()
                .date()
                .description(request.getDescription())
                .location(request.getLocation() == null ? "" : request.getLocation())
                .build();

        // -----------------------------
        // 유저가 없으면 에러 발생~~~~~~~
        // -----------------------------
        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
                .orElseThrow(() -> new RestApiException(Code.USER_NOT_FOUND));

        if (!user.isLeader()) {
            user = userRepository.findByUserIdAndRoleNot(user.getPartnerId(), Role.DELETED)
                    .orElseThrow(() -> new RestApiException(Code.USER_NOT_FOUND));
        }

        // 생성된 메모리에 메모리 이미지를 연결한다.
        // S3에 저장한다.
        List<MemoryImage> memoryImages = new ArrayList<>();
        if (multipartFileList != null) {
            for (MultipartFile multipartFile : multipartFileList) {
                // S3를 사용해서 파일 저장 해야한다.
                try {
                    // S3에 저장하고 파일을 업로드 한다.
                    String fileUrl = awsS3Service.uploadFile(multipartFile);
                    MemoryImage memoryImage = MemoryImage.builder()
                            .memoryUrl(fileUrl)
                            .memory(memory)
                            .build();

                    memoryImageRepository.save(memoryImage);
                    memoryImages.add(memoryImage);
                } catch (IOException e) {
                    throw new RestApiException(Code.S3_SAVE_ERROR);
                }
            }
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
                    // 아이를 찾는다.
                    Children children = childrenRepository.findById(child)
                            .orElseThrow(() -> new RestApiException(Code.CHILDREN_NOT_FOUND));

                    // 메모리와 아이를 매핑한다.
                    MemoryChildren memoryChildren = MemoryChildren.builder()
                            .memoryImage(memoryImages.get(idx))
                            .children(children)
                            .build();

                    memoryChildrenRepository.save(memoryChildren);

                    // children.add(memoryChildren) 해줘야한다.
                    children.getMemoryChildrenList().add(memoryChildren);
                    memoryImages.get(idx).getMemoryChildrenList().add(memoryChildren);
                }
            }
        }

        // 캡슐이 있는지 확인 후 있다면 캡슐에 메모리 저장
        Capsule capsule = capsuleRepository
                .findByUserAndYear(user, LocalDate.now().getYear())
                .orElse(null);

        // 캡슐이 없다면 새로 생성하고, 캡슐에 이미지가 없다면 처음에 들어간 이미지를 추가해준다.
        if (capsule == null) {
            if (memoryImages != null) {
                capsule = createCapsule(user, memoryImages.get(0).getMemoryUrl());
            } else {
                capsule = createCapsule(user);
            }
        } else if (capsule.getUrl() == null) {
            if (multipartFileList != null) {
                capsule.setUrl(memoryImages.get(0).getMemoryUrl());
            }
        }

        memory.setCapsule(capsule);
        memory.setMemoryImages(memoryImages);
        capsule.getMemories().add(memory);

        if (!memory.equals(memoryRepository.save(memory))) {
            throw new RestApiException(Code.MEMORY_SAVE_ERROR);
        }
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
    public Capsule createCapsule(User user, String url) throws RestApiException {

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

    @Override
    @Transactional
    public Capsule createCapsule(User user) {

        int year = LocalDate.now((ZoneId.of("Asia/Seoul"))).getYear();

        // 여기에서 파트너 아이디랑 확인해서 생성 해야한다.
        // 캡슐을 생성한다.
        Capsule capsule = Capsule.builder()
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
    @Transactional
    public void updateMemory(MemoryUpdateRequestDto request) throws RestApiException {

        LocalDate ld = LocalDate.now((ZoneId.of("Asia/Seoul")));

        // 수정할 메모리가 없다면 에러 보내야됨
        Memory memory = memoryRepository.findById(request.getMemoryId())
                .orElseThrow(() -> new RestApiException(Code.MEMORY_NOT_FOUND));

        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
                .orElseThrow(() -> new RestApiException(Code.MEMORY_UPDATE_NOT_PERMITTED));

        if (!user.isLeader()) {
            user = userRepository.findByUserIdAndRoleNot(user.getPartnerId(), Role.DELETED)
                    .orElseThrow(() -> new RestApiException(Code.MEMORY_UPDATE_NOT_PERMITTED));
        }

        LocalDate memoryDay = LocalDate.of(memory.getYear(), memory.getMonth(), memory.getDay());

        long dayDiff = ChronoUnit.DAYS.between(memoryDay, ld);

        // 수정 날짜가 지났다면 오류
        if (dayDiff > 7) {
            throw new RestApiException(Code.MEMORY_UPDATE_TIME_LIMIT_EXPIRED);
        }

        memory.updateMemory(request);
    }

    /**
     * 메모리를 삭제하는 함수
     *
     * @param request MemoryDeleteRequestDto : {memory_id, email}
     * @return 삭제가 됐는지 안됐는지 리턴
     */
    @Override
    @Transactional
    public void deleteMemory(MemoryDeleteRequestDto request) throws RestApiException {

        // 유저가 없으면 오류
        User user = userRepository.findByUserIdAndRoleNot(request.getUserId(), Role.DELETED)
                .orElseThrow(() -> new RestApiException(Code.USER_NOT_FOUND));

        // 메모리가 없으면 오류
        Memory memory = memoryRepository.findById(request.getMemoryId())
                .orElseThrow(() -> new RestApiException(Code.MEMORY_NOT_FOUND));

        // 메모리와 유저의 관계가 있는지 확인해서 없다면 오류

        if (!user.isLeader()) {
            user = userRepository.findByUserIdAndRoleNot(user.getPartnerId(), Role.DELETED)
                    .orElseThrow(() -> new RestApiException(Code.MEMORY_DELETE_NOT_PERMITTED));
        }

        if (!user.equals(memory.getCapsule().getUser())) {
            throw new RestApiException(Code.MEMORY_DELETE_NOT_PERMITTED);
        }

        // 현재 시간과 메모리가 저장되었던 시간을 체크하는 로직

        LocalDate ld = LocalDate.now((ZoneId.of("Asia/Seoul")));

        LocalDate memoryDay = LocalDate.of(memory.getYear(), memory.getMonth(), memory.getDay());

        long dayDiff = ChronoUnit.DAYS.between(memoryDay, ld);

        // 수정 날짜가 지났다면 오류
        if (dayDiff > 7) {
            throw new RestApiException(Code.MEMORY_DELETE_TIME_LIMIT_EXPIRED);
        }

        memoryRepository.delete(memory);
    }

    /**
     * 특정 메모리 상세 정보를 리턴하는 함수
     *
     * @param memoryId
     * @return MemoryDetailResponseDto : {year, month, day, description, location, images[],
     * childrenImageList[]}
     */
    @Override
    public MemoryDetailResponseDto getMemoryDetail(long memoryId) throws RestApiException {

        // 메모리가 없다면 에러 호출
        Memory memory = memoryRepository.findById(memoryId)
                .orElseThrow(() -> new RestApiException(Code.MEMORY_NOT_FOUND));

        // 모든 사진들에 대한 아이의 중복을 없애기 위해 사용
        Set<String> child = new HashSet<>();

        // 메모리 이미지들 가져오기
        List<MemoryImage> memoryImageList = memory.getMemoryImages();

        List<String> childrenImageList;
        List<String> imageList = new ArrayList<>();

        // 이미지에 대한 아이들 리스트 가져오기
        for (MemoryImage memoryImage : memoryImageList) {
            imageList.add(memoryImage.getMemoryUrl());
            for (MemoryChildren memoryChildren : memoryImage.getMemoryChildrenList()) {
                child.add(memoryChildren.getChildren().getChildrenImage());
            }
        }

        childrenImageList = new ArrayList<>(child);

        MemoryDetailResponseDto response = MemoryDetailResponseDto.builder()
                .memoryId(memory.getMemoryId())
                .year(memory.getYear())
                .month(memory.getMonth())
                .day(memory.getDay())
                .description(memory.getDescription())
                .location(memory.getLocation())
                .images(imageList)
                .childrenImageList(childrenImageList)
                .build();

        return response;
    }
}
