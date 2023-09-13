package com.capsule.youkids.group.dto.response;

import com.capsule.youkids.group.entity.GroupInfo;
import java.util.List;
import lombok.Builder;

public class GroupResponse {
    private List<GroupInfo> groupInfoList;

    @Builder
    public GroupResponse(List<GroupInfo> groupInfoList) {
        this.groupInfoList = groupInfoList;
    }
}
