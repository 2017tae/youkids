package com.capsule.youkids.group.service;

import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupPK;
import com.capsule.youkids.group.entity.Group;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.parameters.P;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class GroupServiceImpl implements GroupService {


    private final GroupInfoRepository groupInfoRepository;
    private final GroupRepository groupRepository;
    private final UserRepository userRepository;

    @Override
    public void addUserInGroup(Long groupId, UUID userId) {
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(groupId);
        Optional<User> user = userRepository.findById(userId);
        // 해당 그룹이나 유저가 없으면 에러~
        if (groupInfo.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group or user exists");
        }
        Optional<Group> group = groupRepository.findById(new GroupPK(groupInfo.get(), user.get()));
        // 이미 추가되어 있으면 에러~
        if (group.isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already exists");
        }
        // 일단은 소속 관계 엔티티 저장하고 그룹 이름은 나중에 설정~
        Group newGroup = Group.builder().groupInfo(groupInfo.get()).build();
        groupRepository.save(newGroup);
    }

    @Override
    public void deleteUserFromGroup(Long groupId, UUID userId) {
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(groupId);
        Optional<User> user = userRepository.findById(userId);
        // 해당 그룹이나 유저가 없으면 에러~
        if (groupInfo.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group or user exists");
        }
        Optional<Group> group = groupRepository.findById(new GroupPK(groupInfo.get(), user.get()));
        // 이미 없으면 에러~
        if (group.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "already not in the group");
        }
        // 삭제
        groupRepository.deleteById(new GroupPK(groupInfo.get(), user.get()));
    }

    @Override
    public List<GroupInfo> getAllJoinedGroup(UUID userId) {
        Optional<User> user = userRepository.findById(userId);
        List<Group> groups = groupRepository.findAllByUserId(userId);
    }

    @Override
    public void updateGroupName(Long groupId, UUID userId, String groupName) {

    }

}
