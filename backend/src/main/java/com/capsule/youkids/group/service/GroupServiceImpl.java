package com.capsule.youkids.group.service;

import com.capsule.youkids.group.dto.request.GroupUserRequest;
import com.capsule.youkids.group.dto.request.RegistUserRequest;
import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.dto.response.UserResponse;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.repository.GroupInfoRepository;
import com.capsule.youkids.group.repository.GroupJoinRepository;
import com.capsule.youkids.user.entity.Role;
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
    public boolean checkUserInGroup(RegistUserRequest registUserRequest) throws Exception {
        Optional<User> leader = userRepository.findById(registUserRequest.getLeaderId());
        Optional<User> user = userRepository.findByEmailAndRoleNot(registUserRequest.getUserEmail(), Role.DELETED);

        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }

        // 리더가 그룹이 없으면 에러~ (사실 가입 시 그룹이 만들어져 있어서 무의미한 필터링이긴 함)
        // 리더가 리더가 아니거나(파트너에 종속되어 있음)
        UUID lid = leader.get().getUserId();
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(lid);
        if (groupInfo.isEmpty() || !leader.get().isLeader()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }

        // 유저가 리더의 파트너인 경우
        UUID uid = user.get().getUserId();
        if (leader.get().getPartnerId() != null && leader.get().getPartnerId().equals(uid)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "partner");
        }

        UUID gid = groupInfo.get().getGroupId();
        Optional<GroupJoin> group = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        // 이미 추가되어 있으면 에러~
        if (group.isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already exists");
        }

        return true;
    }


    @Override
    public void addUserInGroup(RegistUserRequest registUserRequest) throws Exception {
        Optional<User> leader = userRepository.findById(registUserRequest.getLeaderId());
        Optional<User> user = userRepository.findByEmailAndRoleNot(registUserRequest.getUserEmail(), Role.DELETED);

        // 유저가 없으면 에러~
        if (leader.isEmpty() || user.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no user exists");
        }

        // 리더가 그룹이 없으면 에러~ (사실 가입 시 그룹이 만들어져 있어서 무의미한 필터링이긴 함)
        // 리더가 리더가 아니거나(파트너에 종속되어 있음)
        UUID lid = leader.get().getUserId();
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(lid);
        if (groupInfo.isEmpty() || !leader.get().isLeader()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }

        // 유저가 리더의 파트너인 경우
        UUID uid = user.get().getUserId();
        if (leader.get().getPartnerId() != null && leader.get().getPartnerId().equals(uid)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "partner");
        }

        UUID gid = groupInfo.get().getGroupId();
        Optional<GroupJoin> group = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        // 이미 추가되어 있으면 에러~
        if (group.isPresent()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already exists");
        }

        // ----------------------------------분리---------------------------------
        // 이 시점에서 초대를 보내서 승락 시 아래 서비스 수행
        // ----------------------------------분리---------------------------------

        // 등록 대상이 되는 유저가 속해있는 그룹의 수 + 1
        int newGroupIndex = groupJoinRepository.findByUserIdOrderByCreatedTime(uid).size() + 1;

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
        UUID lid = leader.get().getUserId();
        Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(leader.get().getUserId());
        if (groupInfo.isEmpty() || !leader.get().isLeader()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "no group exists");
        }

        // 유저가 리더의 파트너인 경우
        UUID uid = user.get().getUserId();
        if (leader.get().getPartnerId() != null && leader.get().getPartnerId().equals(uid)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "partner");
        }

        // 이미 없으면 에러~
        UUID gid = groupInfo.get().getGroupId();
        Optional<GroupJoin> groupJoin = groupJoinRepository.findByGroupIdAndUserId(gid, uid);
        if (groupJoin.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "already not in the group");
        }

        // 삭제
        groupJoinRepository.deleteByGroupIdAndUserId(gid, uid);

        // 그럼 알람을 보내말아
    }

    @Override
    public List<GroupResponse> getAllJoinedGroup(UUID id) throws Exception {
        Optional<User> user = userRepository.findById(id);
        // 유저가 있으면 그룹에 속한 정보를 모두 불러와서
        if (user.isPresent()) {
            List<GroupResponse> groupResponseList = new ArrayList<>();
            // 내가 리더가 아니면 파트너 그룹도 불러오기
            if (!user.get().isLeader() && user.get().getPartnerId() != null) {
                Optional<GroupInfo> groupInfo = groupInfoRepository.findByLeaderId(user.get().getPartnerId());
                Optional<User> leader = userRepository.findById(user.get().getPartnerId());
                GroupResponse gr = GroupResponse.builder().
                        groupId(groupInfo.get().getGroupId()).
                        leaderId(leader.get().getUserId()).
                        groupName(String.format("%s님의 그룹", leader.get().getNickname())).
                        groupImg(groupInfo.get().getGroupImg()).
                        build();
                groupResponseList.add(gr);
            }
            List<GroupJoin> groupList = groupJoinRepository.findByUserIdOrderByCreatedTime(user.get().getUserId());
            // 그룹 정보를 추출해낸다~
            for (GroupJoin g : groupList) {
                Optional<GroupInfo> gi = groupInfoRepository.findById(g.getGroupId());
                // 내가 리더가 아니면 내 그룹은 넣지 않기
                if (!user.get().isLeader() && gi.get().getLeaderId().equals(user.get().getUserId())) {
                  continue;
                }
                Optional<User> leader = userRepository.findById(gi.get().getLeaderId());
                GroupResponse gr = GroupResponse.builder().
                        groupId(g.getGroupId()).
                        leaderId(leader.get().getUserId()).
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
    public List<UserResponse> getAllJoinedUser(UUID groupId) throws Exception {
        Optional<GroupInfo> groupInfo = groupInfoRepository.findById(groupId);
        if (groupInfo.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "no group");
        }
        List<GroupJoin> groupJoinList = groupJoinRepository.findByGroupIdOrderByCreatedTime(groupInfo.get().getGroupId());
        List<UserResponse> userResponseList = new ArrayList<>();
        for (GroupJoin gr : groupJoinList) {
            Optional<User> u = userRepository.findById(gr.getUserId());
            if(!u.isEmpty()){
                UserResponse ur = UserResponse.builder()
                        .userId(u.get().getUserId())
                        .nickname(u.get().getNickname())
                        .profileImage(u.get().getProfileImage())
                        .description(u.get().getDescription())
                        .build();
                userResponseList.add(ur);
            }
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
        UUID gid = groupInfo.get().getGroupId();
        UUID uid = user.get().getUserId();
        Optional<GroupJoin> groupJoin = groupJoinRepository.findByGroupIdAndUserId(gid, uid);

        // 둘 다 있지만 속하지 않은 경우
        if (groupJoin.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "not in the group");
        }
        groupJoin.get().updateGroupName(updateGroupRequest.getGroupName());
        groupJoinRepository.save(groupJoin.get());
    }

}
