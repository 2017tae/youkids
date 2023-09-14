package com.capsule.youkids.group.service;

import com.capsule.youkids.group.dto.request.GroupUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.dto.response.UserResponse;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.entity.User;
import com.capsule.youkids.user.repository.UserRepository;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class GroupServiceImpl implements GroupService {
    
    private final GroupInfoRepository groupInfoRepository;
    private final GroupJoinRepository groupJoinRepository;
    private final UserRepository userRepository;

    @Override
    public void addUserInGroup(GroupUserRequest groupUserRequest) throws Exception{
        Optional<User> leader = userRepository.findById(groupUserRequest.getLeaderId());
        Optional<User> user = userRepository.findById(groupUserRequest.getUserId());
        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }
        // 리더가 그룹이 없으면 에러~
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(leader.get().getUserId());
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }
        Long gid = groupInfo.get().getGroupId();
        UUID uid = user.get().getUserId();
        Optional<GroupJoin> group = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        // 이미 추가되어 있으면 에러~
        if (group.isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already exists");
        }

        // leader.equals(user) 면 내가 내 그룹을 만들자마자 속하는거
        // 아닐 경우 다른 사람에게 초대를 보내는거
        // *프론트에서 초대를 보낼때 sendInvite 같은거 해서 상대방에게 알람을 보낸 뒤 수락 시 이 서비스 수행하기*
        // 이미 등록된 경우 빠꾸먹이고, 아닐시 send

        // 등록 대상이 되는 유저가 속해있는 그룹의 수 + 1
        int newGroupIndex = groupJoinRepository.findByUserId(uid).size() + 1;

        String newGroupName = String.format("내 그룹 %d", newGroupIndex);

        GroupJoin newGroup = GroupJoin.builder()
                .groupId(gid)
                .userId(uid)
                .groupName(newGroupName)
                .build();
        groupJoinRepository.save(newGroup);
    }

    @Override
    public void deleteUserFromGroup(GroupUserRequest groupUserRequest) throws Exception {
        Optional<User> leader = userRepository.findById(groupUserRequest.getLeaderId());
        Optional<User> user = userRepository.findById(groupUserRequest.getUserId());
        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }
        // 리더가 그룹이 없으면 에러~
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(leader.get().getUserId());
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }
        Long gid = groupInfo.get().getGroupId();
        UUID uid = user.get().getUserId();
        Optional<GroupJoin> group = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        // 이미 없으면 에러~
        if (group.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already not in the group");
        }
        // 삭제
        groupJoinRepository.deleteByGroupIdAndUserId(gid, uid);

        // 그럼 알람을 보내말아
    }

    @Override
    public List<GroupResponse> getAllJoinedGroup(UUID userId) throws Exception {
        Optional<User> user = userRepository.findById(userId);
        // 유저가 있으면 그룹에 속한 정보를 모두 불러와서
        if (user.isPresent()) {
            List<GroupJoin> groupList = groupJoinRepository.findByUserId(userId);
            List<GroupResponse> groupResponseList = new ArrayList<>();
            // 그룹 정보를 추출해낸다~
            for (GroupJoin g : groupList) {
                Optional<GroupInfo> gi = groupInfoRepository.findById(g.getGroupId());
                GroupResponse gr = GroupResponse.builder().
                        groupId(g.getGroupId()).
                        leaderId(gi.get().getLeaderId()).
                        groupName(g.getGroupName()).
                        groupImg(gi.get().getGroupImg()).
                        build();
                groupResponseList.add(gr);
            }
            return groupResponseList;
        }
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user");
    }

    @Override
    public List<UserResponse> getAllJoinedUser(Long groupId) throws Exception {
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(groupId);
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "no group");
        }
        List<GroupJoin> groupJoinList = groupJoinRepository.findByGroupId(groupInfo.get().getGroupId());
        List<UserResponse> userResponseList = new ArrayList<>();
        for (GroupJoin gr : groupJoinList) {
            Optional<User> u = userRepository.findById(gr.getUserId());
            UserResponse ur = UserResponse.builder()
                    .userId(u.get().getUserId())
                    .nickname(u.get().getNickname())
                    .profileImage(u.get().getProfileImage())
                    .build();
            userResponseList.add(ur);
        }
        return userResponseList;
    }

    @Override
    public void updateGroupName(UpdateGroupRequest updateGroupRequest) throws Exception {
        Optional<User> user = userRepository.findById(updateGroupRequest.getUserId());
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(updateGroupRequest.getGroupId());
        // 유저나 그룹 자체가 없는 경우
        if (user.isEmpty() || groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user or group");
        }
        Long gid = groupInfo.get().getGroupId();
        UUID uid = user.get().getUserId();
        Optional<GroupJoin> group = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        // 둘 다 있지만 속하지 않은 경우
        if (group.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "not in the group");
        }
        group.get().updateGroupName(updateGroupRequest.getGroupName());
        groupJoinRepository.save(group.get());
    }

}
