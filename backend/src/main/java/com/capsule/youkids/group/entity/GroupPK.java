package com.capsule.youkids.group.entity;

import com.capsule.youkids.user.entity.User;
import java.io.Serializable;
import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Builder;
import lombok.Data;

@Data
@Embeddable
public class GroupPK implements Serializable {
    private GroupInfo groupInfo;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Builder
    public GroupPK(GroupInfo groupInfo, User user) {
        this.groupInfo = groupInfo;
        this.user = user;
    }
}
