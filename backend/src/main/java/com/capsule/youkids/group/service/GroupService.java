package com.capsule.youkids.group.service;

import com.capsule.youkids.group.entity.GroupInfo;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;

public interface GroupService {

    // 리더가 그룹에 사람 추가하기
    public void addUserInGroup(Long groupId, UUID userId);

    // 리더가 그룹에서 사람 제거하기
    public void deleteUserFromGroup(Long groupId, UUID userId);

    // 유저가 속한 모든 그룹 불러오기
    public List<GroupInfo> getAllJoinedGroup(UUID userId);

    // 유저가 자기가 속한 그룹 이름 바꾸기
    public void updateGroupName(Long groupId, UUID userId, String groupName);
}
