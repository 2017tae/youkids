package com.capsule.youkids.group.service;

import com.capsule.youkids.group.dto.request.UpdateGroupRequest;
import com.capsule.youkids.group.dto.response.GroupResponse;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.dto.request.GroupUserRequest;
import java.util.List;
import java.util.UUID;

public interface GroupService {

    // 리더가 그룹에 사람 추가하기
    public void addUserInGroup(GroupUserRequest addUserRequest);

    // 리더가 그룹에서 사람 제거하기
    public void deleteUserFromGroup(GroupUserRequest groupUserRequest);

    // 유저가 속한 모든 그룹 불러오기
    public GroupResponse getAllJoinedGroup(UUID userId);

    // 유저가 자기가 속한 그룹 이름 바꾸기
    public void updateGroupName(UpdateGroupRequest updateGroupRequest);
}
