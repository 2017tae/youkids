package com.capsule.youkids.group.service;

import com.capsule.youkids.group.dto.request.GroupUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupPK;
import com.capsule.youkids.group.entity.Group;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.ArrayList;
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
    public void addUserInGroup(GroupUserRequest groupUserRequest) {
        Optional<User> leader = userRepository.findById(groupUserRequest.getLeaderId());
        Optional<User> user = userRepository.findById(groupUserRequest.getUserId());
        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }
        // 리더가 그룹이 없으면 에러~
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeader(leader.get());
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
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
    public void deleteUserFromGroup(GroupUserRequest groupUserRequest) {
        Optional<User> leader = userRepository.findById(groupUserRequest.getLeaderId());
        Optional<User> user = userRepository.findById(groupUserRequest.getUserId());
        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }
        // 리더가 그룹이 없으면 에러~
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeader(leader.get());
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }
        Optional<Group> group = groupRepository.findById(new GroupPK(groupInfo.get(), user.get()));
        // 이미 없으면 에러~
        if (group.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already not in the group");
        }
        // 삭제
        groupRepository.deleteById(new GroupPK(groupInfo.get(), user.get()));
    }

    @Override
    public GroupResponse getAllJoinedGroup(UUID userId) {
        Optional<User> user = userRepository.findById(userId);
        // 유저가 있으면 그룹에 속한 정보를 모두 불러와서
        if (user.isPresent()) {
            List<Group> groupList = groupRepository.getAllJoinedGroup(user.get());
            List<GroupInfo> groupInfoList = new ArrayList<>();
            // 그룹 정보를 추출해낸다~
            for (Group g : groupList) {
                groupInfoList.add(g.getGroupPK().getGroupInfo());
            }
            GroupResponse groupResponse = GroupResponse.builder().groupInfoList(groupInfoList).build();
            return groupResponse;
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user");
    }

    @Override
    public void updateGroupName(UpdateGroupRequest updateGroupRequest) {
        Optional<User> user = userRepository.findById(updateGroupRequest.getUserId());
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(updateGroupRequest.getGroupId());
        // 유저나 그룹 자체가 없는 경우
        if (user.isEmpty() || groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user or group");
        }
        Optional<Group> group = groupRepository.findById(GroupPK.builder().groupInfo(groupInfo.get()).user(user.get()).build());
        // 둘 다 있지만 속하지 않은 경우
        if (group.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "not in the group");
        }
        group.get().updateGroupName(updateGroupRequest.getGroupName());
    }

}
